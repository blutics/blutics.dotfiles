export LS_COLORS="$(vivid generate snazzy)"

export LANG=ko_KR.UTF-8
export LC_CTYPE=${LC_CTYPE:-$LANG}
export LESSCHARSET=utf-8
export LESS='-R -S -M -+F -X'


# $HOME/zsh/rc.d 아래의 *.sh를 이름순으로 소스
for f in $(find "$HOME/.config/bash/rc.d" -maxdepth 1 -type f -name '*.sh' | sort); do
  [ -r "$f" ] && . "$f"
done
