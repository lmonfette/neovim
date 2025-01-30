-- setup coding_style
local logging = require('lmonfette/logging')
logging.debug('after/plugin/coding_style.lua')

local coding_style_config = require('lmonfette/config/coding_style')

coding_style_config.setup()
