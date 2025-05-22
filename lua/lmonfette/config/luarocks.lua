local utils = require('lmonfette/utils')
local luarocks_config = {}

local function init()
    require("luarocks-nvim").setup()
    utils.luarocks_install('luafilesystem', 'lfs') -- lfs
end

local function set_options()
end

local function set_remaps()
end

function luarocks_config.setup()
    init()
    set_options()
    set_remaps()
end

return luarocks_config
