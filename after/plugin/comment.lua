-- setup comment
local logging = require('lmonfette/logging')
logging.debug('after/plugin/comment.lua')

local comment_config = require('lmonfette/config/comment')

comment_config.setup()
