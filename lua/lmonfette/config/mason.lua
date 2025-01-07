-- general
local mason = require('mason')
local logging = require('lmonfette/logging')
-- lsps
local mason_lspconfig = require('mason-lspconfig')
local package_to_lspconfig = require('mason-lspconfig.mappings.server').package_to_lspconfig
local lspconfig_to_package = require('mason-lspconfig.mappings.server').lspconfig_to_package
-- daps
local mason_dap = require('mason-nvim-dap')
local package_to_nvim_dap = require('mason-nvim-dap.mappings.source').package_to_nvim_dap
-- linters
local mason_lint = require('mason-nvim-lint')
local nvim_lint = require('lint')
local package_to_nvimlint = require('mason-nvim-lint.mapping').package_to_nvimlint
-- formatters
local formatter = require('formatter')
local formatter_util = require 'formatter.util'

local function mason_lsps_to_nvim_lsps(package_list)
    local package_list_length = #package_list
    local nvim_package_list = {}

    for i = 1, package_list_length do
        table.insert(nvim_package_list, package_to_lspconfig[package_list[i]])
    end
    return nvim_package_list
end

local function mason_daps_to_nvim_daps(package_list)
    local package_list_length = #package_list
    local nvim_package_list = {}

    for i = 1, package_list_length do
        table.insert(nvim_package_list, package_to_nvim_dap[package_list[i]])
    end
    return nvim_package_list
end

local function mason_linters_to_nvim_linters(package_list)
    local package_list_length = #package_list
    local nvim_package_list = {}

    for i = 1, package_list_length do
        table.insert(nvim_package_list, package_to_nvimlint[package_list[i]])
    end
    return nvim_package_list
end

local mason_config = {
    mason_lsps = {
        -- a
        'ansible-language-server',
        'arduino-language-server',
        -- b
        'bash-language-server',
        -- 'buf-language-server', -- BUG: add back later, waiting for an update on mason-lspconfig's side
        -- c
        'clangd',
        'cmake-language-server',
        'css-lsp',
        -- d
        'docker-compose-language-service',
        'dockerfile-language-server',
        -- e
        'eslint-lsp',
        -- f
        -- g
        'glsl_analyzer',
        'gopls',
        -- h
        'helm-ls',
        'html-lsp',
        -- i
        -- j
        'jdtls',
        'json-lsp',
        -- k
        -- l
        'lua-language-server',
        -- m
        'marksman',
        'matlab-language-server',
        -- n
        'nginx-language-server',
        -- o
        -- p
        'powershell-editor-services',
        'python-lsp-server',
        -- q
        -- r
        'rust-analyzer',
        'rust_hdl',
        -- s
        'sqls',
        -- t
        'typescript-language-server',
        -- u
        -- v
        'verible',
        'vim-language-server',
        'vue-language-server',
        -- w
        -- x
        -- y
        'yaml-language-server',
        -- z
    },
    nvim_lsps = {}, -- defined in setup function
    mason_daps = {
        -- a
        -- b
        'bash-debug-adapter',
        -- c
        'chrome-debug-adapter',
        'codelldb',
        -- 'cortex-debug',              -- BUG: commenting this because it has somehow got to be installed manually with mason
        'cpptools',
        -- d
        'debugpy',
        'delve',
        -- e
        -- f
        -- g
        -- h
        -- i
        -- j
        'java-debug-adapter',
        'java-test',
        'js-debug-adapter',
        -- k
        -- l
        -- m
        -- n
        -- o
        -- p
        'php-debug-adapter'
        -- q
        -- r
        -- s
        -- t
        -- u
        -- v
        -- w
        -- x
        -- y
        -- z
    },
    nvim_daps = {}, -- defined in setup function
    mason_linters = {
        -- a
        'ansible-lint',
        -- b
        -- c
        'checkmake',
        'cmakelint',
        'codespell',
        'cpplint',
        -- d
        -- e
        'eslint_d',
        -- f
        'flake8',
        -- g
        'gdtoolkit',
        'golangci-lint',
        -- h
        'htmlhint',
        'hadolint',
        -- i
        -- j
        'jsonlint',
        -- k
        -- l
        'luacheck',
        -- m
        'markdownlint',
        -- n
        -- o
        -- p
        'phpcs',
        'protolint',
        -- q
        -- r
        -- s
        'shellcheck',
        'sqlfluff',
        -- t
        'tflint',
        -- u
        -- v
        'vale',
        'vint',
        -- w
        -- x
        -- y
        'yamllint'
        -- z
    },
    nvim_linters = {}, -- defined in setup function
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
        markdown    = { 'markdownlint' },
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
        logging.error('PLEASE PUT buf-language-server BACK IN ensure_installed')
    end

    -- configure the LSPs (language server protocol)
    mason_lspconfig.setup({
        ensure_installed = mason_config.nvim_lsps,
        automatic_installation = false,
        handlers = {
            function(server_name)
                local setup_params = {}
                if lspconfig_to_package[server_name] == 'lua-language-server' then
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
                require('lspconfig')[server_name].setup(setup_params)
            end,
        },
    })
end

local function setup_daps()
    -- check if cortex-debug has been added
    if package_to_nvim_dap['cortex-debug'] ~= nil then
        logging.error('PLEASE ADD cortex-debug TO DAP\'s automatically loaded')
    end

    -- TODO: test daps by running code

    -- configure the DAPs (debug adapter protocol)
    mason_dap.setup({
        ensure_installed = mason_config.nvim_daps,
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

    -- TODO: make templates for all important language configurations
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
    vim.api.nvim_create_user_command('LintInfo', function()
        local filetype = vim.bo.filetype
        local current_linters = require('lint').linters_by_ft[filetype]

        if current_linters then
            logging.info('Linters for ' .. filetype .. ': ' .. table.concat(current_linters, ', '))
        else
            logging.info('No linters configured for filetype: ' .. filetype)
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
            -- Formatter configurations for filetype 'lua' go here
            -- and will be executed in order
            lua = {
                -- 'formatter.filetypes.lua' defines default configurations for the
                -- 'lua' filetype
                require('formatter.filetypes.lua').stylua,

                -- You can also define your own configuration
                function()

                    logging.debug('formatting !')
                    -- Supports conditional formatting
                    if formatter_util.get_current_buffer_file_name() == 'special.lua' then
                        return nil
                    end
                    -- Full specification of configurations is down below and in Vim help
                    -- files
                    return {
                        exe = 'stylua',
                        args = {
                            '--search-parent-directories',
                            '--stdin-filepath',
                            formatter_util.escape_path(formatter_util.get_current_buffer_file_path()),
                            '--',
                            '-',
                        },
                        stdin = true,
                    }
                end
            },

            -- Use the special '*' filetype for defining formatter configurations on
            -- any filetype
            ['*'] = {
                -- 'formatter.filetypes.any' defines default configurations for any
                -- filetype
                require('formatter.filetypes.any').remove_trailing_whitespace,
                -- Remove trailing whitespace without 'sed'
                -- require('formatter.filetypes.any').substitute_trailing_whitespace,
            }
        }
    }
end

local function init ()
    -- convert the packages to nvim compatible names
    mason_config.nvim_lsps = mason_lsps_to_nvim_lsps(mason_config.mason_lsps)
    mason_config.nvim_daps = mason_daps_to_nvim_daps(mason_config.mason_daps)
    mason_config.nvim_linters = mason_linters_to_nvim_linters(mason_config.mason_linters)
    -- setup mason package manager
    mason.setup({})

    setup_lsps()
    setup_daps()
    setup_linters()
    setup_formatters()
end

local function set_options()
end

local function set_remaps()
    vim.keymap.set('n', '<leader>mm', vim.cmd.Mason)
end

function mason_config.setup()
    init()
    set_options()
    set_remaps()
end

-- vim.cmd.MasonInstall('cortex-debug') -- BUG: somehow this has to be installed from mason directly
-- vim.cmd.MasonUpdate()

return mason_config
