local neogen_config = {}

local function init()
end

local function set_options()
end

local function set_remaps()
    local opts = { noremap = true, silent = true }

    vim.keymap.set('n', '<leader>nf', ':lua require(\'neogen\').generate({ type = \'func\' })<CR>', opts)
    vim.keymap.set('n', '<leader>nc', ':lua require(\'neogen\').generate({ type = \'class\' })<CR>', opts)
    vim.keymap.set('n', '<leader>nt', ':lua require(\'neogen\').generate({ type = \'type\' })<CR>', opts)
    vim.keymap.set('n', '<leader>nn', ':lua require(\'neogen\').generate({ type = \'file\' })<CR>', opts)
end

function neogen_config.setup()
    init()
    set_options()
    set_remaps()
end

return neogen_config
