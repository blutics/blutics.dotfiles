-- %USERPROFILE%/.wezterm.lua  또는  ~/.wezterm.lua
local home = os.getenv("USERPROFILE") or os.getenv("HOME")
-- Windows도 슬래시는 허용됩니다. 역슬래시 이스케이프 스트레스 피하려고 / 권장
return dofile(home .. "/blutics.dotfiles/wezterm/wezterm.lua")

