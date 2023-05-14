local popup = require "user.core.popup"

local M = {}

M.setup = function()
  popup.register({
    label = "AST: highlight under cursor",
    command = ":TSHighlightCapturesUnderCursor<cr>",
    condition = popup.predicate.buf_has_treesitter,
    modes = { "n", "v" },
  }, {
    label = "AST: Show current node",
    command = ":TSNodeUnderCursor<cr>",
    condition = popup.predicate.buf_has_treesitter,
    modes = { "n", "v" },
  }, {
    label = "AST: Show playground",
    command = ":TSPlaygroundToggle<cr>",
    condition = popup.predicate.buf_has_treesitter,
    modes = { "n", "v" },
  })
end

return M
