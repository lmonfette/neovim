-- setup fugitive
local logging = require('lmonfette/logging')
logging.debug('after/plugin/fugitive.lua')

local fugitive_config = require('lmonfette/config/fugitive')

fugitive_config.setup()
