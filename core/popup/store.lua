-- This module stores the registered menu items
-- @module core.popup.store
-- @alias M
local M = {}

M.store = {}

--- Register one or more items
M.register = function(...)
  local items = { ... }
  for _, item in ipairs(items) do
    table.insert(M.store, item)
  end
end

--- Clear all registered menu items
-- @see core.popup.render.clear_menu
-- @usage
-- popup.store.clear()
M.clear = function() M.store = {} end

return M
