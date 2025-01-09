local lazy_config = {}

local function init()
end

local function set_options()
end

local function set_remaps()
    vim.keymap.set('n', '<leader>ll', vim.cmd.Lazy)
end

function lazy_config.setup()
    init()
    set_options()
    set_remaps()
end

return lazy_config
