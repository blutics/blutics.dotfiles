#!/usr/bin/env bash
# set_locale.sh — Arch/WSL용 로케일 설정 스크립트
# 사용:
#   sudo bash set_locale.sh                 # 기본 en_US.UTF-8
#   sudo bash set_locale.sh --lang ko       # ko_KR.UTF-8
#   sudo LOCALE_CHOICE=ko bash set_locale.sh

set -euo pipefail

# --- 입력 파싱: --lang en|ko 또는 환경변수 LOCALE_CHOICE=en|ko ---
CHOICE="${LOCALE_CHOICE:-}"
if [[ $# -ge 2 && "${1:-}" == "--lang" ]]; then
  CHOICE="$2"
fi
CHOICE="${CHOICE:-en}"   # 기본 en

case "$CHOICE" in
  en|en_US|en_US.UTF-8) DEFAULT_LOCALE="en_US.UTF-8" ;;
  ko|ko_KR|ko_KR.UTF-8) DEFAULT_LOCALE="ko_KR.UTF-8" ;;
  *) echo "지원: en | ko  (예: --lang ko)"; exit 1 ;;
esac

# --- /etc/locale.gen 에서 해당 라인 보장(주석 해제 또는 추가) ---
ensure_locale_line() {
  local spec="$1"   # 예: "en_US.UTF-8 UTF-8"
  if grep -Eq "^[#\s]*${spec}\s*$" /etc/locale.gen; then
    # 라인이 있으면 주석 제거
    sed -i -E "s|^[#\s]*(${spec})\s*$|\1|" /etc/locale.gen
  else
    echo "$spec" >> /etc/locale.gen
  fi
}

# 보통 두 로케일을 모두 생성해 두면 편합니다(기본은 DEFAULT_LOCALE로 설정)
ensure_locale_line "en_US.UTF-8 UTF-8"
ensure_locale_line "ko_KR.UTF-8 UTF-8"

# --- 로케일 생성 ---
locale-gen

# --- 시스템 기본 로케일 지정 ---
printf 'LANG=%s\n' "$DEFAULT_LOCALE" > /etc/locale.conf

# --- 현재 셸에도 즉시 반영 ---
export LANG="$DEFAULT_LOCALE"
export LC_ALL="$DEFAULT_LOCALE"

# --- 요약 출력 ---
echo "Default locale set to: $DEFAULT_LOCALE"
echo "Available locales:"
locale -a | grep -E 'en_US\.utf8|ko_KR\.utf8' || true
echo
echo "현재 세션: LANG=$LANG, LC_ALL=$LC_ALL"

