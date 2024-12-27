-- setup undotree
local logging = require('logging')
logging.debug('after/plugin/undotree.lua')

local undotree_config = require('config/undotree')

undotree_config.setup()
