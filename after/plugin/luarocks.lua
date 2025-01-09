-- setup luarocks
local logging = require('lmonfette/logging')
logging.debug('after/plugin/luarocks.lua')

local luarocks_config = require('lmonfette/config/luarocks')

luarocks_config.setup()
