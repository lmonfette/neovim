local state = require('lmonfette/state')
local logging = require('lmonfette/logging')

local utils_module = {}

function utils_module.split(string, pattern)
    local strings = {}
    local gmatch_pattern = '[^' .. pattern .. ']+'
    for inner_string in string.gmatch(string, gmatch_pattern) do
        table.insert(strings, inner_string)
    end
    return strings
end

function utils_module.system_install(tool, brew_name)

    local os_name = vim.loop.os_uname().sysname
    local install_command = ''
    if os_name == 'Linux' then
        install_command = 'sudo apt update && sudo apt install -y'
    elseif os_name == 'Darwin' then
        install_command = 'brew install'
    else
        logging.info('Unsupported OS for system installation.')
    end

    if vim.fn.executable(tool) == 0 then
        logging.info(tool .. ' not found, installing on system...')
        local install_cmd = install_command .. ' ' .. brew_name
        local result = vim.fn.system(install_cmd)
        if vim.v.shell_error == 0 then
            logging.info(tool .. ' installed successfully.')
        else
            logging.error('Error installing ' .. tool .. ': ' .. result)
        end
    end
end

function utils_module.luarocks_install(package_name, require_name)
    local lua_numerical_version = utils_module.split(state.lua_version, ' ')[2] -- Lua 5.1 (example)

    local has_package, _ = pcall(require, require_name)
    if not has_package then
        logging.info(package_name .. ' (package) not found. Installing with luarocks...')

        local command = 'luarocks install --lua-version=' .. lua_numerical_version .. ' ' .. package_name
        local handle = io.popen(command)

        if handle == nil then
            logging.error('luarocks_install - error installing ' .. package_name .. ': handle is nil')
            return false
        end

        local result = handle:read('*a')
        if result == nil then
            logging.error('luarocks_install - error installing ' .. package_name .. ': read result is nil')
            return false
        end

        handle:close()

        if result:match('is now installed') or result:match('already installed') then
            logging.info(package_name .. ' installed successfully.')
        else
            logging.info('Failed to install ' .. package_name .. '. Please check your luarocks setup.')
        end
    else
        logging.debug(package_name .. ' (package) is already installed.')
    end
end

function utils_module.set_logging_config(log_level, logging_active)
    state.log_level = log_level
    state.logging_active = logging_active
end

return utils_module
