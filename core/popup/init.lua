local M = {}
M.constants = require "user.core.popup.constants"
M.predicate = require "user.core.popup.predicate"
M.render = require "user.core.popup.render"

M.store = require("user.core.popup.store").store
M.register = require("user.core.popup.store").register

M.render.clear_menu "PopUp"

return M
