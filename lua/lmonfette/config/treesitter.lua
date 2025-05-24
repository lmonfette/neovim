local utils = require('lmonfette/utils')
local nvim_ts_configs = require('nvim-treesitter.configs')

local treesitter_config = {
    -- languages for treesitter to parse
    languages = {
        -- a
        'arduino',
        'asm',
        -- b
        'bash',
        -- c
        'c',
        'cpp',
        'comment',
        'css',
        'csv',
        -- d
        'dockerfile',
        'doxygen',
        -- e
        -- f
        -- g
        'gdscript',
        'gdshader',
        'glsl',
        'go',
        'gomod',
        'gosum',
        -- h
        'helm',
        'html',
        'http',
        -- i
        -- j
        'java',
        'javascript',
        'json',
        -- k
        -- l
        'lua',
        'luadoc',
        -- m
        'make',
        'markdown',
        'markdown_inline',
        'matlab',
        -- n
        'nginx',
        -- o
        'objc',
        -- p
        'pem',
        'php',
        'powershell',
        'printf',
        -- q
        -- r
        'regex',
        'requirements',
        'rust',
        -- s
        'scss',
        'sql',
        'ssh_config',
        'swift',
        -- t
        'terraform',
        'tmux',
        'toml',
        'typescript',
        'tsx',
        -- u
        -- v
        'verilog',
        'vhdl',
        'vim',
        'vimdoc',
        'vue',
        -- w
        -- x
        -- y
        'yaml',
        -- z
    },
}

local function init()
    utils.system_ensure_installed('tree-sitter')

    nvim_ts_configs.setup({
        -- A list of parser names, or 'all' (the listed parsers MUST always be installed)
        ensure_installed = treesitter_config.languages,
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = true,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,

        highlight = {
            enable = true,

            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
        },
        build = ":TSUpdate",
    })
end

local function set_options()
    vim.o.foldmethod = 'expr'
    vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.o.foldlevel = 99
end

local function set_remaps() end

function treesitter_config.setup()
    init()
    set_options()
    set_remaps()
end

return treesitter_config
