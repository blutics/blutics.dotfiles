#!/usr/bin/env bash

set -euo pipefail

log() { printf '\033[1;34m[*]\033[0m %s\n' "$*"; }
die() { printf '\033[1;31m[!]\033[0m %s\n' "$*" >&2; exit 1; }

[[ $EUID -eq 0 ]] || die "root로 실행하세요 (sudo 사용)."
command -v pacman >/dev/null || die "이 스크립트는 Arch/Arch 기반에서만 사용하세요."
command -v localectl >/dev/null || die "systemd(localectl)가 필요합니다."

TS="$(date +%Y%m%d-%H%M%S)"

# 1) man/폰트 등 필요한 패키지
log "패키지 설치(man-db, man-pages, groff, less, 폰트)…"
pacman -Sy --needed --noconfirm man-db man-pages groff less noto-fonts-cjk noto-fonts-emoji texinfo || \
  die "패키지 설치 실패"

# 2) /etc/locale.gen: en_US.UTF-8, ko_KR.UTF-8 활성화
log "/etc/locale.gen 백업 및 수정"
cp -a /etc/locale.gen "/etc/locale.gen.bak.$TS"

enable_locale() {
  local entry="$1" file="/etc/locale.gen"
  if grep -Eq "^[#[:space:]]*${entry//./\\.}$" "$file"; then
    sed -i -E "s|^#\s*(${entry//./\\.})|\1|" "$file"
  elif ! grep -Eq "^[[:space:]]*${entry//./\\.}$" "$file"; then
    echo "$entry" >> "$file"
  fi
}
enable_locale "en_US.UTF-8 UTF-8"
enable_locale "ko_KR.UTF-8 UTF-8"

log "locale-gen 실행"
locale-gen

# 3) 시스템 로케일: 메시지는 영어, 서식은 한국
log "시스템 로케일 설정(LANG=en_US.UTF-8, 한국 지역 서식)…"
localectl set-locale \
  LANG=en_US.UTF-8 \
  LC_MESSAGES=en_US.UTF-8 \
  LC_TIME=ko_KR.UTF-8 \
  LC_NUMERIC=ko_KR.UTF-8 \
  LC_MONETARY=ko_KR.UTF-8 \
  LC_PAPER=ko_KR.UTF-8 \
  LC_MEASUREMENT=ko_KR.UTF-8 \
  LC_ADDRESS=ko_KR.UTF-8 \
  LC_TELEPHONE=ko_KR.UTF-8

# 4) man은 항상 영어로
log "/etc/profile.d/10-man-en.sh 생성(MANOPT=-L en_US.UTF-8)"
cat >/etc/profile.d/10-man-en.sh <<'EOF'
# Force English man pages while keeping UTF-8
export MANOPT="${MANOPT:-"-L en_US.UTF-8"}"
EOF
chmod 644 /etc/profile.d/10-man-en.sh

# 5) 시간대: Asia/Seoul
log "시간대 Asia/Seoul 설정"
timedatectl set-timezone Asia/Seoul

# 6) 요약 출력
log "적용 결과(현재 셸엔 재로그인 후 완전 반영):"
echo "  locale: $(/usr/bin/locale | tr '\n' ' ' | sed 's/ $/\n/')"
echo "  timezone: $(timedatectl show -p Timezone --value)"
echo "  man locale 테스트: man --locale => $(man --locale 2>/dev/null | head -n1 || true)"

log "완료. 새 로그인/새 터미널을 열면 설정이 반영됩니다."

