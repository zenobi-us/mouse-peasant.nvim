local popup = require "user.core.popup"

local M = {}

M.setup = function()
  popup.register {
    label = "LSP",
    condition = popup.predicate.buf_has_lsp,
    items = {
      {
        label = "LSP: hover",
        command = "<leader>ld",
        modes = { "n", "v" },
      },
      {
        label = "LSP: rename",
        condition = popup.predicate.buf_has_lsp,
        command = "<leader>lr",
      },
      {
        label = "LSP: code action",
        condition = popup.predicate.buf_has_lsp,
        command = "<leader>la",
      },
      {
        label = "LSP: diagnostics",
        condition = popup.predicate.buf_has_lsp,
        command = "<leader>ld",
      },
      {
        label = "LSP: references",
        condition = popup.predicate.buf_has_lsp,
        command = "<leader>lr",
      },
      {
        label = "LSP: definition",
        condition = popup.predicate.buf_has_lsp,
        command = "<leader>ld",
      },
      {
        label = "LSP: type definition",
        condition = popup.predicate.buf_has_lsp,
        command = "<leader>lt",
      },
    },
  }
end

return M
