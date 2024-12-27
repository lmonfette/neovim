-- setup treesitter
local logging = require('logging')
logging.debug('after/plugin/treesitter.lua')

local treesitter_config = require('config/treesitter')

treesitter_config.setup()
