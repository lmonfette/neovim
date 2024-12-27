-- mason init
local logging = require('logging')
logging.debug('after/plugin/mason.lua')

local mason_config = require('config/mason')

mason_config.setup()
