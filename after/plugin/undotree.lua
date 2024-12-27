-- setup undotree
local logging = require('lmonfette/logging')
logging.debug('after/plugin/undotree.lua')

local undotree_config = require('lmonfette/config/undotree')

undotree_config.setup()
