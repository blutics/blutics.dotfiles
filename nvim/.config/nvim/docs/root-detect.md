# 루트가 왜 중요한가??ㅐ
# 고려해야하는 사항
로컬, local cwd, tcd
글로벌, global cwd
pwd, tcd
lcd
cd, tcd, lcd

window, buffer, tab, global
버퍼와 윈도우는 다른 대상이다
윈도우는 랜더의 단위이고
버퍼는 내용의 단위이다.
하나의 버퍼는 여러 윈도우에서 랜더링 될 수 있다

버퍼는 CWD를 갖지 않는다

작업 디렉토리, 루트 디렉토리, CWD

작업 디렉토리 = CWD, current working directory

루트 디렉토리
  1. 파일시스템의 최상위 = /
  2. 프로젝트 루트, 도구가 기준이라고 정한 폴더!
    -> 이를 정하는 이유는 linter, formatter, lsp가 프로젝트를 기준으로 모든 연결성과 문법을 체크하기 때문

current directory -> 글로벌CWD

tab current directory -> 탭CWD
local current directory -> 윈도CWD = 버퍼?

global cd < tab cd < local cd, 창

글로벌 cwd는 고정, 탭마다 프로젝트 루트를 잡아 사용
autochdir는 충돌이 잦으니 끄는 편이 안전하다고 한다

기본값
시작시 cd만 정해진다 -> nvim을 실행한 쉘의 pwd
tcd와 lcd는 없음 -> 상속만 받는다??

글로벌, 탭, 창

cd < tab < lcd
  이걸 계속 적고 있는데
  lcd가 가장 강력하다!
  이 이미지를 잘 잡아야한다

cd, tcd, lcd와 pwd의 관계
pwd = project working directory
pwd = print working directory

이들은 파일을 찾는 기준이 된다
중요 = 파일을 찾는 기준

:!python ./app.py

터미널 버퍼 주의
  새 터미널은 생성 시점에 창의 유효 cwd를 물려 받는다
    lcd가 있다면 lcd 없다면 tcd
    tcd가 있다면 tcd 없다면 cd!
  이후 터미널 내부에서 cd를 바꾸면, 그건 그 셀 내부 문제이고 vim의 cwd와는 별개이다

working directory의 의미
  -> 절대경로 없이도 일을 진행하게 해주는 일종의 기준점

prd = project root directory

cwd, policy ==== prd, selection

그럼 특정 파일을 연다고 cd, tcd, lcd는 변하는게 아니네?
  cd, tcd, lcd를 실행했을 때
  set autochdir를 켠 경우 버퍼 전환 시 파일 폴더로 이동 - 권장하지 않는다고 함
  rooter, project.nvim, lsp 연동 플러그인 등 -> 내부적으로 chdir을 호출하도록 설정하기도 한다
  
cd는 change directoryf를 의미하며
chdir과도 같다!

chdir은 posix함수이다!


자동 chdir을 끈다는건 어떤 의미야??
파일을 열거나 버퍼/프로젝트가 바뀔 때 에디터나 플러그인이 임의로 작업 디렉터리(CWD)를 바꾸지 못하게 한다는 뜻입니다.
즉, CWD는 당신이 :cd / :tcd / :lcd로 바꿀 때만 변하게 만드는 거죠.

글로벌, 탭, 창, 버퍼, 워킹 디렉토리, 프로젝트 루트
chdir, 상대경로, 절대경로, cd, pwd

vim.fs.root만 쓰면 매번 규칙을 흩뿌려야 하는데, project.nvim은 한 곳에서 패턴을 관리.

결국, 두 종류이다.
작업 디렉토리와 프로젝트 루트 디렉토리

프로젝트 루트 -> '도구'들이 '프로젝트'로 인식하는 논리적 기준점

작업 디렉토리, 루트 디렉토리
렌더 단위, 글로벌, 탭, 창
cd, tcd, lcd, chdir
pwd
cwd

작업 디렉토리와 프로젝트 루트의 메커니즘에 대한 이해
  작업 디렉토리
    내가 하나의 파일에서 작업을 하고 있다고 가정
    파일의 위치가 아니라 작업 디렉토리를 기준으로 무언가를 한다
    나의 위치는 중요하지 준않다. 무조건 작업 디렉토리를 따른다
    작업 디렉토리 -> 작업
    파일과 연결된 기준이 아니라 나의 행동과 관련된 기준
    글로벌, 탭, 창이라는 작업 영역의 기준점들
  프로젝트 루트
    마찬가지로 하나의 파일에서 작업을 한다고 가정
    나의 위치가 중요하다. 내 위치를 시작으로 상위로 특정 폴더를 찾아간다
    그리고 선택된 기준에 따라서 특정 폴더를 찾는다
    현재 파일 -> 프로젝트 루트 -> 작업
    작업 영역이 중요한게 아니다.
    현재 작업 중인 파일과 관련된 기준
    현재 파일을 기준으로 이 파일이 어느 소관인지에 대한 기


그럼 디폴트로 작업 디렉토리가 어떻게 선택되는지가 중요할까?
















