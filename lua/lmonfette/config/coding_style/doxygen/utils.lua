local line_types = require('lmonfette/config/coding_style/doxygen/line_types.lua')
local utils = {}

utils.line_type_to_type_name = {
    line_types.none        = "none",
    line_types.file        = "file",
    line_types.author      = "author",
    line_types.date        = "date",
    line_types.version     = "version",
    line_types.brief       = "brief",
    line_types.param       = "param",
    line_types.list_item   = "list item",
    line_types.retval      = "retval",
    line_types.return_     = "return",
    line_types.syntax      = 'syntax',
    line_types.empty_line  = 'empty line'
}
    if st == statement_type.none_s then
        return 'none'
    elseif st == statement_type.empty_line_s then
        return 'empty_line'
    elseif st == statement_type.brief_s then
        return 'brief'
    elseif st == statement_type.param_s then
        return 'param'
    elseif st == statement_type.list_item_s then
        return 'list_item'
    elseif st == statement_type.retval_s then
        return 'retval'
    elseif st == statement_type.return_s then
        return 'return'
    elseif st == statement_type.syntax_s then
        return 'syntax'
    elseif st == statement_type.file_s then
        return 'file'
    end
    return 'unknown'
end

function utils.print_st(st)
    print(utils.line_type_to_string(st))
end
 return utils
