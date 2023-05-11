local popup = require "user.core.context_menu"

local M = {}

M.menu = {
  filehistory = popup.menu_item {
    id = "GitViewFileHistory",
    label = "Git: File History",
    condition = popup.buf_is_file,
    command = "a",
  },
}

M.popup = popup.menu_item {
  id = "GitPopUp",
  label = "Git",
  condition = popup.buf_is_file,
  items = {
    M.menu.filehistory,
  },
}

M.setup = function() popup.menu(M.popup) end

return M
