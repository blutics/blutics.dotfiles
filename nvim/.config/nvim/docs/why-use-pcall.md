pcall은 “Protected Call(보호 호출)”입니다. 함수 실행 중 오류가 나도 에디터 전체가 중단되지 않도록 막아 줍니다. 설정 파일이 크고 의존 플러그인이 많을수록 한 군데의 오류가 연쇄로 퍼지지 않게 하는 안전장치입니다.

왜 쓰는가

* 옵셔널 의존성 보호: 어떤 플러그인이 없거나 아직 로드되지 않아도 전체 초기화가 멈추지 않게 한다.
* 초기화 실패 격리: 특정 모듈의 setup에서 예외가 나도 나머지 설정은 계속 진행된다.
* 폴백 적용: 실패 시 다른 경로로 자연스럽게 넘어가도록 분기할 수 있다.
* 부팅 안정성/사용자 경험: “한 줄 에러로 전부 죽음”을 “로그 남기고 계속”으로 바꿔 준다.
* 로드 순서 유연성: 부팅 시점에 모듈이 없을 수도 있는 상황을 흘려보낼 수 있다.

작동 방식(반환값)

* local ok, r1, r2 = pcall(fn, a, b)
* ok가 true면 정상 실행이고 r1, r2는 함수의 반환값이다.
* ok가 false면 실패이며 r1에는 에러 메시지(문자열)가 들어온다.

자주 쓰는 패턴(평문 예시)

* 모듈이 있을 때만 사용:
  local ok, mod = pcall(require, "gitsigns")
  if ok then mod.setup{} end
* setup 자체 보호:
  local ok, heir = pcall(require, "heirline")
  if not ok then return end
  pcall(heir.setup, { statusline = ... })
* 컬러스킴 적용 실패 무시:
  pcall(vim.cmd.colorscheme, "tokyonight")

언제 쓰지 말아야 하나

* 필수 의존성: 없으면 에디터가 성립하지 않는 경우는 바로 실패를 드러내는 편이 낫다.
  (예: assert(pcall(require, "heirline"), "heirline is required"))
* 남용 금지: 모든 곳에 두르면 버그가 숨겨져 디버깅이 어려워진다. 경계(외부/옵션)에서만 절제해 사용한다.

자주 하는 실수

* pcall(require("x"))처럼 함수 호출 결과를 넘김 → 이미 바깥에서 예외가 발생한다. pcall(require, "x")처럼 “함수 + 인자”로 넘겨야 한다.
* 에러를 삼키기만 하고 기록을 남기지 않음 → 최소한 vim.notify 등으로 한 줄 로그를 남겨라.

xpcall과의 차이

* xpcall(fn, err\_handler, ...)은 사용자 정의 에러 핸들러를 받아 스택 트레이스를 포함한 상세 로그를 남길 수 있다. 복구는 pcall과 동일하게 “죽지 않게” 처리한다.

한 줄 결론
pcall은 “여기서 실패해도 전체는 계속 달리자”라는 안전벨트다. 옵셔널 의존성, 초기화 경계, 탐지/폴백 로직에서만 절제해 쓰고, 필수 경로에서는 실패를 숨기지 말라.

