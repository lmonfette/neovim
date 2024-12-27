-- setup tree
local logging = require('logging')
logging.debug('after/plugin/tree.lua')

local tree_config = require('config/tree')

tree_config.setup()
