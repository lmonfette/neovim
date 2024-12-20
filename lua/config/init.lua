-- setup remaps
vim.g.mapleader = ' ' -- set the leader variable to be a space
vim.g.maplocalleader = '\\'

vim.keymap.set("n", "<leader>pp", vim.cmd.Ex) -- execute explore command for specified sequence when in normal mode 

vim.keymap.set('n', '<A-Up>', '15k')	-- move cursor 20 lines up
vim.keymap.set('n', '<A-Down>', '15j')	-- move cursor 20 lines down

vim.keymap.set('n', 'w', '15l');		-- jump 15 characters to the right
vim.keymap.set('n', 'b', '15h');		-- jump 15 characters to the left

vim.keymap.set('n', '<S-A-Up>', ':m-2<CR>==', { noremap = true, silent = true })			-- move a line up
vim.keymap.set('n', '<S-A-Down>', ':m+<CR>==', { noremap = true, silent = true })			-- move a line down

vim.keymap.set('v', '<S-A-Up>', ':m \'<-2<CR>gv=gv', { noremap = true, silent = true })		-- move a line up
vim.keymap.set('v', '<S-A-Down>', ':m \'>+<CR>gv=gv', { noremap = true, silent = true })	-- move a line down

vim.keymap.set('n', '<S-D>', '"_dd') 	-- delete a line

vim.keymap.set('n', '<C-->', '_')		-- go to the start of line
vim.keymap.set('n', '<C-=>', '$') 		-- go to the end of line

vim.keymap.set('i', '<C-->', '<Esc>_i')	-- move cursor to the start of line
vim.keymap.set('i', '<C-=>', '<Esc>$a')	-- move cursor to the end of line

vim.keymap.set('v', '<C-->', '_')		-- move cursor to the start of line
vim.keymap.set('v', '<C-=>', '$')		-- move cursor to the end of line

-- setup options
vim.opt.nu          = true  -- show line numbers
vim.o.tabstop       = 4     -- a tab is the size of 4 spaces
vim.o.shiftwidth    = 4     -- a tab is the size of 4 spaces for auto indent
vim.o.expandtab     = false -- do not convert tabs to spaces

-- setup package manager
require('config/lazy')
