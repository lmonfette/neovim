-- lspzero config

-- NOTE: to make any of this work you need a language server.
-- If you don't know what that is, watch this 5 min video:
-- https://www.youtube.com/watch?v=LaS32vctfOY

-- Reserve a space in the gutter
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    print('calling LspAttach')

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})

-- You'll find a list of language servers here:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- These are example language servers. 
--
-- local lsp_config = require('lspconfig')

-- lsp_config.clangd.setup({
-- 	{
-- 		single_file_support = false,
-- 		on_attach = function(client, bufnr)
-- 			print('clangd started')
-- 		end,
-- 	}
-- })
-- 
-- lsp_config.rust_analyzer.setup({})
-- lsp_config.gopls.setup({})

local lspzero = require('lsp-zero')
local cmp = require('cmp')

local cmp_select = { behevior = cmp.SelectBehavior.Select }
-- local cmp_mappings = lspzero.defaults.cmp_mapppings({
-- 	['<C-j>'] = cmp.mapping.select_prev_item(cmp_select),
-- 	['<C-k>'] = cmp.mapping.select_next_item(cmp_select),
-- 	['<Tab>'] = cmp.mapping.confirm({ select = true}),
-- 	['<C-Space'] = cmp.mapping.complete(),
-- })
-- 
-- lspzero.set_preferences({
-- 	sign_icons = {}
-- })
-- 
-- lspzero.setup_nvim_cmp({
-- 	mapping = cmp_mappings
-- })

---------------------------- CLEAN -----------------------------------

cmp.setup({
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'buffer' },
	},
	preselect = 'item',
	completion = {
		completeopt = 'menu,menuone,noinsert'
	},
	mapping = cmp.mapping.preset.insert({
		['<Up>'] = cmp.mapping.select_prev_item(cmp_select),
		['<Down>'] = cmp.mapping.select_next_item(cmp_select),
		['<Tab>'] = cmp.mapping.confirm({ select = false}),
		['<C-Space>'] = cmp.mapping.complete(),
	})
})

-- cmp.setup({
--   sources = {
--     {name = 'nvim_lsp'},
--   },
--   snippet = {
--     expand = function(args)
--       -- You need Neovim v0.10 to use vim.snippet
--       vim.snippet.expand(args.body)
--     end,
--   },
--   mapping = cmp_mappings,
-- })
