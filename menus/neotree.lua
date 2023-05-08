local popup = require "user.core.context_menu"

local M = {}

local buf_is_neotree = function() return vim.bo.filetype == "neo-tree" end

local items = {
  newfile = popup.menu_item {
    id = "NeoTreePopUpNewFile",
    label = "New File",
    condition = buf_is_neotree,
    command = "a",
  },

  new_dir = popup.menu_item {
    label = "New Directory",
    condition = buf_is_neotree,
    command = "A",
  },

  rename = popup.menu_item {
    label = "Rename",
    condition = buf_is_neotree,
    command = "r",
  },

  delete = popup.menu_item {
    label = "Delete",
    condition = buf_is_neotree,
    command = "D",
  },

  copy = popup.menu_item {
    label = "Copy",
    condition = buf_is_neotree,
    command = "c",
  },

  paste = popup.menu_item {
    label = "Paste",
    condition = buf_is_neotree,
    command = "p",
  },

  open = popup.menu_item {
    label = "Open",
    condition = buf_is_neotree,
    command = "o",
  },

  close = popup.menu_item {
    label = "Close",
    condition = buf_is_neotree,
    command = "q",
  },
}

local neotree_menu = popup.menu_item {
  id = "NeoTreePopUp",
  label = "Files",
  condition = buf_is_neotree,
  items = {
    items.newfile,
    items.new_dir,
    items.rename,
    items.delete,
    items.copy,
    items.paste,
    items.open,
    items.close,
  },
}

M.setup = function() popup.menu(neotree_menu) end

return M
