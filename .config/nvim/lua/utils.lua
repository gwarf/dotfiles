-- https://github.com/jdhao/nvim-config/blob/master/lua/utils.lua
local fn = vim.fn

local M = {}

function M.executable(name)
  if fn.executable(name) > 0 then
    return true
  end

  return false
end

return M
