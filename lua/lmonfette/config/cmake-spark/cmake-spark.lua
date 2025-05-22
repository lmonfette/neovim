local logging = require('lmonfette/logging')

local cmake_spark_config = {}

local function init()
    cmake_spark.create_default_mappings()
end

local function set_options() end

local function set_remaps()
    -- 1. List the options to build
    vim.keymap.set('n', '<leader>cl', '')
end

function cmake_spark_config.setup()
    init()
    set_options()
    set_remaps()
end

return cmake_spark_config
