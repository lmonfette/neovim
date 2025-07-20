local live_preview_config = {}

local function init()
end

local function set_options()
    vim.keymap.set('n', '<leader>lps', ':LivePreview start<CR>')
end

local function set_remaps()
end

function live_preview_config.setup()
    init()
    set_options()
    set_remaps()
end

return live_preview_config
