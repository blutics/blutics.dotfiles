local M = {}

M.make_leader_keymap_string = function (main_char, target)
  return string.format("<leader>%s%s", main_char, target)
end

return M
