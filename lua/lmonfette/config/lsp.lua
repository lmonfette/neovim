-- lspzero config
local lsp_config = {}

local cmp = require('cmp')

local function init()
    -- This should be executed before you configure any language server
    local lspconfig_defaults = require('lspconfig').util.default_config
    lspconfig_defaults.capabilities =
        vim.tbl_deep_extend('force', lspconfig_defaults.capabilities, require('cmp_nvim_lsp').default_capabilities())

    vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
            local opts = { buffer = event.buf }

            vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
            vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
            vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
            vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
            vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
            vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
            vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
            vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
            vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
            vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
            vim.keymap.set('n', '<leader>od', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
            vim.keymap.set('n', '<leader>cd', '<cmd>lua vim.diagnostic.hide()<cr>', opts)
        end,
    })

    local cmp_select = { behevior = cmp.SelectBehavior.Select }

    cmp.setup({
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body)
            end,
        },
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
        }, {
            { name = 'buffer' },
        }),
        preselect = 'item',
        completion = {
            completeopt = 'menu,menuone,noinsert',
        },
        mapping = cmp.mapping.preset.insert({
            ['<Up>'] = cmp.mapping.select_prev_item(cmp_select),
            ['<Down>'] = cmp.mapping.select_next_item(cmp_select),
            ['<Tab>'] = cmp.mapping.confirm({ select = false }),
            ['<C-Space>'] = cmp.mapping.complete(),
        }),
    })

    -- / cmdline setup.
    cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' },
        },
    })

    -- : cmdline setup.
    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' },
        }, {
            {
                name = 'cmdline',
                option = {
                    ignore_cmds = { 'Man', '!' },
                },
            },
        }),
    })
end

local function set_options()
    -- Reserve a space in the gutter
    vim.opt.signcolumn = 'yes'
end

local function set_remaps() end

function lsp_config.setup()
    init()
    set_options()
    set_remaps()
end

return lsp_config
