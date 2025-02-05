local types = require('lmonfette/config/coding_style/doxygen/types')
local utils = require('lmonfette/config/coding_style/doxygen/utils')
local formatter = require('lmonfette/config/coding_style/doxygen/formatter')
local coding_style_config = {}

local function reorder_file_sections(line)
    -- 1. parse each comment to see if they are a sections beginning

    local file_section = utils.extract_file_section(line)

    -- 2. make a list of all the line number for each section number

    -- 3. with some brain logic, find the ending
    -- 3.1 if there is a next section, take the next section's line number - 1
    -- 3.2 else, it's the last, so take the last line

    -- 4. copy the sections of text of the files and keep them in memory but in the desired order

    -- 5. delete all the text starting from the first section

    -- 6. paste it in order at the end of the file
end

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
            stmt_types[i] == types.line.param
            or stmt_types[i] == types.line.retval
            or stmt_types[i] == types.line.list_item
        then
            replace = true
            tag_len = words[2]:len()
            id_len = words[3]:len()

            longest_tag = tag_len > longest_tag and tag_len or longest_tag
            longest_id = id_len > longest_id and id_len or longest_id
        end
        if
            stmt_types[i] == types.line.syntax
            or stmt_types[i] == types.line.return_
            or stmt_types[i] == types.line.brief
        then
            replace = true
        end
    end

    if
        utils.contains_statement_type(stmt_types, types.line.brief)
        and utils.contains_statement_type(stmt_types, types.line.file)
    then
        replace = false
    end

    for i, words in ipairs(words_array) do
        local line_whitespaces = whitespaces
        local lmd = {
            i > 1 and stmt_types[i] == types.line.brief and not utils.contains_statement_type(
                stmt_types,
                types.line.file
            ) and true or false,
            longest_tag,
            longest_id,
        }
        lines[i] = formatter.handlers[stmt_types[i]](lines[i], words, lmd)

        if
            stmt_types[i] == types.line.empty
            or stmt_types[i] == types.line.start
            or stmt_types[i] == types.line.end_
            or stmt_types[i] == types.line.text
        then
            if i ~= 1 then
                line_whitespaces = ''
            end
        end

        lines[i] = line_whitespaces .. lines[i]
    end

    if utils.contains_statement_type(stmt_types, types.line.brief) == false then
        return replace and lines or nil
    end

    local lines_indices_to_remove = {}

    for i, stmt_type in ipairs(stmt_types) do
        if stmt_type == types.line.empty or stmt_type == types.line.start then
            lines_indices_to_remove[#lines_indices_to_remove + 1] = i
        else
            break
        end
    end

    for i = #stmt_types - 1, 1, -1 do
        if stmt_types[i] == types.line.empty then
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

local function get_section_delimiter_comments(bufnr, start_row_index, end_row_index)
    local comment_nodes = utils.get_comment_nodes()
    local section_delimiter_comments = {}

    for _, comment_node in ipairs(comment_nodes) do
        local lines = utils.get_lines_from_node(comment_node)

        if #lines == 1 then
            local file_section = utils.extract_file_section(lines[1])
            if file_section ~= types.file_section.unknown then
                local start_row, _, _, _ = comment_node:range()
                section_delimiter_comments[#section_delimiter_comments + 1] =
                    { comment_node, file_section, start_row, 0 }
            end
        end
    end

    if #section_delimiter_comments == 0 then
        return nil
    end

    for i = 2, #section_delimiter_comments do
        section_delimiter_comments[i - 1][end_row_index] = section_delimiter_comments[i][start_row_index] - 1
    end

    section_delimiter_comments[#section_delimiter_comments][end_row_index] = vim.api.nvim_buf_line_count(bufnr) - 1

    return section_delimiter_comments
end

local function order_file_sections(bufnr, start_row_index, end_row_index)
    local section_delimiter_comments = get_section_delimiter_comments(bufnr, start_row_index, end_row_index)

    if section_delimiter_comments == nil then
        return
    end

    local ordered_file_sections = utils.reorder_file_sections(section_delimiter_comments)
    if ordered_file_sections == nil then
        return
    end

    local start_row
    local end_row

    for _, ordered_file_section in ipairs(ordered_file_sections) do
        start_row = ordered_file_section[start_row_index]
        end_row = ordered_file_section[end_row_index] + 1 -- need to add one line for the vim api function to work
        local lines = utils.get_lines_from_row_range(start_row, end_row)
        utils.append_lines(lines)
    end

    start_row = section_delimiter_comments[1][start_row_index]
    end_row = section_delimiter_comments[#section_delimiter_comments][end_row_index] + 1 -- need to add one line

    utils.delete_lines(start_row, end_row)
end

local function remove_blank_lines_after_file_delimiters(bufnr, start_row_index, end_row_index)
    local deleted_blank_line = true
    local section_delimiter_comments
    while deleted_blank_line do
        deleted_blank_line = false

        section_delimiter_comments = get_section_delimiter_comments(bufnr, start_row_index, end_row_index)

        if section_delimiter_comments == nil then
            return
        end

        for i = #section_delimiter_comments, 1, -1 do
            local line_nb = section_delimiter_comments[i][start_row_index] + 1
            local line_after_delimiter = utils.get_line_from_row(line_nb)

            if #line_after_delimiter ~= 1 then
                return
            end

            if line_after_delimiter[1] == '' then
                deleted_blank_line = true
                utils.delete_line(line_nb)
            end
        end
    end
end

local function add_whiteline_before_file_delimiter(bufnr, start_row_index, end_row_index)
    local section_delimiter_comments = get_section_delimiter_comments(bufnr, start_row_index, end_row_index)

    if section_delimiter_comments == nil then
        return
    end

    for i = #section_delimiter_comments, 1, -1 do
        local line_nb = section_delimiter_comments[i][start_row_index] - 1
        local line_before_delimiter = utils.get_line_from_row(line_nb)

        if #line_before_delimiter ~= 1 then
            return
        end

        if line_before_delimiter[1] ~= '' then
            utils.add_lines_over(line_nb + 1, { '' })
        end
    end
end

local function find_single_line_comment()
    local bufnr = vim.api.nvim_get_current_buf()

    -- local comment_node_index = 1
    -- local file_section_index = 2
    local start_row_index = 3
    local end_row_index = 4

    -- order the file sections
    order_file_sections(bufnr, start_row_index, end_row_index)

    -- make sure no delimiter has a blank space over
    remove_blank_lines_after_file_delimiters(bufnr, start_row_index, end_row_index)

    -- make sure all delimiters have blank lines under
    add_whiteline_before_file_delimiter(bufnr, start_row_index, end_row_index)
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
    vim.keymap.set('n', '<leader>cs', function()
        find_brief_comments()
        find_single_line_comment()
    end, {}) -- find a file by name opened root directory
end

local function set_options() end

local function set_remaps() end

function coding_style_config.setup()
    init()
    set_options()
    set_remaps()
end

return coding_style_config
