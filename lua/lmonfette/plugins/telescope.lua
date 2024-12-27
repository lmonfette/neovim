-- telescope - used to browse files easily
return {
	url = 'https://github.com/nvim-telescope/telescope.nvim.git',
	dependencies = {
		{ url = 'https://github.com/nvim-lua/plenary.nvim.git' }, -- plenary is a basic functions library in vim
		-- other requirements:
		--  - ripgrep    (locally): additonnal grep functionalities
		--  - fd:        (locally): user friendly find utility for the file system
		--  - treesitter  (plugin): provide code parsing, highlighting and interactive functionalities
	}
}
