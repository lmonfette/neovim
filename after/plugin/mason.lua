-- mason init
local logging = require('lmonfette/logging')
logging.debug('after/plugin/mason.lua')

local mason_config = require('lmonfette/config/mason')

mason_config.setup()
