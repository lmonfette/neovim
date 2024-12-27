local undotree_config = {}

local function init()
end

local function set_options()
end

local function set_remaps()
    vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
end

function undotree_config.setup()
    init()
    set_options()
    set_remaps()
end

return undotree_config
