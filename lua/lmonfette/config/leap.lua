local leap = require('leap')
local leap_config = {}

local function init()
    leap.create_default_mappings()
end

local function set_options()
end

local function set_remaps()
end

function leap_config.setup()
    init()
    set_options()
    set_remaps()
end

return leap_config
