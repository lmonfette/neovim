local nvim_tree_api = require('nvim-tree.api')

local tree_config = {}

local function init()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    local function my_on_attach(bufnr)
        -- local function opts(desc)
        --     return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        -- end

        -- setup the default key mappings
        nvim_tree_api.config.mappings.default_on_attach(bufnr)

        -- close the tree when opening a file
        -- vim.keymap.set('n', '<CR>', nvim_tree_api.node.open.drop, opts('Open'))
    end

    require('nvim-tree').setup({
        on_attach = my_on_attach,
        view = {
            number = true,
            relativenumber = true,
            width = 40,
        },
        filters = {
            git_ignored = false,
            dotfiles = false,
        },
    })
end

local function set_options()
    -- optionally enable 24-bit colour
    vim.opt.termguicolors = true
end

local function set_remaps()
    vim.keymap.set('n', '<leader>pp', function()
        nvim_tree_api.tree.open()
    end)
    vim.keymap.set('n', '<leader>po', function()
        nvim_tree_api.tree.close()
    end)
end

function tree_config.setup()
    init()
    set_options()
    set_remaps()
end

return tree_config
