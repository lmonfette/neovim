local utils_module = {}

function utils_module.ensure_installed(tool, brew_name)
    if vim.fn.executable(tool) == 0 then
        print(tool .. " not found. Installing with Homebrew...")
        local install_cmd = "brew install " .. brew_name
        local result = vim.fn.system(install_cmd)
        if vim.v.shell_error == 0 then
            print(tool .. " installed successfully.")
        else
            print("Error installing " .. tool .. ": " .. result)
        end
    end
end

return utils_module
