-- setup plugin manager (lazy)

local lazy_path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim' -- get the path where to copy lasy's repo
local lazy_fs_stat = (vim.uv or vim.loop).fs_stat(lazy_path)  -- check that lazy is locally on the file system

-- if lazy is not installed, install it
if not lazy_fs_stat then
  local lazy_url = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=main", lazy_url, lazy_path }) -- clone lazy locally

  -- error handling
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({{ "Failed to clone lazy.nvim:\n", "ErrorMsg" }, { out, "WarningMsg" },{ "\nPress any key to exit..." }}, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- 
vim.opt.rtp:prepend(lazy_path)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)

-- save leaders
local tmp_mapleader = vim.g.mapleader
local tmp_maplocalleader = vim.g.maplocalleader

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local setup_params = {
  spec = {
    -- import from /plugins directory
    { import = 'plugins' },
  },
  -- use borealis colorscheme when opening the package manager window
  install = { colorscheme = { 'borealis' } },
  -- automatically check for plugin updates
  checker = { enabled = true },
}

-- Setup lazy.nvim
require("lazy").setup(setup_params)

-- change leaders back to previous value
vim.g.mapleader = tmp_mapleader
vim.g.maplocalleader = tmp_maplocalleader
