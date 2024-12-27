-- setup lazy
local logging = require('logging')
logging.debug('after/plugin/lazy.lua')

local lazy_config = require('config/lazy')

lazy_config.setup()
