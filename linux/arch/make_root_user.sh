#!/usr/bin/env bash
# make_root_user.sh
# Arch 계열: 지정 사용자 생성/갱신 + wheel/sudo 권한 부여
# (WSL이면) /etc/wsl.conf에 default 사용자와 systemd=true 설정

set -euo pipefail

need_root() { [ "${EUID:-$(id -u)}" -eq 0 ] || { echo "Run as root (sudo)"; exit 1; }; }
is_wsl() { grep -qi microsoft /proc/version || [ -e /proc/sys/fs/binfmt_misc/WSLInterop ]; }
has_cmd() { command -v "$1" >/dev/null 2>&1; }

need_root

# 1) 사용자명 입력(환경변수 TARGET_USER로도 지정 가능)
TARGET_USER="${TARGET_USER:-}"
while [ -z "${TARGET_USER}" ]; do
  read -r -p "만들거나 갱신할 사용자명을 입력하세요: " TARGET_USER
  TARGET_USER="${TARGET_USER// /}"  # 공백 제거
  # 리눅스 사용자명 유효성(대략)
  if ! [[ "$TARGET_USER" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
    echo "유효하지 않은 사용자명입니다. 소문자/숫자/언더스코어/하이픈만 허용됩니다."
    TARGET_USER=""
  fi
done

echo "[1/7] wheel 그룹 보장"
getent group wheel >/dev/null || groupadd wheel

echo "[2/7] 사용자 생성/갱신"
if id -u "$TARGET_USER" >/dev/null 2>&1; then
  echo " - 사용자 존재: $TARGET_USER (wheel 그룹에 추가 보장)"
  usermod -aG wheel,users "$TARGET_USER"
else
  useradd -m -s /bin/bash -G wheel,users "$TARGET_USER"
  echo " - 사용자 생성 완료: $TARGET_USER"
fi

echo "[3/7] sudo 설치 확인"
if ! has_cmd sudo; then
  if has_cmd pacman; then
    pacman -Sy --noconfirm sudo
  else
    echo "pacman을 찾을 수 없습니다. Arch 계열이 맞는지 확인하세요." >&2
    exit 1
  fi
fi

echo "[4/7] sudoers 설정 방식 선택"
read -r -p " - wheel 그룹에 '비밀번호 없이 sudo(NOPASSWD)'를 허용할까요? [y/N]: " yn
yn="${yn:-N}"
sudoers_file="/etc/sudoers.d/99_wheel"
if [[ "$yn" =~ ^[Yy]$ ]]; then
  echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" > "$sudoers_file"
  mode_desc="NOPASSWD"
else
  echo "%wheel ALL=(ALL:ALL) ALL" > "$sudoers_file"
  mode_desc="패스워드 필요"
fi
chmod 0440 "$sudoers_file"
if has_cmd visudo; then
  visudo -cf "$sudoers_file" >/dev/null
fi

echo "[5/7] 비밀번호 설정 여부"
while :; do
  read -r -p " - 지금 비밀번호를 설정할까요? [y/N]: " setpw
  setpw="${setpw:-N}"
  if [[ "$setpw" =~ ^[Yy]$ ]]; then
    read -rs -p "   새 비밀번호 입력: " pw1; echo
    read -rs -p "   새 비밀번호 확인: " pw2; echo
    if [[ -z "$pw1" ]]; then
      echo "   비밀번호가 비어 있습니다. 다시 시도하세요."
      continue
    fi
    if [[ "$pw1" != "$pw2" ]]; then
      echo "   불일치합니다. 다시 시도하세요."
      continue
    fi
    echo "${TARGET_USER}:${pw1}" | chpasswd
    pw_status="설정됨"
    break
  else
    pw_status="미설정(필요 시 'passwd ${TARGET_USER}')"
    break
  fi
done

echo "[6/7] (WSL 감지 시) /etc/wsl.conf 구성"
if is_wsl; then
  wslconf="/etc/wsl.conf"
  if [ -f "$wslconf" ]; then
    cp -a "$wslconf" "${wslconf}.bak.$(date +%Y%m%d%H%M%S)"
  fi
  cat > "$wslconf" <<EOF
[boot]
systemd=true
[user]
default=${TARGET_USER}
EOF
  chmod 0644 "$wslconf"
  echo " - wsl.conf 갱신 완료 (기본 사용자=${TARGET_USER}, systemd=true)"
  echo " - Windows PowerShell에서 'wsl --shutdown' 후 재진입해야 적용됩니다."
else
  echo " - WSL 아님: wsl.conf 변경 스킵"
fi

echo "[7/7] 요약"
echo " - 사용자      : ${TARGET_USER}"
echo " - 그룹        : wheel (sudo 권한)"
echo " - sudoers     : ${sudoers_file} (${mode_desc})"
echo " - 비밀번호    : ${pw_status}"
echo " - WSL         : $(is_wsl && echo '감지됨(설정 적용)' || echo '아님')"
echo "완료."

rm "/home/${TARGET_USER}/.bashrc" "/home/${TARGET_USER}/.bash_profile"
