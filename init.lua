local utils = require('lmonfette/utils')
local logging = require('lmonfette/logging')

utils.set_logging_config(vim.log.levels.DEBUG, true)

logging.debug('init.lua')
-- base setup
require("lmonfette")
-- setup package manager
require('lmonfette/package_manager')
-- run tests
require("lmonfette/tests")

-- add plugin "mg979/vim-visual-multi"
