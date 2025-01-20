-- setup luasnip
local logging = require('lmonfette/logging')
logging.debug('after/plugin/luasnip.lua')

local luasnip_config = require('lmonfette/config/luasnip')

luasnip_config.setup()
