-- all values can be found here: https://luacheck.readthedocs.io/en/stable/config.html

-- Maximum allowed line length
max_line_length = 150

-- Include/exclude files or directories
-- These patterns use Lua's string matching syntax
include_files = {
   "%.lua$", -- Only include `.lua` files
}
exclude_files = {
   "test/.*", -- Exclude files in the `test` directory
   "node_modules/.*", -- Exclude `node_modules`
}

-- Specify globals that are allowed without warnings
globals = {
   "vim",       -- For Neovim Lua API
   "use",       -- For plugin configurations in packer.nvim
   "describe",  -- For testing frameworks like busted
   "it",        -- For testing frameworks like busted
}

-- Read-only globals (safe globals that should not be re-assigned)
read_globals = {
   "pairs", "ipairs", "print", "require", "table", "string", "math"
}

-- Ignored warnings by code
ignore = {
   "113", -- Unused variable
   "211", -- Unused function argument
}

-- Specify which warnings to enable/disable
-- Warnings are documented in luacheck's manual
enable = {
   "redefined", -- Catch redefined variables
   "unused",    -- Catch unused variables
}

-- Overrides for specific files
files = {
   ["init.lua"] = {
      globals = { "my_custom_global" },
      ignore = { "113" },
   },
   ["config/plugins.lua"] = {
      max_line_length = 80,
   },
}

