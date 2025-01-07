local lfs = require('lfs')

-- Function to check if a directory exists
local function directory_exists(path)
    local attr = lfs.attributes(path)
    return attr and attr.mode == 'directory'
end

local logging = require('lmonfette/logging')

logging.debug('lua/tests/plugin_test.lua')

local path_prefix = '~/.local/share/nvim/'
local lazy_path = path_prefix .. 'lazy/'
-- local mason_path = path_prefix .. 'mason/'

local function verify_file_exists(path, name)
    if not directory_exists(path .. name) then
        logging.error('plugin ' .. path .. name .. ' not found ...')
    end
end

local function plugins_tests()
    local plugins_name = {
        -- colorscheme
        'horizon-extended.nvim',
    }

    local plugins_count = #plugins_name

    for i = 1, plugins_count do
        verify_file_exists(lazy_path, plugins_name[i])
    end
end

-- don't run tests for now
-- plugins_tests()
