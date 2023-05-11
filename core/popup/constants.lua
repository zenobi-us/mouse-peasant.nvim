local M = {}

M.DEFAULTS = {
  -- the width of the menu item
  menu_item_width = 30,
  -- the indicator to show if a menu item has a submenu
  submenu_indicator = "▸",
  -- the colour of the label
  label_colour = "Normal",
  -- the colour of the command
  command_colour = "Comment",
}

M.MODES = { "i", "n" }

M.UI_TYPES = {
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

M.BUF_TYPES = {
  "nofile",
  "prompt",
  "quickfix",
  "terminal",
}

return M
