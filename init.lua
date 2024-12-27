-- local utils = require('utils')
local logging = require('logging')

-- utils.set_logging_config(vim.log.levels.DEBUG, true)

logging.debug('init.lua')
require("lmonfette")
require("tests")

-- add plugin "mg979/vim-visual-multi"
