-- setup treesitter
local logging = require('lmonfette/logging')
logging.debug('after/plugin/treesitter.lua')

local treesitter_config = require('lmonfette/config/treesitter')

treesitter_config.setup()
