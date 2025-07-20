-- setup live preview
local logging = require('lmonfette/logging')
logging.debug('after/plugin/live-preview.lua')

local live_preview_config = require('lmonfette/config/live-preview')

live_preview_config.setup()
