-- setup lsp
local logging = require('lmonfette/logging')
logging.debug('after/plugin/lsp.lua')

local lsp_config = require('lmonfette/config/lsp')

lsp_config.setup()
