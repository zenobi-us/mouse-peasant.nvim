local popup = require "user.core.popup"

local M = {}

M.setup = function()
  require("user.menus.neotree").setup()
  require("user.menus.git").setup()
  require("user.menus.treesitter").setup()
  require("user.menus.lsp").setup()

  -- finally add the event handler to render the menu
  popup.render.menu {
    events = { "BufEnter" },
    menus = popup.store,
  }
end

return M
