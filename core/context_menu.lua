local M = {}

--- Checks if current buf has LSPs attached
---@return boolean
M.buf_has_lsp = function()
  return not vim.tbl_isempty(vim.lsp.get_active_clients {
    bufnr = vim.api.nvim_get_current_buf(),
  })
end

local nonfile = require "user.core.nonfiles"

--- Checks if current buf is a file
---@return boolean
M.buf_is_file = function()
  return not vim.tbl_contains(nonfile.filetypes, vim.bo.filetype)
      and not vim.tbl_contains(nonfile.buftypes, vim.bo.buftype)
end

M.buf_is_neotree = function() return vim.bo.filetype == "neo-tree" end

--- Checks if current buf has DAP support
---@return boolean
M.buf_has_dap = function() return M.buf_is_file() end

--- Create a context menu
---@deprecated
---@param prompt string
---@param strings table[string]
---@param funcs table[function]
M.uiselect_context_menu = function(prompt, strings, funcs)
  vim.ui.select(strings, { prompt = prompt }, function(_, idx) vim.schedule(funcs[idx]) end)
end

local MODES = { "i", "n" }

M.MENU_ITEM_WIDTH = 32

--- Clear all entries from the given menu
---@param menu string
M.clear_menu = function(menu)
  pcall(function() vim.cmd("aunmenu " .. menu) end)
end

--- Formats the label of a menu entry to avoid errors
---@param label string
---@return string
M.format_menu_label = function(label)
  local res = string.gsub(label, " ", [[\ ]])
  res = string.gsub(res, "<", [[\<]])
  res = string.gsub(res, ">", [[\>]])
  return res
end

M.render_menu_item = function(menu)
  -- bail out of rendering it anew, if there's a condition and it's not me
  if menu.condition ~= nil and not menu.condition() then return end

  -- create the menu entry for each mode
  for _, mode in ipairs(MODES) do
    vim.cmd(mode .. "menu " .. menu.id .. "." .. M.format_menu_label(menu.label) .. " " .. menu.command)
  end
end

M.render_submenu = function(menu)
  -- if it's an entry to a submenu, clear the submenu first
  M.clear_menu(menu.id)

  -- bail out of rendering it anew, if there's a condition and it's not me
  if menu.condition ~= nil and not menu.condition() then return end

  for _, item in ipairs(menu.items) do
    M.render_menu_item(item)
  end

  M.render_menu_item {
    id = "PopUp",
    label = menu.label,
    command = "<cmd>popup " .. menu.id .. "<cr>",
  }
end

M.render_menu = function(menu)
  -- clear the popup menu entry
  M.clear_menu("PopUp." .. M.format_menu_label(menu.id))

  if menu.items ~= nil then
    M.render_submenu(menu)
  else
    M.render_menu_item {
      id = "PopUp",
      label = menu.label,
      command = menu.command,
      condition = menu.condition,
    }
  end
end

M.walk_tree = function(menu, func, args)
  func(menu, args and args.parent or nil)

  if menu.items then
    for _, item in ipairs(menu.items) do
      M.walk_tree(item, func, { parent = menu })
    end
  end
end

M.slugify = function(str) return string.gsub(string.lower(str), " ", "_") end

M.annotate_id = function(menu, parent_id)
  if parent_id == nil then return end

  menu.id = parent_id .. "." .. M.format_menu_label(menu.label)
end

-- Recursively annotate the command of each menu item except if it has menu items
M.annotate_command = function(menu)
  local padding = M.MENU_ITEM_WIDTH - #menu.label
  if menu.items ~= nil then
    -- we'll add a ▸ to indicate it's a submenu
    menu.label = menu.label .. string.rep(" ", padding - 2) .. "▸"
    return
  end

  menu.label = menu.label .. string.rep(" ", padding - #menu.command) .. "<" .. menu.command .. ">"
end

-- Create a menu item identified by id. It requires a label and a command.
-- if it has items then it's a submenu which requires a table of items
M.menu_item = function(options)
  M.walk_tree(options, function(item, parent)
    M.annotate_command(item)
    M.annotate_id(item, parent and parent.id or nil)
  end)

  return {
    id = options.id,
    label = options.label,
    command = options.command or "<Nop>",
    condition = options.condition,
    items = options.items,
  }
end

local MENUS = {}
MENUS.neotree_newfile = {
  id = "NeoTreePopUpNewFile",
  label = "New File",
  condition = M.buf_is_neotree,
  command = "a",
}

MENUS.neotree = M.menu_item {
  id = "NeoTreePopUp",
  label = "Files",
  condition = M.buf_is_neotree,
  items = {
    MENUS.neotree_newfile,
    {
      label = "New Directory",
      command = "A",
    },
    {
      label = "Rename",
      command = "r",
    },
    {
      label = "Delete",
      command = "D",
    },
    {
      label = "Copy",
      command = "c",
    },
    {
      label = "Paste",
      command = "p",
    },
    {
      label = "Open",
      command = "o",
    },
    {
      label = "Close",
      command = "q",
    },
  },
}
M.clear_menu "PopUp"

M.set_keymap = function() require("user.core.keymapper").nkeymap("<A-m>", "<cmd>popup PopUp<cr>", "Open Context Menu") end

M.setup = function()
  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    callback = function()
      -- attach neotree menu
      M.render_menu(MENUS.neotree)
    end,
  })

  M.set_keymap()
end

return M
