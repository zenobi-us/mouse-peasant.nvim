local M = {}
-- these are filetypes and buftypes that are not actual files
-- created by plugins or by neovim itself

M.uitypes = {
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

M.buftypes = {
  "nofile",
  "prompt",
  "quickfix",
  "terminal",
}

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
  return not vim.tbl_contains(M.uitypes, vim.bo.filetype) and not vim.tbl_contains(M.buftypes, vim.bo.buftype)
end

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

--- Clear all entries from the given menu
---@param menu string
M.clear_menu = function(menu)
  pcall(function() vim.cmd("aunmenu " .. menu) end)
end

--- Formats the label of a menu entry to avoid errors
---@param label string
---@return string
M.escape_label = function(label)
  local res = string.gsub(label, " ", [[\ ]])
  res = string.gsub(res, "<", [[\<]])
  res = string.gsub(res, ">", [[\>]])
  return res
end

M.slugify = function(str) return string.gsub(string.lower(str), " ", "_") end

-- Recursively annotate the command of each menu item except if it has menu items
M.render_label = function(menu, options)
  -- merge options with defaults
  -- this is done to avoid having to pass the options table around
  options = options or {}
  options.submenu_indicator = options.submenu_indicator or "▸"
  options.menu_item_width = options.menu_item_width or 30

  -- TODO: workout how to colourise parts of a popup label
  options.label_colour = options.label_colour or "Normal"
  options.command_colour = options.command_colour or "Comment"

  local padding = options.menu_item_width - #menu.label

  if menu.items ~= nil and options.submenu_indicator ~= nil then
    -- we'll add a ▸ to indicate it's a submenu
    menu.label = menu.label .. string.rep(" ", padding - 2) .. options.submenu_indicator
    return
  end

  menu.label = menu.label .. string.rep(" ", padding - #menu.command) .. menu.command
end

M.render_menu_item = function(menu)
  -- bail out of rendering it anew, if there's a condition and it's not me
  if menu.condition ~= nil and not menu.condition() then return end

  -- create the menu entry for each mode
  for _, mode in ipairs(MODES) do
    vim.cmd(mode .. "menu " .. menu.id .. "." .. M.escape_label(menu.label) .. " " .. menu.command)
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
  M.clear_menu("PopUp." .. M.escape_label(menu.label))

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

  M.walk_tree(result, function(item, parent)
    M.render_label(item)
    if parent then item.id = parent.id or item.id end
  end)

  return result
end

M.clear_menu "PopUp"

M.menu = function(menu)
  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    callback = function()
      -- attach neotree menu
      M.render_menu(menu)
    end,
  })
end

return M
