-- setup telescope
local logging = require('lmonfette/logging')
logging.debug('after/plugin/telescope.lua')

local telescope_config = require('lmonfette/config/telescope')

telescope_config.setup()
