-- setup vim_visual_multi
local logging = require('lmonfette/logging')
logging.debug('after/plugin/vim-visual-multi.lua')

local vim_visual_multi_config = require('lmonfette/config/vim-visual-multi')

vim_visual_multi_config.setup()
