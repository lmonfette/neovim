-- setup lsp
local logging = require('logging')
logging.debug('after/plugin/lsp.lua')

local lsp_config = require('config/lsp')

lsp_config.setup()
