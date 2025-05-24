return {
	url = 'https://github.com/williamboman/mason.nvim.git',
	dependencies = {
		-- registry for mason to install packages from
		{ url = 'https://github.com/neovim/nvim-lspconfig.git' },
		-- package to manage language servers
		{ url = 'https://github.com/williamboman/mason-lspconfig.nvim.git' },
		-- package to manage DAPs (debug adapter protocol)
		{ url = 'https://github.com/mfussenegger/nvim-dap.git' },
		{ url = 'https://github.com/jay-babu/mason-nvim-dap.nvim.git' },
		-- package to manage linters
		{ url = 'https://github.com/mfussenegger/nvim-lint.git' },
		{ url = 'https://github.com/rshkarin/mason-nvim-lint.git' },
		-- package to manager formatters
		{ url = 'https://github.com/mhartington/formatter.nvim.git' }
	},
}
