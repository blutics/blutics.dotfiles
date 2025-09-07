
# Wezterm 설정파일 관리

현재의 폴더는 wezterm을 윈도우에서 사용할 때의 설정

- .wezterm.lua
    해당 파일은 웨즈텀이 직접적으로 불러오는 파일로
    체인 로딩, 즉, 중계를 하는 파일이다.
    이 파일은 윈도우에서 USERPROFILE 위치에 위치하며
    이 파일에서는 wezterm.lua를 불러오는 역할만한다.
    즉, 한줄의 설정 코드만 있을 뿐이다.
- wezterm.lua
    실제 모든 설정들이 들어가는 위치이다.

결국, .wezterm.lua를 잘 위치 시키며
wezterm.lua가 .wezterm.lua에서 가리키는 위치에 잘 있다면
정상적으로 작동하게 된다.

최대한 dotfiles, 즉 해당 리파지토리의 루트를 USERPROFILE로 잡자.

