
# 주의 사항

```bash
stow 폴더명
```

이렇게 세팅하면 홈디렉토리에 설정파일들에 대한 링크가 생긴다!


## zsh

rc.d 폴더에 다양한 설정들을 나누어서 넣으면
이 폴더의 모든 파일들을 .zshrc에서 읽어서 source로 실행해준다.

여기서 xx로 시작하는 확장자 zsh파일들은 리파지토리에 스테이징 되지 않으므로
민감한 api key들은 이렇게 관리하면 된다.

.zshrc .zshenv .zshprofile

- zshrc -> 일반적으로 여기에 모드 넣는다.
- zshenv -> PATH나 환경변수들을 여기에 설정하면 좋다.
- zshprofile -> 로그인에서 불러오는 설정


## nvim

설치해줘야하는 대상들이 있다.
fzf, rg, 그리고 lsp들!
많은 lsp들을 mason으로 처리하고 있지만
제대로 지원하지 못하거나 깨지는 lsp들이 있는데
이들은 글로벌로 직접 설치해주는게 좋다.

## tmux

설치가 필요한 패키지, memmory 사용량과 cpu 사용량 확인을 위해서

플러그인을 설치해줘야한다. Ctrl-b + I(대문자)
Tmux 기본 키매핑을 정리해두면 좋을까?

완전히 새롭게 리로드 하려면 tmux kill-server



