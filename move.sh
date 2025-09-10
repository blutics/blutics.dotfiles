#!/usr/bin/env bash

# ==============================================================================
#  move_and_own.sh
#
#  Description: Moves the current directory (which must be under /root) to a
#               target user's home directory and changes its ownership.
#  Usage:       Run this script as root from within the directory you want to move.
#               Example:
#               # cd /root/my_project
#               # ./move_and_own.sh
# ==============================================================================

# 색상 코드 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# --- 1. 사전 검사 (Safety Checks) ---

# 스크립트가 root로 실행되었는지 확인
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}오류: 이 스크립트는 반드시 root 권한으로 실행해야 합니다.${NC}"
    exit 1
fi

# 현재 위치가 /root의 하위 디렉터리인지 확인
CURRENT_DIR=$(pwd)
if [[ "$CURRENT_DIR" != /root/* || "$CURRENT_DIR" == "/root" ]]; then
    echo -e "${RED}오류: 이 스크립트는 /root 디렉터리 바로 아래의 하위 폴더에서 실행해야 합니다.${NC}"
    echo -e "(예: /root/my_project)"
    exit 1
fi

# 이동할 폴더 이름 추출
FOLDER_NAME=$(basename "$CURRENT_DIR")

# --- 2. 사용자 입력 받기 ---

echo "현재 폴더 '${FOLDER_NAME}'를 다른 사용자의 홈으로 이동하고 소유권을 이전합니다."
read -p "이동받을 대상 사용자의 이름을 입력하세요: " TARGET_USER

# --- 3. 입력 및 환경 검증 ---

# 대상 사용자가 존재하는지 확인
if ! id "$TARGET_USER" &>/dev/null; then
    echo -e "${RED}오류: '${TARGET_USER}'라는 사용자는 존재하지 않습니다.${NC}"
    exit 1
fi

# 대상 사용자의 홈 디렉터리 경로 확인
TARGET_HOME=$(eval echo ~$TARGET_USER)
if [ ! -d "$TARGET_HOME" ]; then
    echo -e "${RED}오류: '${TARGET_USER}' 사용자의 홈 디렉터리를 찾을 수 없습니다.${NC}"
    exit 1
fi

# 최종 목적지 경로 설정 및 충돌 확인
DESTINATION_PATH="$TARGET_HOME/$FOLDER_NAME"
if [ -e "$DESTINATION_PATH" ]; then
    echo -e "${RED}오류: 대상 위치에 이미 같은 이름의 파일이나 폴더가 존재합니다.${NC}"
    echo "  -> ${DESTINATION_PATH}"
    exit 1
fi

# --- 4. 최종 확인 ---

echo -e "\n--------------------------------------------------"
echo -e "${YELLOW}아래 작업을 실행합니다:${NC}"
echo "  - 이동할 폴더: ${CURRENT_DIR}"
echo "  - 새로운 위치: ${DESTINATION_PATH}"
echo "  - 새로운 소유자: ${TARGET_USER}"
echo "--------------------------------------------------"
read -p "정말로 진행하시겠습니까? (y/N): " CONFIRM

if [[ "${CONFIRM,,}" != "y" ]]; then
    echo "작업이 취소되었습니다."
    exit 0
fi

# --- 5. 명령어 실행 ---

echo -e "\n1. 폴더를 이동합니다..."
mv "$CURRENT_DIR" "$TARGET_HOME/"
if [ $? -ne 0 ]; then
    echo -e "${RED}오류: 폴더 이동에 실패했습니다.${NC}"
    exit 1
fi

echo "2. 소유권을 변경합니다..."
chown -R "$TARGET_USER:$TARGET_USER" "$DESTINATION_PATH"
if [ $? -ne 0 ]; then
    echo -e "${RED}오류: 소유권 변경에 실패했습니다.${NC}"
    exit 1
fi

echo -e "\n--------------------------------------------------"
echo -e "${GREEN}✅ 모든 작업이 성공적으로 완료되었습니다.${NC}"
echo "  '${FOLDER_NAME}' 폴더가 '${DESTINATION_PATH}'로 이동되었으며,"
echo "  소유권이 '${TARGET_USER}' 사용자에게 이전되었습니다."
echo "--------------------------------------------------"

exit 0
