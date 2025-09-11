-- put this in your init.lua (or a sourced lua file)
-- Normal 모드 진입 시 Rust exe 실행 (Windows 전용)

-- 1) 실행파일 경로 설정
local cfg  = vim.fn.stdpath("config")               -- 예: C:\Users\<YOU>\AppData\Local\nvim
local exe  = (vim.fs and vim.fs.joinpath or function(...)
  return table.concat({...}, package.config:sub(1,1)) -- 구버전 호환
end)(cfg, "lua", "utils", "ime_mode_win.exe")

local ime_exe = vim.g.ime_exe_path or exe 
-- local ime_exe = vim.g.ime_exe_path or [[]]

-- 2) Windows 가드 & 파일 존재 확인
local uv = vim.uv or vim.loop
local last = 0
local interval_ms = 80 -- 스로틀 간격: 너무 잦은 트리거 방지

local function run_ime_en()
	local now = uv.now()
	if now - last < interval_ms then
		return
	end
	last = now
	-- 쉘을 거치지 않도록 리스트 형태로 호출(경로에 공백 있어도 안전)
	vim.fn.jobstart({ ime_exe }, { detach = true })
end

-- 3) Normal 모드 진입 시 실행 (Neovim 0.7+)
local grp = vim.api.nvim_create_augroup("IME_Force_EN_OnNormal", { clear = true })
vim.api.nvim_create_autocmd("ModeChanged", {
	group = grp,
	pattern = "*:n", -- 어떤 모드에서든 Normal로 들어올 때
	callback = run_ime_en,
	desc = "Force IME to English on entering Normal mode",
})

-- (선택) 추가 안전망: InsertLeave에서도 한 번 더 보정하고 싶다면 주석 해제
-- vim.api.nvim_create_autocmd("InsertLeave", { group = grp, callback = run_ime_en })

-- (선택) 수동 테스트용 명령
vim.api.nvim_create_user_command("IMEForceEN", run_ime_en, {})
-- 필요 시 경고만 한 줄 남기고 넘어간다
-- print("IME exe not found or not on Windows: " .. ime_exe)
