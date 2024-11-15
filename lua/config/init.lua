-- setup remaps
vim.g.mapleader = ' ' -- set the leader variable to be a space
vim.g.maplocalleader = '\\'

vim.keymap.set("n", "<leader>pp", vim.cmd.Ex) -- execute explore command for specified sequence when in normal mode 

-- setup options
vim.opt.nu = true              -- show the current line the cursor is on
vim.opt.relativenumber = true  -- show the relative line numbers above and below so we can to lines fast

-- setup package manager
require('config/lazy')
