
# 설치 순서

1. neovim, git, stow 설치 -> pacman -Syu neovim git stow
2. 루트 홈에서 dotfiles폴더 클론하기
3. set_locale.sh -> make_root_user.sh -> .bashrc .bash_profile 삭제
4. move.sh -> 이동시키기!
5. init.sh 실행하기: ansible 설치
6. stow bash 
7. linux/arch로 이동 후! source ~/.bashrc -> 반드시 이동 후 적용!
8. ansible-playbook -i localhost.ini site.yml -K 
9. stow nvim tmux
10. tmux script 실행하기


