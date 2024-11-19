local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local mason_dap = require('mason-nvim-dap')
local mason_linter = require('mason-nvim-lint')
local formatter = require('formatter')

-- setup mason package manager
mason.setup({})

local package_to_lspconfig = require('mason-lspconfig.mappings.server').package_to_lspconfig

if package_to_lspconfig['buf-language-server'] == 'buf_ls' then
	print('PLEASE PUT buf-language-server BACK IN ensure_installed')
end

-- configure the LSPs (language server protocol)
mason_lspconfig.setup({
	ensure_installed = {
		package_to_lspconfig['ansible-language-server'],
		package_to_lspconfig['arduino-language-server'],
		package_to_lspconfig['bash-language-server'],
		-- package_to_lspconfig['buf-language-server'], -- BUG: add back later, waiting for an update on mason-lspconfig's side
		package_to_lspconfig['clangd'],
		package_to_lspconfig['cmake-language-server'],
		package_to_lspconfig['css-lsp'],
		package_to_lspconfig['docker-compose-language-service'],
		package_to_lspconfig['dockerfile-language-server'],
		package_to_lspconfig['eslint-lsp'],
		package_to_lspconfig['glsl_analyzer'],
		package_to_lspconfig['gopls'],
		package_to_lspconfig['helm-ls'],
		package_to_lspconfig['html-lsp'],
		package_to_lspconfig['jdtls'],
		package_to_lspconfig['json-lsp'],
		package_to_lspconfig['lua-language-server'],
		package_to_lspconfig['marksman'],
		package_to_lspconfig['matlab-language-server'],
		package_to_lspconfig['nginx-language-server'],
		package_to_lspconfig['powershell-editor-services'],
		package_to_lspconfig['python-lsp-server'],
		package_to_lspconfig['rust-analyzer'],
		package_to_lspconfig['rust_hdl'],
		package_to_lspconfig['sqls'],
		package_to_lspconfig['typescript-language-server'],
		package_to_lspconfig['verible'],
		package_to_lspconfig['vim-language-server'],
		package_to_lspconfig['vue-language-server'],
		package_to_lspconfig['yaml-language-server'],
	},
	automatic_installation = false,
	handlers = {
		function(server_name)
			local setup_params = {}
			if server_name == package_to_lspconfig['lua-language-server'] then
				setup_params = {
					settings = {
						Lua = {
							diagnostics = {
								globals = { 'vim' }
							}
						}
					}
				}
			end
			require('lspconfig')[server_name].setup(setup_params)
		end,
	},
})

local package_to_nvim_dap = require('mason-nvim-dap.mappings.source').package_to_nvim_dap

if package_to_nvim_dap['cortex-debug'] ~= nil then
	print('PLEASE ADD cortex-debug TO DAP\'s automatically loaded')
end

-- configure the DAPs (debug adapter protocol)
mason_dap.setup({
	ensure_installed = {
		package_to_nvim_dap['bash-debug-adapter'],
		package_to_nvim_dap['chrome-debug-adapter'],
		package_to_nvim_dap['codelldb'],
		-- 'cortex-debug',				-- BUG: commenting this because it has somehow got to be installed manually with mason
		package_to_nvim_dap['cpptools'],
		package_to_nvim_dap['debugpy'],
		package_to_nvim_dap['delve'],
		package_to_nvim_dap['java-debug-adapter'],
		package_to_nvim_dap['java-test'],
		package_to_nvim_dap['js-debug-adapter'],
		package_to_nvim_dap['php-debug-adapter'],
	},
	automatic_installation = false,
	handlers = {
		function(dap_name)
			require('mason-nvim-dap').default_setup(dap_name)
		end,
	},
})

local linters = {
	'ast-grep',
	'checkmake',
	'cmakelint',
	'codespell',
	'cpplint',
	'dcm',
	'detekt',
	'eslint_d',
	'flakeheaven',
	'gdtoolkit',
	'gitleaks',
	'golangci-lint',
	'htmlhint',
	'hadolint',
	'jsonlint',
	-- 'luacheck',
	'markdownlint',
	'phpcs',
	'protolint',
	'shellcheck',
	'snyk',
	'sqlfluff',
	'swiftlint',
	'tflint',
	'vale',
	'vint',
	'verible',
	'yamllint',
}

print("YOLO")

mason_linter.setup({
	ensure_installed = {
		'ast-grep',
		'checkmake',
	},
	automatic_installation = true,
	handlers = {
		function(linter_name)
			print('installing ' .. linter_name .. ' linter ...')
			-- require('lint')[linter_name].setup({})
		end,
	}
})

require('lint').linters_by_ft = {
  c = {'cpplint'},
  cpp = {'cpplint'},
}

vim.api.nvim_create_autocmd('BufWritePost',{
	desc = 'On buffer write post',
	callback = function()

    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    require("lint").try_lint()

    -- You can call `try_lint` with a linter name or a list of names to always
    -- run specific linters, independent of the `linters_by_ft` configuration
	-- require("lint").try_lint("cspell")
  	end
})

print("salut")

local formatters = {	
}

-- vim.cmd.MasonInstall('cortex-debug')	-- BUG: somehow this has to be installed from mason directly
-- vim.cmd.MasonUpdate()
--
-- Show linters for the current buffer's file type
vim.api.nvim_create_user_command("LintInfo", function()
  local filetype = vim.bo.filetype
  local current_linters = require("lint").linters_by_ft[filetype]

  if current_linters then
    print("Linters for " .. filetype .. ": " .. table.concat(current_linters, ", "))
  else
    print("No linters configured for filetype: " .. filetype)
  end
end, {})
