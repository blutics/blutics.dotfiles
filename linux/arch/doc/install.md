
# 설치 순서

1. neovim, git, stow 설치 -> pacman -Syu neovim git stow
2. 루트 홈에서 dotfiles폴더 클론하기
3. set_locale.sh -> init.sh 실행하기
4. stow bash 
5. ansible-playbook -i localhost.ini site.yml -K 
6. stow nvim tmux
7. tmux script 실행하기


