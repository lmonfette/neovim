-- setup colorscheme
local logging = require('logging')
logging.debug('after/plugin/colorscheme.lua')

local colorscheme_config = require('config/colorscheme')

colorscheme_config.setup()
