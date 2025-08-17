-- lua/custom/pylsp_rope_install.lua
local function mason_pkg_dir(name)
  -- Mason 설치 루트 (기본: stdpath("data")/mason)
  local ok, settings = pcall(require, "mason.settings")
  local root = ok and settings.current.install_root_dir or (vim.fn.stdpath("data") .. "/mason")
  return (vim.fs and vim.fs.joinpath(root, "packages", name)) or (root .. "/packages/" .. name)
end

local function pylsp_pip_path()
  local pkg = mason_pkg_dir("python-lsp-server")
  if vim.fn.isdirectory(pkg) == 0 then
    return nil, "python-lsp-server (pylsp) is not installed via Mason"
  end
  if vim.loop.os_uname().sysname == "Windows_NT" then
    return pkg .. "\\venv\\Scripts\\pip.exe"
  else
    return pkg .. "/venv/bin/pip"
  end
end

local function ensure_rope_in_pylsp()
  local pip, err = pylsp_pip_path()
  if not pip then
    vim.notify(err, vim.log.levels.WARN)
    return
  end

  -- 이미 있는지 먼저 확인
  vim.system({ pip, "show", "pylsp-rope" }, { text = true }, function(show)
    if show.code == 0 then
      vim.schedule(function()
        vim.notify("pylsp-rope already installed in Mason pylsp venv", vim.log.levels.INFO)
      end)
      return
    end
    vim.schedule(function()
      vim.notify("Installing rope + pylsp-rope into Mason pylsp venv…", vim.log.levels.INFO)
    end)
    vim.system({ pip, "install", "-U", "rope", "pylsp-rope" }, { text = true }, function(res)
      vim.schedule(function()
        if res.code == 0 then
          vim.notify("Installed rope + pylsp-rope ✅", vim.log.levels.INFO)
        else
          vim.notify(
            ("pip failed (%d): %s"):format(res.code, res.stderr or res.stdout or ""),
            vim.log.levels.ERROR
          )
        end
      end)
    end)
  end)
end

return { ensure_rope_in_pylsp = ensure_rope_in_pylsp }
