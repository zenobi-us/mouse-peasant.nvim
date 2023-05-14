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
  --merge with R.DEFAULTS if not nil
  local options = vim.tbl_extend("force", Constants.DEFAULTS, item.options or {})

  local width = options.min_menu_item_width

  -- do we show the command in the menu?
  local show_help = options.show_help or false

  -- calculate the padding from the original text of the label
  local padding = width - #item.label

  if padding < width then padding = width end

  if item.items ~= nil and options.submenu_indicator ~= nil then
    -- we'll add a ▸ to indicate it's a submenu
    return item.label .. string.rep(" ", padding - #options.submenu_indicator) .. options.submenu_indicator
  end

  if item.command == "<Nop>" or item.command == nil then return item.label .. string.rep(" ", padding) end

  return item.label .. string.rep(" ", padding - #item.command) .. (show_help and item.command or "")
end

-- should the menu item render or not
R.should_menu_item_display = function(menu)
  -- if menu has a condition and it's a function,
  -- bail out of rendering it anew,
  -- and just return the menu as is
  if menu.condition ~= nil and type(menu.condition) == "function" then return menu.condition() end
  return true
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

R.menu_action = function(menu)
  if not R.should_menu_item_display(menu) then return end

  -- create the menu entry for each mode
  for _, mode in ipairs(menu.modes or Constants.MODES) do
    local cmd = mode .. "menu " .. menu.groupid .. "." .. R.escape_label(R.label(menu)) .. " " .. menu.command
    vim.cmd(cmd)
  end
end

R.menu_popup = function(menu)
  if not R.should_menu_item_display(menu) then return end

  -- generate a popup id
  local popupId = R.slugify(menu.label)

  -- allows the submenu to be opened with the mouse
  menu.command = "<cmd> popup " .. popupId .. "<cr>"
  R.menu_action(menu)

  for _, item in ipairs(menu.items) do
    -- anchor all children to this popupid
    item.groupid = popupId
    -- merge with parent options
    item.options = vim.tbl_extend("force", menu.options or {}, item.options or {})
    -- fork to decide if it's a submenu or a menu item
    R.menu_item(item)
  end
end

R.menu_separator = function(menu)
  if not R.should_menu_item_display(menu) then return end

  -- create the menu entry for each mode
  for _, mode in ipairs(menu.modes or Constants.MODES) do
    local cmd = mode .. "menu " .. menu.groupid .. ".-1- <Nop>"
    vim.cmd(cmd)
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
-- @param options table
-- @param options.events table
-- @param options.menus table
R.menu = function(options)
  options = options or {}
  local events = options.events or { "BufEnter" }
  local menus = options.menus or {}

  vim.api.nvim_create_autocmd(events, {
    callback = function()
      R.clear_menu "PopUp"

      for _, menu in ipairs(menus) do
        menu.groupid = "PopUp"
        R.menu_item(menu)
      end
    end,
  })
end

return R
