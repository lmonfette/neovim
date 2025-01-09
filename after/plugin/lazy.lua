-- setup lazy
local logging = require('lmonfette/logging')
logging.debug('after/plugin/lazy.lua')

local lazy_config = require('lmonfette/config/lazy')

lazy_config.setup()
