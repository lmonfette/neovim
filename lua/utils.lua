local logging = require('logging')

local utils_module = {}

function utils_module.ensure_installed(tool, brew_name)
    if vim.fn.executable(tool) == 0 then
        logging.info(tool .. " not found. Installing with Homebrew...")
        local install_cmd = "brew install " .. brew_name
        local result = vim.fn.system(install_cmd)
        if vim.v.shell_error == 0 then
            logging.info(tool .. " installed successfully.")
        else
            logging.info("Error installing " .. tool .. ": " .. result)
        end
    end
end

local state = require('state')

function utils_module.set_logging_config(log_level, logging_active)
    state.log_level = log_level
    state.logging_active = logging_active
end

return utils_module
