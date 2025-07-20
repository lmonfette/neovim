-- setup coding_style
local logging = require('lmonfette/logging')
logging.debug('after/plugin/cmake.lua')

local cmake_config = require('lmonfette/config/cmake')

cmake_config.setup()
