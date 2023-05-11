local M = {}
-- these are filetypes and buftypes that are not actual files
-- created by plugins or by neovim itself

local DEFAULTS = {
  -- the width of the menu item
  menu_item_width = 30,
  -- the indicator to show if a menu item has a submenu
  submenu_indicator = "▸",
  -- the colour of the label
  label_colour = "Normal",
  -- the colour of the command
  command_colour = "Comment",
}

local MODES = { "i", "n" }

local UI_TYPES = {
  "NvimTree",
  "Nvpunk",
  "NvpunkHealthcheck",
  "Outline",
  "TelescopePrompt",
  "Trouble",
  "aerial",
  "alpha",
  "dap-repl",
  "dapui_breakpoints",
  "dapui_console",
  "dapui_scopes",
  "dapui_stacks",
  "dapui_watches",
  "dashboard",
  "help",
  "lazy",
  "lir",
  "neo-tree",
  "neo-tree-popup",
  "neogitstatus",
  "notify",
  "packer",
  "qf",
  "spectre_panel",
  "startify",
  "toggleterm",
  "vim",
}

local BUF_TYPES = {
  "nofile",
  "prompt",
  "quickfix",
  "terminal",
}

---@class MenuOptions
---@field mode string
---@field menu string
---@field width number
---@field indicator string
---@field label_colour string
---@field command_colour string
local MenuOptions = {}

---@class MenuItem
---@field id string
---@field label string
---@field command string
---@field condition function
---@field items MenuItem[]
---@field parent MenuItem
local MenuItem = {}

--- Checks if current buf has LSPs attached
---@return boolean
M.buf_has_lsp = function()
  return not vim.tbl_isempty(vim.lsp.get_active_clients {
    bufnr = vim.api.nvim_get_current_buf(),
  })
end

--- Checks if current buf is a file
---@return boolean
M.buf_is_file = function()
  return not vim.tbl_contains(UI_TYPES, vim.bo.filetype) and not vim.tbl_contains(BUF_TYPES, vim.bo.buftype)
end

--- Checks if current buf has DAP support
---@return boolean
M.buf_has_dap = function() return M.buf_is_file() end

--- Clear all entries from the given menu
---@param menu string
local clear_menu = function(menu)
  pcall(function() vim.cmd("aunmenu " .. menu) end)
end

--- Formats the label of a menu entry to avoid errors
---@param label string
---@return string
local escape_label = function(label)
  local res = string.gsub(label, " ", [[\ ]])
  res = string.gsub(res, "<", [[\<]])
  res = string.gsub(res, ">", [[\>]])
  return res
end

--- Formats the label of a menu entry
---@param menu MenuItem
---@param options MenuOptions | nil
---@return nil
local menu_label = function(menu, options)
  -- merge options with defaults
  -- this is done to avoid having to pass the options table around
  local opts = vim.tbl_extend("force", options or {}, DEFAULTS)

  local padding = opts.menu_item_width - #menu.label

  if menu.items ~= nil and opts.submenu_indicator ~= nil then
    -- we'll add a ▸ to indicate it's a submenu
    menu.label = menu.label .. string.rep(" ", padding - 2) .. opts.submenu_indicator
    return
  end

  menu.label = menu.label .. string.rep(" ", padding - #menu.command) .. menu.command
end

--- Renders a menu item
---@param menu MenuItem
---@return nil
local render_menu_item = function(menu)
  -- bail out of rendering it anew, if there's a condition and it's not me
  if menu.condition ~= nil and not menu.condition() then return end

  -- create the menu entry for each mode
  for _, mode in ipairs(MODES) do
    vim.cmd(mode .. "menu " .. menu.id .. "." .. escape_label(menu.label) .. " " .. menu.command)
  end
end

--- Renders a menu
---@param menu MenuItem
---@return nil
local render_menu = function(menu)
  -- if it's an entry to a submenu, clear the submenu first
  clear_menu(menu.id)

  -- bail out of rendering it anew, if there's a condition and it's not me
  if menu.condition ~= nil and not menu.condition() then return end

  if menu.items ~= nil then
    for _, item in ipairs(menu.items) do
      render_menu_item(item)
    end
  end

  render_menu_item {
    id = "PopUp",
    label = menu.label,
    command = "<cmd>popup " .. menu.id .. "<cr>",
  }
end

local Walk = {}

---@class MenuTreeWalkArgs
---@field parent MenuItem

--- recursively walk a menu tree and run a callback on each item.
-- the callback receives the item and its parent
---@param menu MenuItem
---@param func function
---@param args MenuTreeWalkArgs | nil
Walk.tree = function(menu, func, args)
  func(menu, args and args.parent or nil)

  if menu.items then
    for _, item in ipairs(menu.items) do
      Walk.tree(item, func, { parent = menu })
    end
  end
end

-- Create a menu item identified by id. It requires a label and a command.
-- if it has items then it's a submenu which requires a table of items
M.menu_item = function(options)
  local result = {
    id = options.id,
    label = options.label,
    command = options.command or "<Nop>",
    condition = options.condition,
    items = options.items,
  }

  Walk.tree(result, function(item, parent)
    if parent then item.id = parent.id or item.id end
  end)

  return result
end

clear_menu "PopUp"

-- accepts a varidic number of menu items
---@vararg MenuItem
---@return nil
M.menu = function(...)
  -- loop through the menu items

  for _, menu in ipairs(arg) do
    -- recursively walk the menu tree and format the labels
    Walk.tree(menu, function(item) menu_label(item) end)
  end
  -- create an autocommand to render the menu
  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    callback = function()
      -- loop through the menu items
      for _, menu in ipairs(arg) do
        -- clear the popup menu entry
        clear_menu("PopUp." .. escape_label(menu.label))

        if menu.items ~= nil then
          render_menu(menu)
        else
          render_menu_item {
            id = "PopUp",
            label = menu.label,
            command = menu.command,
            condition = menu.condition,
          }
        end

        -- attach neotree menu
        render_menu(menu)
      end
    end,
  })
end

return M
