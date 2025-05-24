local harpoon = require('harpoon')

local harpoon_config = {}

local function init()
    harpoon:setup()
end

local function set_options() end

local function set_remaps()
    vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
    end)
    vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    vim.keymap.set('n', '<C-h>', function()
        harpoon:list():select(1)
    end)
    vim.keymap.set('n', '<C-j>', function()
        harpoon:list():select(2)
    end)
    vim.keymap.set('n', '<C-k>', function()
        harpoon:list():select(3)
    end)
    vim.keymap.set('n', '<C-l>', function()
        harpoon:list():select(4)
    end)
end

function harpoon_config.setup()
    init()
    set_options()
    set_remaps()
end

return harpoon_config
