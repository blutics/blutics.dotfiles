#!/usr/bin/env bash
# 1. 현재 설정된 값 보여주기
    echo "Current Git User:"
    echo "  Name:  $(git config --global user.name)"
    echo "  Email: $(git config --global user.email)"
    echo "" # 줄바꿈

    # 2. 새로운 이름과 이메일 입력받기
    read -p "Enter your new Git user name: " user_name
    read -p "Enter your new Git user email: " user_email

    # 3. 입력값이 비어있는지 확인
    if [ -z "$user_name" ] || [ -z "$user_email" ]; then
        echo ""
        echo "❌ Error: Name and email cannot be empty. Aborting."
        return 1
    fi

    # 4. git config 명령어 실행
    git config --global user.name "$user_name"
    git config --global user.email "$user_email"

    echo "" # 줄바꿈
    echo "✅ Git configuration updated successfully!"
    echo "  New Name:  $(git config --global user.name)"
    echo "  New Email: $(git config --global user.email)"
