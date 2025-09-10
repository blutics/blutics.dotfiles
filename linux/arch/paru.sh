#!/usr/bin/env bash
# install_paru_and_aur.sh
# Arch/Manjaro/EndeavourOS 계열에서 paru 설치 + AUR 패키지 설치
# 사용법:
#   sudo bash install_paru_and_aur.sh
#   AUR_PKGS="vivid eza zoxide starship dprint-bin" sudo -E bash install_paru_and_aur.sh
#
# 비번 없는 자동화를 원하면 미리 pacman만 NOPASSWD로 열어두면(권장) 더 매끈합니다.
#   echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/pacman" | sudo tee /etc/sudoers.d/10-aur-pacman >/dev/null
# 또는 비상용으로 환경변수 SUDO_PASS를 주면 askpass로 무인 설치가 가능합니다(보안 주의).

set -euo pipefail

# -------- 설정 --------
AUR_PKGS=${AUR_PKGS:-"vivid eza zoxide starship dprint-bin"}
TARGET_USER=${SUDO_USER:-$USER}
if [[ "$TARGET_USER" == "root" ]]; then
  echo "!! AUR 빌드는 root가 아닌 일반 사용자로 해야 합니다. sudo로 실행했다면 SUDO_USER가 비어 root로 인식된 경우입니다."
  echo "   일반 사용자 계정에서 'sudo bash $0' 로 재실행하세요."
  exit 1
fi
USER_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)
WORKDIR="$USER_HOME/.cache/paru-build/paru-bin"

# -------- 유틸 --------
msg(){ printf "\n==> %s\n" "$*"; }
run_as_user(){ runuser -u "$TARGET_USER" -- bash -lc "$*"; }

# -------- 사전 점검 --------
if ! command -v pacman >/dev/null 2>&1; then
  echo "이 스크립트는 pacman 기반 배포(Arch 등)에서만 동작합니다." >&2
  exit 1
fi

# 선택: SUDO_PASS가 주어졌다면 askpass 준비(tty 없이도 sudo 가능)
ASKPASS=""
if [[ -n "${SUDO_PASS:-}" ]]; then
  ASKPASS="$USER_HOME/.cache/paru-build/askpass.sh"
  mkdir -p "$(dirname "$ASKPASS")"
  install -m 700 /dev/null "$ASKPASS"
  cat >"$ASKPASS" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "${SUDO_PASS:?}"
EOF
  chown "$TARGET_USER:$TARGET_USER" "$ASKPASS"
fi

# -------- 시스템 필수 패키지 --------
msg "필수 패키지 설치(base-devel, git, curl 등)"
sudo pacman -Syu --needed --noconfirm base-devel git curl fakeroot

# -------- paru 설치(없으면) --------
if ! command -v paru >/dev/null 2>&1; then
  msg "paru 미설치 → 빌드 디렉터리 준비: $WORKDIR"
  install -d -m 755 -o "$TARGET_USER" -g "$TARGET_USER" "$WORKDIR"

  if [[ ! -d "$WORKDIR/.git" ]]; then
    msg "AUR에서 paru-bin 클론"
    run_as_user "git clone --depth=1 https://aur.archlinux.org/paru-bin.git '$WORKDIR'"
  else
    msg "paru-bin 갱신"
    run_as_user "cd '$WORKDIR' && git pull --rebase --autostash || true"
  fi

  msg "makepkg로 paru-bin 빌드"
  run_as_user "cd '$WORKDIR' && makepkg -f --noconfirm"

  PKG_FILE=$(ls -1 "$WORKDIR"/*.pkg.tar.* | grep -v '\-debug\-' | head -n1)
  [[ -n "$PKG_FILE" ]] || { echo "빌드 산출물(.pkg.tar.*)을 찾지 못했습니다." >&2; exit 1; }

  msg "pacman으로 paru 설치: $PKG_FILE"
  if [[ -n "$ASKPASS" ]]; then
    SUDO_ASKPASS="$ASKPASS" sudo -A pacman -U --noconfirm "$PKG_FILE"
  else
    sudo pacman -U --noconfirm "$PKG_FILE"
  fi
else
  msg "paru 이미 설치됨"
fi

# -------- paru 기본 설정(질문 줄이기) --------
PARU_CONF="$USER_HOME/.config/paru/paru.conf"
if [[ ! -f "$PARU_CONF" ]]; then
  msg "paru 기본 설정 생성(~/.config/paru/paru.conf)"
  install -d -m 755 -o "$TARGET_USER" -g "$TARGET_USER" "$(dirname "$PARU_CONF")"
  cat | tee "$PARU_CONF" >/dev/null <<'EOF'
[options]
BottomUp
SkipReview
SudoLoop
CleanAfter
Devel
# EditPKGBUILD
# BatchInstall
EOF
  chown "$TARGET_USER:$TARGET_USER" "$PARU_CONF"
fi

# -------- AUR 패키지 설치 --------
if [[ -n "$AUR_PKGS" ]]; then
  msg "AUR 패키지 설치: $AUR_PKGS"
  if [[ -n "$ASKPASS" ]]; then
    # TTY 없이 sudo 필요 시
    run_as_user "SUDO_ASKPASS='$ASKPASS' paru --sudo 'sudo -A' -S --needed --noconfirm --skipreview $AUR_PKGS"
  else
    run_as_user "paru -S --needed --noconfirm --skipreview --sudoloop $AUR_PKGS"
  fi
else
  msg "설치할 AUR 패키지가 지정되지 않았습니다(AUR_PKGS 비움)."
fi

msg "완료"

