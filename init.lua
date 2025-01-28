local utils = require('lmonfette/utils')
local logging = require('lmonfette/logging')

utils.set_logging_config(vim.log.levels.WARN, true)

logging.debug('init.lua')
-- base setup
require('lmonfette')
-- setup package manager
require('lmonfette/package_manager')
-- run tests
require('lmonfette/tests')
