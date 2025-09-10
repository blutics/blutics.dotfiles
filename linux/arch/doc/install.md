
# 설치 순서

1. neovim, git, stow 설치 -> pacman -Syu neovim git stow
2. 루트 홈에서 dotfiles폴더 클론하기
3. set_locale.sh -> make_root_user.sh 
4. move.sh -> 이동시키기!
5. wsl --shutdown -> wsl -d archlinux : shutdown 후에는 이제 blutics로 자동으로 로그인 된다.
6. init.sh 실행하기: ansible 설치
7. stow bash 
8. linux/arch로 이동 후! source ~/.bashrc -> 반드시 이동 후 적용!
9. ansible-playbook -i localhost.ini site.yml -K -> sudo로 실행하면 root로 실행되서 폴더나 파일을 사용할 수 없게된다.
10. sudo ./paru -> 2번!
11. source ~/.bashrc 한번 더
12. stow nvim tmux
13. tmux script 실행하기
14. tmux 실행 -> C-b I(대문자): tmux플러그인 설치


