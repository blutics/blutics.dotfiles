#!/usr/bin/env bash
set -euo pipefail

TPM_DIR="${HOME}/.tmux/plugins/tpm"
TPM_REPO="https://github.com/tmux-plugins/tpm"

# Home Manager로 tmux 플러그인 관리 중이면 건너뜀(환경에 맞게 조건 커스터마이즈)
if command -v home-manager >/dev/null 2>&1; then
  if home-manager generations | grep -qi tmux && \
     tmux -V >/dev/null 2>&1; then
    echo "[info] Home Manager로 tmux 플러그인을 관리한다면 TPM 설치는 생략하세요."
    # 원한다면 여기서 read -p로 계속 진행 여부 묻기
  fi
fi

# tpm 설치
if [ ! -d "${TPM_DIR}" ]; then
  echo "[info] cloning tpm into ${TPM_DIR}"
  git clone --depth 1 "${TPM_REPO}" "${TPM_DIR}"
else
  echo "[info] tpm already exists, pulling latest"
  git -C "${TPM_DIR}" pull --ff-only || true
fi

# tmux.conf가 있어야 플러그인 목록을 읽음
if [ ! -f "${HOME}/.tmux.conf" ]; then
  echo "[warn] ~/.tmux.conf not found. stow 혹은 링크를 먼저 적용하세요."
  exit 0
fi

# tmux 내부/외부 모두에서 동작: TMUX 비우고 실행(중첩 방지)
echo "[info] installing tmux plugins via TPM"
TMUX= "${TPM_DIR}/bin/install_plugins"      || true
TMUX= "${TPM_DIR}/bin/update_plugins" all   || true
TMUX= "${TPM_DIR}/bin/clean_plugins"        || true

echo "[done] tpm + plugins ready."

