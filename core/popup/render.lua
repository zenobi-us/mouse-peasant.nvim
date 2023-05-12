local Constants = require "user.core.popup.constants"

local R = {}

--- Clear all entries from the given menu
---@param menu string
R.clear_menu = function(menu)
  pcall(function() vim.cmd("aunmenu " .. menu) end)
end

--- Formats the label of a menu entry to avoid errors
---@param label string
---@return string
R.escape_label = function(label)
  local res = string.gsub(label, " ", [[\ ]])
  res = string.gsub(res, "<", [[\<]])
  res = string.gsub(res, ">", [[\>]])
  return res
end

-- a function that removes all non alphanumeric characters from a string and replaces spaces with underscores
R.slugify = function(label) return string.gsub(label, "[^%w%s]", ""):gsub("%s+", "_") end

R.label = function(item)
  local options = Constants.DEFAULTS
  local width = options.menu_item_width

  -- calculate the padding from the original text of the label
  local padding = width - #item.label

  if padding < width then padding = width end

  if item.items ~= nil and options.submenu_indicator ~= nil then
    -- we'll add a ▸ to indicate it's a submenu
    return item.label .. string.rep(" ", padding - #options.submenu_indicator) .. options.submenu_indicator
  end

  if item.command == "<Nop>" or item.command == nil then return item.label .. string.rep(" ", padding) end

  return item.label .. string.rep(" ", padding - #item.command) .. item.command
end

-- Create a menu item
--
-- Menu items can be of two kinds:
--
-- - the main PopUp entry
-- - an entry in a submenu
--
-- The main PopUp entry is the one that shows up in the context menu.
-- It's the one that has the label of the context menu.
-- and is the one that has the command that opens the submenu.
--
-- The submenu entries are the ones that show up when you click on the main PopUp entry.
-- They're the ones that have the label of the submenu, and are the ones that have the
-- command that does something.

R.menu_action = function(menu, modes)
  -- bail out of rendering it anew, if there's a condition and it's not met
  if menu.condition ~= nil and not menu.condition() then return end

  -- create the menu entry for each mode
  for _, mode in ipairs(modes or Constants.MODES) do
    local cmd = mode .. "menu " .. menu.groupid .. "." .. R.escape_label(R.label(menu)) .. " " .. menu.command
    vim.cmd(cmd)
  end
end

R.menu_popup = function(menu)
  -- generate a popup id
  local popupId = R.slugify(menu.label)

  -- allows the submenu to be opened with the mouse
  menu.command = "<cmd> popup " .. popupId .. "<cr>"
  R.menu_action(menu)

  for _, item in ipairs(menu.items) do
    -- anchor all children to this popupid
    item.groupid = popupId
    -- fork to decide if it's a submenu or a menu item
    R.menu_item(item)
  end
end

R.menu_item = function(menu)
  if menu.items ~= nil then
    R.menu_popup(menu)
  else
    R.menu_action(menu)
  end
end

-- Main entry point
-- all items here are children of the initial "PopUp" menu
R.menu = function(...)
  local menus = { ... }

  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    callback = function()
      for _, menu in ipairs(menus) do
        menu.groupid = "PopUp"
        R.menu_item(menu)
      end
    end,
  })
end

return R
