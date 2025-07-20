local logging = require('lmonfette/logging')
local cmake_utils = require('lmonfette/config/cmake/utils')

local cmake_config = {}

local function init()
end

local function set_options() end

local function set_remaps()
    -- 1. List the options to build
    vim.keymap.set('n', '<leader>cl', function ()
        cmake_utils.select_preset()
    end)
end

function cmake_config.setup()
    init()
    set_options()
    set_remaps()
end

return cmake_config
