local comment = require('Comment')
local comment_config = {}

local function init()
    comment.setup()
end

local function set_options()
end

local function set_remaps()
end

function comment_config.setup()
    init()
    set_options()
    set_remaps()
end

return comment_config
