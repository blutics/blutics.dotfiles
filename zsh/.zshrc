

# rc.d 아래의 *.zsh를 순서대로 소스
for f in "$ZDOTDIR/rc.d/"*.zsh(.N); do
  source "$f"
done







