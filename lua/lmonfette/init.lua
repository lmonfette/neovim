local utils = require('lmonfette/utils')
local logging = require('lmonfette/logging')
logging.debug('lua/lmonfette/init.lua')

-- system installs
utils.system_ensure_installed('luarocks')

-- setup remaps
vim.g.mapleader = ' ' -- set the leader variable to be a space
vim.g.maplocalleader = '\\'

vim.o.wrap = false
vim.o.scrolloff = 15
vim.o.mousescroll="ver:1,hor:2"
vim.o.scroll=12

-- please install nerd fonts on you computer: https://github.com/ryanoasis/nerd-fonts.git

vim.keymap.set('n', '<S-A-Up>', ':m-2<CR>==', { noremap = true, silent = true }) -- move a line up
vim.keymap.set('n', '<S-A-Down>', ':m+<CR>==', { noremap = true, silent = true }) -- move a line down

vim.keymap.set('v', '<S-A-Up>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true }) -- move a line up
vim.keymap.set('v', '<S-A-Down>', ":m '>+<CR>gv=gv", { noremap = true, silent = true }) -- move a line down

vim.keymap.set('n', '<S-E>', '"_ddk') -- delete a line
vim.keymap.set('v', '<S-E>', '"_dk') -- delete a visual selection

vim.keymap.set('v', '<C-->', '_') -- move cursor to the start of line
vim.keymap.set('v', '<C-=>', '$<Left>') -- move cursor to the end of line

vim.keymap.set('n', '<leader>mcc', ':! jq -s add ./**/compile_commands.json > compile_commands.json<CR>')

-- to get used to neovim
vim.keymap.set('n', '<Left>', function()
    logging.error('sucker !')
end)
vim.keymap.set('n', '<Down>', function()
    logging.error('sucker !')
end)
vim.keymap.set('n', '<Up>', function()
    logging.error('sucker !')
end)
vim.keymap.set('n', '<Right>', function()
    logging.error('sucker !')
end)

-- remove highlight
vim.keymap.set('n', '<leader>no', ':noh<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>rt', ':! ceedling test:all<CR>', { noremap = true, silent = true })

vim.api.nvim_create_user_command('W', 'w', {})

-- setup options
vim.opt.number = true --
vim.opt.relativenumber = true --

vim.o.cursorline = true --

vim.o.tabstop = 4 -- a tab creates up to 4 spaces
vim.o.shiftwidth = 4 -- a tab is the size of 4 spaces for auto indent
vim.o.softtabstop = 4 -- a backspace removes up to 4 spaces
vim.o.expandtab = true -- convert tabs to spaces
