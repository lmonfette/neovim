-- this is copied from: https://github.com/mhartington/formatter.nvim

local logging = {}

local state = require('lmonfette/state')

logging.notify_opts = { title = 'lmonfette'}

logging.current_format_mods = nil

function logging.is_current_format_silent()
    if logging.current_format_mods == nil then
        return false
    end

    return string.match(logging.current_format_mods, 'silent')
end

local function should_log(log_level)
    return state.logging_active and state.log_level <= log_level and not logging.is_current_format_silent()
end

function logging.trace(txt)
    if should_log(vim.log.levels.TRACE) then vim.notify(txt, vim.log.levels.TRACE, logging.notify_opts) end
end

function logging.debug(txt)
    if should_log(vim.log.levels.DEBUG) then vim.notify(txt, vim.log.levels.DEBUG, logging.notify_opts) end
end

function logging.info(txt)
    if should_log(vim.log.levels.INFO) then vim.notify(txt, vim.log.levels.INFO, logging.notify_opts) end
end

function logging.warn(txt)
    if should_log(vim.log.levels.WARN) then vim.notify(txt, vim.log.levels.WARN, logging.notify_opts) end
end

function logging.error(txt)
    if should_log(vim.log.levels.ERROR) then vim.notify(txt, vim.log.levels.ERROR, logging.notify_opts) end
end

return logging
