local colorscheme_config = {}

local function ColorTheCode(colorscheme)
    colorscheme = colorscheme or 'horizon-extended'

    vim.cmd.colorscheme(colorscheme)
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
end

local function init()
    ColorTheCode('horizon-extended')
end

local function set_options() end

local function set_remaps() end

function colorscheme_config.setup()
    init()
    set_options()
    set_remaps()
end

return colorscheme_config
