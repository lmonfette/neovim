# neovim
Personal neovim configuration

## how vim works

When vim is started, it will search some directories and its sub-directories.
It will then executes the files found. Here is the standard order for folder search:

 1. nvim/init.lua
 2. nvim/plugin
 3. nvim/ftplugin (file type)
 4. nvim/syntax
 5. nvim/after/plugin
 6. nvim/after/ftplugin
 7. nvim/after/syntax

