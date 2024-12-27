-- setup telescope
local logging = require('logging')
logging.debug('after/plugin/telescope.lua')

local telescope_config = require('config/telescope')

telescope_config.setup()
