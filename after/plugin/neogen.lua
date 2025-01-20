-- setup neogen
local logging = require('lmonfette/logging')
logging.debug('after/plugin/neogen.lua')

local neogen_config = require('lmonfette/config/neogen')

neogen_config.setup()
