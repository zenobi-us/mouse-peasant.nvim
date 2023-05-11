local popup = require "user.core.context_menu"

local M = {}

M.buf_is_neotree = function() return vim.bo.filetype == "neo-tree" end

M.neotree = {
  newfile = popup.menu_item {
    id = "NeoTreePopUpNewFile",
    label = "New File",
    condition = M.buf_is_neotree,
    command = "a",
  },

  new_dir = popup.menu_item {
    label = "New Directory",
    condition = M.buf_is_neotree,
    command = "A",
  },

  rename = popup.menu_item {
    label = "Rename",
    condition = M.buf_is_neotree,
    command = "r",
  },

  delete = popup.menu_item {
    label = "Delete",
    condition = M.buf_is_neotree,
    command = "D",
  },

  copy = popup.menu_item {
    label = "Copy",
    condition = M.buf_is_neotree,
    command = "c",
  },

  paste = popup.menu_item {
    label = "Paste",
    condition = M.buf_is_neotree,
    command = "p",
  },

  open = popup.menu_item {
    label = "Open",
    condition = M.buf_is_neotree,
    command = "o",
  },

  close = popup.menu_item {
    label = "Close",
    -- condition = M.buf_is_neotree,
    command = "q",
  },
}

M.neotree.popup = popup.menu_item {
  id = "NeoTreePopUp",
  label = "Files",
  -- condition = M.buf_is_neotree,
  items = {
    M.neotree.newfile,
    M.neotree.new_dir,
    M.neotree.rename,
    M.neotree.delete,
    M.neotree.copy,
    M.neotree.paste,
    M.neotree.open,
    M.neotree.close,
  },
}

M.setup = function() popup.menu(M.neotree.newfile, M.neotree.new_dir, M.neotree.rename, M.neotree.popup) end

return M
