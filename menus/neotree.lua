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
    id = "NeoTreePopUpNewDir",
    condition = buf_is_neotree,
    command = "A",
  },

  rename = popup.menu_item {
    label = "Rename",
    id = "NeoTreePopUpRename",
    condition = buf_is_neotree,
    command = "r",
  },

  delete = popup.menu_item {
    label = "Delete",
    id = "NeoTreePopUpDelete",
    condition = buf_is_neotree,
    command = "D",
  },

  copy = popup.menu_item {
    label = "Copy",
    id = "NeoTreePopUpCopy",
    condition = buf_is_neotree,
    command = "c",
  },

  paste = popup.menu_item {
    label = "Paste",
    id = "NeoTreePopUpPaste",
    condition = buf_is_neotree,
    command = "p",
  },

  open = popup.menu_item {
    label = "Open",
    id = "NeoTreePopUpOpen",
    condition = buf_is_neotree,
    command = "o",
  },

  close = popup.menu_item {
    label = "Close",
    id = "NeoTreePopUpClose",
    condition = buf_is_neotree,
    command = "q",
  },
}

M.setup = function()
  popup.menu(items.newfile, items.new_dir, items.rename, items.delete, items.copy, items.paste, items.open, items.close)
end

return M
