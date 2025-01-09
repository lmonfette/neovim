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

 ## my setup

 --- init.lua ---
 1. init.lua requires config/options
 2. init.lua requires config/remaps
 3. init.lua requires config/lazy -> init lazy
 --- after/plugin ---
 4. each plugin calls its setup function from its config file
 --- lua/config ---
    - a config file is under /lua/config/plugin_name.lua
    - a config file has private functions:
        - set_options()
        - set_remaps()
        - init()
    - a config file has 1 public function: setup()
 
 TODO:

 - separate lsp, dap, linter and formatter
 - separate each of those categories in "download" and "configure" phases
 - setup formatters
