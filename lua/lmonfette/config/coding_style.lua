local line_types = require('lmonfette/config/coding_style/doxygen/line_types')
local utils = require('lmonfette/config/coding_style/doxygen/utils')
local formatter = require('lmonfette/config/coding_style/doxygen/formatter')
local coding_style_config = {}

local function format_doygen_comments(lines, whitespaces)
    local replace = false
    local words_array = {}

    -- split the lines into word arrays
    for i, line in ipairs(lines) do
        words_array[i] = utils.split_into_words(line)
    end

    local longest_tag = 0
    local longest_id = 0
    local stmt_types = {}

    -- extract line info
    for i, words in ipairs(words_array) do
        stmt_types[i] = utils.extract_line_type(words)

        local tag_len
        local id_len

        if
            stmt_types[i] == line_types.param
            or stmt_types[i] == line_types.retval
            or stmt_types[i] == line_types.list_item
        then
            replace = true
            tag_len = words[2]:len()
            id_len = words[3]:len()

            longest_tag = tag_len > longest_tag and tag_len or longest_tag
            longest_id = id_len > longest_id and id_len or longest_id
        end
        if stmt_types[i] == line_types.syntax or stmt_types[i] == line_types.return_ then
            replace = true
        end
    end

    for i, words in ipairs(words_array) do
        local line_whitespaces = whitespaces
        local lmd = {
            i > 1 and stmt_types[i] == line_types.brief and not utils.contains_statement_type(
                stmt_types,
                line_types.file
            ) and true or false,
            longest_tag,
            longest_id,
        }
        lines[i] = formatter.handlers[stmt_types[i]](lines[i], words, lmd)

        if
            stmt_types[i] == line_types.empty
            or stmt_types[i] == line_types.start
            or stmt_types[i] == line_types.end_
            or stmt_types[i] == line_types.text
        then
            if i ~= 1 then
                line_whitespaces = ''
            end
        end

        lines[i] = line_whitespaces .. lines[i]
    end

    if utils.contains_statement_type(stmt_types, line_types.brief) == false then
        return replace and lines or nil
    end

    local lines_indices_to_remove = {}

    for i, stmt_type in ipairs(stmt_types) do
        if stmt_type == line_types.empty or stmt_type == line_types.text or stmt_type == line_types.start then
            lines_indices_to_remove[#lines_indices_to_remove + 1] = i
        else
            break
        end
    end

    for i = #stmt_types - 1, 1, -1 do
        if stmt_types[i] == line_types.empty then
            lines_indices_to_remove[#lines_indices_to_remove + 1] = i
        else
            break
        end
    end

    local function array_contains_number(array, number)
        for _, value in ipairs(array) do
            if value == number then
                return true
            end
        end
        return false
    end
    local final_lines = {}

    for i, line in ipairs(lines) do
        if array_contains_number(lines_indices_to_remove, i) == false then
            final_lines[#final_lines + 1] = line
        end
    end

    return replace and final_lines or nil
end

local function find_brief_comments()
    local bufnr = vim.api.nvim_get_current_buf()
    local parser = vim.treesitter.get_parser(bufnr, vim.bo.filetype)
    local tree = parser:parse()[1]
    local root = tree:root()

    local comment_nodes = {}

    -- Recursively find comment nodes
    local function find_comments(node)
        for child in node:iter_children() do
            local type = child:type()
            if type == 'comment' then
                table.insert(comment_nodes, child)
            else
                find_comments(child)
            end
        end
    end

    find_comments(root)
    local lines_to_remove = {}

    for _, comment_node in ipairs(comment_nodes) do
        local start_row, start_col, end_row, end_col = comment_node:range()

        -- Extract the text for the comment
        local lines = vim.api.nvim_buf_get_text(bufnr, start_row, start_col, end_row, end_col, {})

        local whitespaces = ''

        for _ = 1, start_col do
            whitespaces = whitespaces .. ' '
        end
        local new_lines = format_doygen_comments(lines, whitespaces)
        if new_lines ~= nil then
            local new_end_row = end_row + 1 - (#lines - #new_lines)
            utils.replace_lines(start_row, new_end_row, new_lines)

            for i = new_end_row, end_row do
                lines_to_remove[#lines_to_remove + 1] = i
            end
        end
    end

    for i = #lines_to_remove, 1, -1 do
        utils.delete_line(lines_to_remove[i])
    end
end

local function init()
    vim.keymap.set('n', '<leader>fc', find_brief_comments, {}) -- find a file by name opened root directory
end

local function set_options() end

local function set_remaps() end

function coding_style_config.setup()
    init()
    set_options()
    set_remaps()
end

return coding_style_config
