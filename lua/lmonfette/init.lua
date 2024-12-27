local logging = require('lmonfette/logging')
logging.debug('lua/lmonfette/init.lua')

-- setup remaps
vim.g.mapleader = ' ' -- set the leader variable to be a space
vim.g.maplocalleader = '\\'

vim.g.wrap = false;

-- please install nerd fonts on you computer: https://github.com/ryanoasis/nerd-fonts.git

vim.keymap.set('n', '<A-Up>', '15k')	-- move cursor 20 lines up
vim.keymap.set('n', '<A-Down>', '15j')	-- move cursor 20 lines down

vim.keymap.set('v', '<A-Up>', '15k')	-- move cursor 20 lines up
vim.keymap.set('v', '<A-Down>', '15j')	-- move cursor 20 lines down

-- vim.keymap.set('n', 'w', '15l');		-- jump 15 characters to the right
-- vim.keymap.set('n', 'b', '15h');		-- jump 15 characters to the left

vim.keymap.set('n', '<S-A-Up>', ':m-2<CR>==', { noremap = true, silent = true })			-- move a line up
vim.keymap.set('n', '<S-A-Down>', ':m+<CR>==', { noremap = true, silent = true })			-- move a line down

vim.keymap.set('v', '<S-A-Up>', ':m \'<-2<CR>gv=gv', { noremap = true, silent = true })		-- move a line up
vim.keymap.set('v', '<S-A-Down>', ':m \'>+<CR>gv=gv', { noremap = true, silent = true })	-- move a line down

vim.keymap.set('n', '<S-D>', '"_dd') 	-- delete a line

vim.keymap.set('n', '<C-->', '_')		-- go to the start of line
vim.keymap.set('n', '<C-=>', '$') 		-- go to the end of line

vim.keymap.set('i', '<C-->', '<Esc>_i')	        -- move cursor to the start of line
vim.keymap.set('i', '<C-=>', '<Esc>$a<Right>')  -- move cursor to the end of line

vim.keymap.set('v', '<C-->', '_')	        -- move cursor to the start of line
vim.keymap.set('v', '<C-=>', '$<Left>')		-- move cursor to the end of line

-- to get used to neovim
vim.keymap.set('n', '<Left>', function() logging.error('sucker !') end)
vim.keymap.set('n', '<Down>', function() logging.error('sucker !') end)
vim.keymap.set('n', '<Up>', function() logging.error('sucker !') end)
vim.keymap.set('n', '<Right>', function() logging.error('sucker !') end)

-- setup options
vim.opt.nu              = true  --
vim.opt.relativenumber  = true --

vim.o.tabstop           = 4     -- a tab creates up to 4 spaces
vim.o.shiftwidth        = 4     -- a tab is the size of 4 spaces for auto indent
vim.o.softtabstop       = 4     -- a backspace removes up to 4 spaces
vim.o.expandtab         = true  -- convert tabs to spaces
