local utils = require('lmonfette/utils')

local telescope_config = {}

local function init()
    -- make sure local package dependencies are met
    utils.system_ensure_installed('rg') -- make sure ripgrep is installed
    utils.system_ensure_installed('fd') -- make sure fd is installed
    -- setup
    local telescope = require('telescope')

    -- setup parameters from the docs
    local setup_params = {
        defaults = {
            -- Default configuration for telescope goes here:
            -- config_key = value,
            mappings = {
                i = {
                    -- map actions.which_key to <C-h> (default: <C-/>)
                    -- actions.which_key shows the mappings for your picker,
                    -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                    ['<C-h>'] = 'which_key',
                },
            },
            vimgrep_arguments = {
                'rg',
                '--color=never',
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--column',
                '--smart-case',
                '--hidden',
            },
        },
        pickers = {
            -- Default configuration for builtin pickers goes here:
            -- picker_name = {
            --   picker_config_key = value,
            --   ...
            -- }
            -- Now the picker_config_key will be applied every time you call this
            -- builtin picker
        },
        extensions = {
            -- Your extension configuration goes here:
            -- extension_name = {
            --   extension_config_key = value,
            -- }
            -- please take a look at the readme of the extension you want to configure
        },
    }
    telescope.setup(setup_params)
end

local function set_options() end

local function set_remaps()
    local builtin = require('telescope.builtin')
    -- vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' }) -- find a file by name opened root directory
    vim.keymap.set('n', '<leader>ff', function()
        builtin.find_files({ hidden = true })
    end, { desc = 'Telescope find files' }) -- find a file by name opened root directory
    vim.keymap.set('n', '<leader>fg', function()
        builtin.live_grep({ hidden = true })
    end, { desc = 'Telescope live grep' }) -- find a file by greping in it
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' }) -- find a file from the opened buffers
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' }) -- find a help menu
    vim.keymap.set('n', '<leader>]', builtin.grep_string, { desc = 'Telescope LSP references' })
end

function telescope_config.setup()
    init()
    set_options()
    set_remaps()
end

return telescope_config
