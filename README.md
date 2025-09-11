
# 주의 사항

```bash
stow 폴더명 # --> 링크를 만드는 명령어
stow -D 폴더명 # --> 만들어진 링크를 삭제하는 명령어

# 폴더 구조가 바뀌었을 때는 링크를 삭제하고 다시 만들어준다.
# 다시 만드는 명령어가 있을듯한데?

stow -R 폴더명 # --> 재적용 명령어라인
```

이렇게 세팅하면 홈디렉토리에 설정파일들에 대한 링크가 생긴다!

## 관리 원칙

1. 폴더들을 만약 zsh폴더라고 한다면
    그 안에는 여러 개의 폴더를 넣지 말고
    하나의 폴더 안에 여러 개의 폴더를 넣어서 관리!
    그렇게 하지 않고 zsh 폴더 안에 또 다른 대상들을 넣게 되면
    변경될 때마다 stow -D로 링크를 지우고 다시 만들어줘야한다.
    하나의 폴더로 모두 관리하면 해당 폴더의 내용이 바뀌더라도
    아무런 문제가 없다.
2. 최소한의 설정 파일들만 zsh폴더에 넣는다.
    .zshrc 혹은 .zshenv 같은 무조건 홈에 있어야하는 파일들만 넣어준다.
    이 외의 파일들은 1번에서 만든 하나의 디렉토리 안에서 관리한다.
3. 

## bash

zsh는 nvim에서 lsp, formatter, linter 지원이 너무 박하다.
그래서 모두 bash로 변경!

### XDG

XDG = freedesktop.org의 Cross-Desktop Group 에서 정한 **데스크톱 표준(specification)**을 줄여 부르는 말입니다.
리눅스/유닉스 환경에서 프로그램들이 설정 파일, 캐시, 데이터 파일을 어디에 저장할지 경로 규칙을 통일하자는 취지에서 나왔습니다.

📌 XDG Base Directory Specification

대표적인 게 바로 XDG Base Directory 규칙이에요.

환경변수	기본값 (보통)	의미
$XDG_CONFIG_HOME	~/.config	설정 파일(.conf 등)을 저장
$XDG_DATA_HOME	~/.local/share	애플리케이션 데이터 저장
$XDG_CACHE_HOME	~/.cache	캐시 데이터 저장

즉, ~/.bashrc, ~/.vimrc 같은 홈 디렉터리 어질러놓기 대신

설정은 ~/.config/appname/

캐시는 ~/.cache/appname/

데이터는 ~/.local/share/appname/
에 정리하자는 거죠.


## zsh

rc.d 폴더에 다양한 설정들을 나누어서 넣으면
이 폴더의 모든 파일들을 .zshrc에서 읽어서 source로 실행해준다.

여기서 xx로 시작하는 확장자 zsh파일들은 리파지토리에 스테이징 되지 않으므로
민감한 api key들은 이렇게 관리하면 된다.

.zshrc .zshenv .zshprofile

- zshrc -> 일반적으로 여기에 모드 넣는다.
- zshenv -> PATH나 환경변수들을 여기에 설정하면 좋다.
- zshprofile -> 로그인에서 불러오는 설정

### zsh free -> bash

zsh는 lsp, linteer, formatter까지 어느 하나 성숙해 있지 않음
모두 bash로 옮긴다.


## nvim

설치해줘야하는 대상들이 있다.
fzf, rg, 그리고 lsp들!
많은 lsp들을 mason으로 처리하고 있지만
제대로 지원하지 못하거나 깨지는 lsp들이 있는데
이들은 글로벌로 직접 설치해주는게 좋다.

## tmux

- 설치가 필요한 패키지, memmory 사용량과 cpu 사용량 확인을 위해서
    딱히, 시스템 패키지로 설치할 필요는 없고 tmux플러그인이 설치되면 OK
- 플러그인을 설치해줘야한다. Ctrl-b + I(대문자)
    Tmux 기본 키매핑을 정리해두면 좋을까?
- 완전히 새롭게 리로드 하려면 tmux kill-server
- C-b [ : 이를 통해서 현재 창의 내용을 복사할 수 있다.
- M-p를 통해서 floax 플러그인을 통해서 팝업창을 띄운다.

nvim에서 tmux파일에 대한 인식처리
현재 .tmux.conf만 tmux파일로 처리하고 내가 만든 다른 파일들은 인식을 하지 못함
tmux파일은 conf라고 확장자가 붙지만 tmux전용 언어를 쓴다.
따라서 nvim에서 이 파일들을 tmux파일로 인식되도록 해야한다.
파일명보다는 특정 폴더명 아래에 두는게 깔끔할듯하다.

.tmux폴더 아래에 세팅을 두는게 낫지 않을까 싶다.
고민해봐야할 부분이다.

# 시도해볼 만한 도구들

- pass
- sesh
- bash-completion
