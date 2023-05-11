local Constants = require "core.popup.constants"
local P = {}

--- Checks if current buf has LSPs attached
---@return boolean
P.buf_has_lsp = function()
  return not vim.tbl_isempty(vim.lsp.get_active_clients {
    bufnr = vim.api.nvim_get_current_buf(),
  })
end

--- Checks if current buf is a file
---@return boolean
P.buf_is_file = function()
  return not vim.tbl_contains(Constants.UI_TYPES, vim.bo.filetype)
    and not vim.tbl_contains(Constants.BUF_TYPES, vim.bo.buftype)
end

--- Checks if current buf has DAP support
---@return boolean
P.buf_has_dap = function() return P.buf_is_file() end

return P
