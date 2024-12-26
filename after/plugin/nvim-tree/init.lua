-- init tree

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

local nvim_tree_api = require('nvim-tree.api')

local function my_on_attach(bufnr)
    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    -- setup the default key mappings
    nvim_tree_api.config.mappings.default_on_attach(bufnr)

    -- close the tree when opening a file
    -- vim.keymap.set("n", "<CR>", nvim_tree_api.node.open.drop, opts("Open"))
end

require("nvim-tree").setup({ on_attach = my_on_attach })


vim.keymap.set("n", "<leader>pp", function() nvim_tree_api.tree.open() end)
