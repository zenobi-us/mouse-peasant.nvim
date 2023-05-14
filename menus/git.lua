local popup = require "user.core.popup"

local M = {}

M.setup = function()
  popup.register {
    label = "Git: status",
    command = "<leader>gt",
  }
end

return M
