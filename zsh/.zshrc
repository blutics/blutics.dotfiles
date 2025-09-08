# rc.d 아래의 *.zsh를 순서대로 소스
for f in "$HOME/zsh/rc.d/"*.zsh(.Nr); do
  source "$f"
done







