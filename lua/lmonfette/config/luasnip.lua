local ls = require('luasnip')
local luasnip_config = {}

local function init()
    require('luasnip.loaders.from_vscode').lazy_load('./my_snippets')
end

local function set_options() end

local function set_remaps()
    vim.keymap.set({ 'i' }, '<C-K>', function()
        ls.expand()
    end, { silent = true })
    vim.keymap.set({ 'i', 's' }, '<C-L>', function()
        ls.jump(1)
    end, { silent = true })
    vim.keymap.set({ 'i', 's' }, '<C-J>', function()
        ls.jump(-1)
    end, { silent = true })

    vim.keymap.set({ 'i', 's' }, '<C-E>', function()
        if ls.choice_active() then
            ls.change_choice(1)
        end
    end, { silent = true })
end

function luasnip_config.setup()
    init()
    set_options()
    set_remaps()
end

return luasnip_config
