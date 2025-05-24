-- setup harpoon
local logging = require('lmonfette/logging')
logging.debug('after/plugin/harpoon.lua')

local harpoon_config = require('lmonfette/config/harpoon')

harpoon_config.setup()
