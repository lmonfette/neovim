-- setup leap
local logging = require('lmonfette/logging')
logging.debug('after/plugin/leap.lua')

local leap_config = require('lmonfette/config/leap')

leap_config.setup()
