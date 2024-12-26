-- general
local mason = require('mason')
local utils = require('utils')
-- lsps
local mason_lspconfig = require('mason-lspconfig')
local package_to_lspconfig = require('mason-lspconfig.mappings.server').package_to_lspconfig
-- daps
local mason_dap = require('mason-nvim-dap')
local package_to_nvim_dap = require('mason-nvim-dap.mappings.source').package_to_nvim_dap
-- linters
local mason_lint = require('mason-nvim-lint')
local nvim_lint = require('lint')
local package_to_nvimlint = require('mason-nvim-lint.mapping').package_to_nvimlint
-- formatters
local formatter = require('formatter')
local formatter_util = require "formatter.util"

local function mason_lsp_to_nvim_lsp(package_list)
    local package_list_length = #package_list
    local nvim_package_list = {}

    for i = 1, package_list_length do
        table.insert(package_to_lspconfig[package_list[i]], nvim_package_list)
    end
end

local function mason_dap_to_nvim_dap(package_list)
    local package_list_length = #package_list
    local nvim_package_list = {}

    for i = 1, package_list_length do
        table.insert(package_to_nvim_dap[package_list[i]], nvim_package_list)
    end
end

local function mason_linters_to_nvim_linters(package_list)
    local package_list_length = #package_list
    local nvim_package_list = {}

    for i = 1, package_list_length do
        table.insert(package_to_nvimlint[package_list[i]], nvim_package_list)
    end
end

local mason_config = {
    mason_lsps = {
        'ansible-language-server',
        'arduino-language-server',
        'bash-language-server',
        -- 'buf-language-server', -- BUG: add back later, waiting for an update on mason-lspconfig's side
        'clangd',
        'cmake-language-server',
        'css-lsp',
        'docker-compose-language-service',
        'dockerfile-language-server',
        'eslint-lsp',
        'glsl_analyzer',
        'gopls',
        'helml',
        'html-lsp',
        'jdtls',
        'json-lsp',
        'lua-language-server',
        'marksman',
        'matlab-language-server',
        'nginx-language-server',
        'powershell-editor-services',
        'python-lsp-server',
        'rust-analyzer',
        'rust_hdl',
        'sqls',
        'typescript-language-server',
        'verible',
        'vim-language-server',
        'vue-language-server',
        'yaml-language-server',
    },
    nvim_lsps = {},
    mason_daps = {
        'bash-debug-adapter',
        'chrome-debug-adapter',
        'codelldb',
        -- 'cortex-debug',              -- BUG: commenting this because it has somehow got to be installed manually with mason
        'cpptools',
        'debugpy',
        'delve',
        'java-debug-adapter',
        'java-test',
        'js-debug-adapter',
        'php-debug-adapter'
    },
    nvim_daps = {},
    mason_linters = {
        'ansible-lint',
        'checkmake',
        'cmakelint',
        'codespell',
        'cpplint',
        'eslint_d',
        'flake8',
        'gdtoolkit',
        'golangci-lint',
        'htmlhint',
        'hadolint',
        'jsonlint',
        'luacheck',
        'markdownlint',
        'phpcs',
        'protolint',
        'shellcheck',
        'sqlfluff',
        'tflint',
        'vale',
        'vint',
        'yamllint'
    },
    nvim_linters = {},
    linters_by_ft = {
        -- a
        -- b
        -- c
        c           = { 'cpplint' },
        cpp         = { 'cpplint' },
        -- d
        dockerfile  = { 'hadolint' },
        -- e
        -- f
        -- g
        gd          = { 'gdtoolkit' },
        go          = { 'golangci-lint' },
        -- h
        html        = { 'htmlhint' },
        -- i
        -- j
        js          = { 'eslint_d' },
        json        = { 'jsonlint' },
        jsx         = { 'eslint_d' },
        -- k
        -- l
        lua         = { 'luacheck' },
        -- m
        make        = { 'checkmake' },
        md          = { 'markdownlint' },
        -- n
        -- o
        -- p
        php         = { 'phpcs' },
        proto       = { 'protolint' },
        py          = { 'flake8' },
        -- q
        -- r
        rs          = { 'ast-grep' },
        -- s
        sh          = { 'shellcheck' },
        sql         = { 'sqlfluff' },
        -- t
        tex         = { 'vale' },
        tf          = { 'tflint' },
        ts          = { 'eslint_d' },
        tsx         = { 'eslint_d' },
        txt         = { 'cmakelint' },
        -- u
        -- v
        vim         = { 'vint' },
        -- w
        -- x
        -- y
        yml         = { 'ansible-lint', 'yamllint' },
        yaml        = { 'ansible-lint', 'yamllint' },
        -- z
    }
}

local function setup_lsps()
    -- check if the buf_ls has been updated and we can ad it back to the list
    if package_to_lspconfig['buf-language-server'] == 'buf_ls' then
        print('PLEASE PUT buf-language-server BACK IN ensure_installed')
    end
    -- configure the LSPs (language server protocol)
    mason_lspconfig.setup({
        ensure_installed = mason_config.mason_linters,
        automatic_installation = false,
        handlers = {
            function(server_name)
                local setup_params = {}
                if server_name == 'lua-language-server' then
                    setup_params = {
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { 'vim' }
                                }
                            }
                        }
                    }
                end
                require('lspconfig')[package_to_lspconfig[server_name]].setup(setup_params)
            end,
        },
    })
end

local function setup_daps()
    -- check if cortex-debug has been added
    if package_to_nvim_dap['cortex-debug'] ~= nil then
        print('PLEASE ADD cortex-debug TO DAP\'s automatically loaded')
    end

    -- configure the DAPs (debug adapter protocol)
    mason_dap.setup({
        ensure_installed = mason_config.mason_daps,
        automatic_installation = false,
        handlers = {
            function(dap_name)
                require('mason-nvim-dap').default_setup(dap_name)
            end,
        },
    })
end

local function setup_linters()
    mason_lint.setup({
        ensure_installed = mason_config.mason_linters,
        automatic_installation = false,
    })

    nvim_lint.linters_by_ft = mason_config.linters_by_ft

    for linter_by_ft_name, _ in pairs(nvim_lint.linters_by_ft) do
        table.insert(nvim_lint.linters_by_ft[linter_by_ft_name], 'codespell')

        for i,_ in ipairs(nvim_lint.linters_by_ft[linter_by_ft_name]) do
            nvim_lint.linters_by_ft[linter_by_ft_name][i] = package_to_nvimlint[nvim_lint.linters_by_ft[linter_by_ft_name][i]];
        end
    end

    local nb_found = 0

    for _, linter_name in ipairs(mason_config.mason_linters) do
        local nvim_lint_name = package_to_nvimlint[linter_name]
        if nvim_lint_name == nil then
            nvim_lint_name = linter_name
        end

        local linter = nvim_lint.linters[nvim_lint_name];
        if linter ~= nil then
            linter.ignore_exitcode = false;
            nb_found = nb_found + 1
        else
            error(linter_name .. ' not found ...')
        end
    end

    vim.api.nvim_create_autocmd('BufWritePost',{
        desc = 'Try to lint post buffer write',
        callback = function() nvim_lint.try_lint() end
    })

    -- uitility function to check which linters are attached to the current buffer
    vim.api.nvim_create_user_command("LintInfo", function()
        local filetype = vim.bo.filetype
        local current_linters = require("lint").linters_by_ft[filetype]

        if current_linters then
            print("Linters for " .. filetype .. ": " .. table.concat(current_linters, ", "))
        else
            print("No linters configured for filetype: " .. filetype)
        end
    end, {})
end

local function setup_formatters()
    -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
    formatter.setup {
        -- Enable or disable logging
        logging = true,
        -- Set the log level
        log_level = vim.log.levels.WARN,
        -- All formatter configurations are opt-in
        filetype = {
            -- Formatter configurations for filetype "lua" go here
            -- and will be executed in order
            lua = {
                -- "formatter.filetypes.lua" defines default configurations for the
                -- "lua" filetype
                require("formatter.filetypes.lua").stylua,

                -- You can also define your own configuration
                function()

                    print("formatting !")
                    -- Supports conditional formatting
                    if formatter_util.get_current_buffer_file_name() == "special.lua" then
                        return nil
                    end
                    -- Full specification of configurations is down below and in Vim help
                    -- files
                    return {
                        exe = "stylua",
                        args = {
                            "--search-parent-directories",
                            "--stdin-filepath",
                            formatter_util.escape_path(formatter_util.get_current_buffer_file_path()),
                            "--",
                            "-",
                        },
                        stdin = true,
                    }
                end
            },

            -- Use the special "*" filetype for defining formatter configurations on
            -- any filetype
            ["*"] = {
                -- "formatter.filetypes.any" defines default configurations for any
                -- filetype
                require("formatter.filetypes.any").remove_trailing_whitespace,
                -- Remove trailing whitespace without 'sed'
                -- require("formatter.filetypes.any").substitute_trailing_whitespace,
            }
        }
    }
end

local function set_options()
end

local function init ()
    -- install dependencies
    utils.ensure_installed('luarocks', 'luarocks') -- make sure luarocks is installed
    -- convert the packages to nvim compatible names
    mason_config.nvim_lsps = mason_lsp_to_nvim_lsp(mason_config.mason_linters)
    mason_config.nvim_daps = mason_dap_to_nvim_dap(mason_config.mason_daps)
    mason_config.nvim_linters = mason_linters_to_nvim_linters(mason_config.mason_linters)
    -- setup mason package manager
    mason.setup({})

    setup_lsps()
    setup_daps()
    setup_linters()
    setup_formatters()
end

function mason_config.setup()
    init()
    set_options()
end

-- vim.cmd.MasonInstall('cortex-debug') -- BUG: somehow this has to be installed from mason directly
-- vim.cmd.MasonUpdate()

return mason_config
