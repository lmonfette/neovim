-- remaps eor telescope

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })    -- find a file by name search in opened root directory
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })      -- find a file by greping in it
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })          -- find a file from the opened buffers
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })      -- find a help menu
