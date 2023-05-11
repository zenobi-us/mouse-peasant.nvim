local popup = require "user.core.popup"

local M = {}

local buf_is_neotree = function() return vim.bo.filetype == "neo-tree" end
--
-- local items = {
--   newfile = menu_item
--
--   new_dir = menu_item {
--     label = "New Directory",
--     id = "NeoTreePopUpNewDir",
--     condition = buf_is_neotree,
--     command = "A",
--   },
--
--   rename = menu_item {
--     label = "Rename",
--     id = "NeoTreePopUpRename",
--     condition = buf_is_neotree,
--     command = "r",
--   },
--
--   delete = menu_item {
--     label = "Delete",
--     id = "NeoTreePopUpDelete",
--     condition = buf_is_neotree,
--     command = "D",
--   },
--
--   copy = menu_item {
--     label = "Copy",
--     id = "NeoTreePopUpCopy",
--     condition = buf_is_neotree,
--     command = "c",
--   },
--
--   paste = menu_item {
--     label = "Paste",
--     id = "NeoTreePopUpPaste",
--     condition = buf_is_neotree,
--     command = "p",
--   },
--
--   open = menu_item {
--     label = "Open",
--     id = "NeoTreePopUpOpen",
--     condition = buf_is_neotree,
--     command = "o",
--   },
--
--   close = menu_item {
--     label = "Close",
--     id = "NeoTreePopUpClose",
--     condition = buf_is_neotree,
--     command = "q",
--   },
-- }

M.setup = function()
  popup.render.menu({
    label = "New File",
    condition = buf_is_neotree,
    command = "a",
  }, {
    label = "Something",
    condition = buf_is_neotree,
    items = {
      {
        label = "Else",
        condition = buf_is_neotree,
        command = "a",
      },
    },
  })
end

return M
