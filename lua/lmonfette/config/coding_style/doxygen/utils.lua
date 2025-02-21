local logging = require('lmonfette/logging')
local types = require('lmonfette/config/coding_style/doxygen/types')
local utils = {}

utils.line_type_to_type_name = {
    [types.line.unknown] = 'unknown',
    [types.line.file] = 'file',
    [types.line.author] = 'author',
    [types.line.date] = 'date',
    [types.line.version] = 'version',
    [types.line.brief] = 'brief',
    [types.line.param] = 'param',
    [types.line.list_item] = 'list item',
    [types.line.retval] = 'retval',
    [types.line.return_] = 'return',
    [types.line.syntax] = 'syntax',
    [types.line.text] = 'text',
    [types.line.copyright] = 'copyright',
    [types.line.license] = 'license',
    [types.line.empty] = 'empty line',
    [types.line.start] = 'start line',
    [types.line.end_] = 'end line',
}

function utils.print_type_name(line_type)
    print(utils.line_type_to_type_name[line_type])
end

function utils.capitalize_first_letter(str)
    return str:sub(1, 1):upper() .. str:sub(2)
end

function utils.ensure_period(str)
    if str:sub(-1) ~= '.' then
        return str .. '.'
    end
    return str
end

function utils.format_sentence_grammar(first_word_index, last_word_index, words)
    words[first_word_index] = utils.capitalize_first_letter(words[first_word_index])
    words[last_word_index] = utils.ensure_period(words[last_word_index])
end

function utils.append_lines(new_lines)
    local bufnr = vim.api.nvim_get_current_buf()
    local last_line_index = vim.api.nvim_buf_line_count(bufnr)
    vim.api.nvim_buf_set_lines(bufnr, last_line_index, last_line_index, false, new_lines)
end

function utils.add_lines_over(line, new_lines)
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(bufnr, line, line, false, new_lines)
end

function utils.replace_lines(start_line, end_line, new_lines)
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(bufnr, start_line, end_line, false, new_lines)
end

function utils.delete_line(line_number)
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(bufnr, line_number, line_number + 1, false, {})
end

function utils.delete_lines(start_line, end_line)
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(bufnr, start_line, end_line, false, {})
end

function utils.reorder_file_sections(file_sections)
    local file_section_index = 2

    -- build an array of to hold all the ordered file sections
    local preliminary_ordered_file_sections = {}
    for _ = 1, types.nb_file_section_types do
        preliminary_ordered_file_sections[#preliminary_ordered_file_sections + 1] = false
    end

    for _, file_section in ipairs(file_sections) do
        -- write (or overwrite) the file section
        if preliminary_ordered_file_sections[file_section[file_section_index]] ~= false then
            logging.error(
                'The file section '
                    .. tostring(types.file_section_keywords[file_section[file_section_index]])
                    .. ' is present twice.'
            )
            return nil
        end
        preliminary_ordered_file_sections[file_section[file_section_index]] = file_section
    end

    local ordered_file_sections = {}
    for _, preliminary_ordered_file_section in ipairs(preliminary_ordered_file_sections) do
        -- collect the file sections that are present
        if preliminary_ordered_file_section then
            ordered_file_sections[#ordered_file_sections + 1] = preliminary_ordered_file_section
        end
    end

    -- if these to array sizes are not equal, it means we overwrote a file section,
    -- in that case, some file section was present twice of more times
    if #ordered_file_sections ~= #file_sections then
        logging.error(
            'reorder_file_sections: nb_file_sections = '
                .. tostring(#ordered_file_sections)
                .. ' != nb_file_sections = '
                .. tostring(#file_sections)
        )
        return nil
    end

    return ordered_file_sections
end

function utils.contains_statement_type(stmt_types, the_statement_type)
    for _, stmt_type in ipairs(stmt_types) do
        if stmt_type == the_statement_type then
            return true
        end
    end
    return false
end

function utils.extract_file_section(line)
    for file_section, file_section_string in pairs(types.file_section_keywords) do
        if line:find(file_section_string, 1, true) then
            return file_section
        end
    end

    return types.file_section.unknown
end

function utils.extract_line_type(words)
    if #words == 1 then
        if words[1] == '*' then
            return types.line.empty
        elseif words[1] == '/*' or words[1] == '/**' then
            return types.line.start
        elseif words[1] == '*/' or words[1] == '**/' then
            return types.line.end_
        end
    end

    for _, word in ipairs(words) do
        if word == '@file' then
            return types.line.file
        elseif word == '@author' then
            return types.line.file
        elseif word == '@data' then
            return types.line.file
        elseif word == '@version' then
            return types.line.file
        elseif word == '@brief' then
            return types.line.brief
        elseif word == '@param[in]' or word == '@param[out]' or word == '@param[in|out]' then
            return types.line.param
        elseif word == '@li' then
            return types.line.list_item
        elseif word == '@retval' then
            return types.line.retval
        elseif word == '@return' then
            return types.line.return_
        elseif word == '@syntax' then
            return types.line.syntax
        elseif word == '@text' then
            return types.line.text
        elseif word == '@copyright' then
            return types.line.copyright
        elseif word == '@license' then
            return types.line.license
        end
    end

    if #words > 1 then
        return types.line.text
    end

    return types.line.unknown
end

function utils.get_sentence_spaces(sentence)
    local whitespaces = {}
    local current_space = ''

    for i = 1, #sentence do
        local char = string.sub(sentence, i, i)

        if char ~= ' ' then
            if current_space ~= '' then
                table.insert(whitespaces, current_space)
                current_space = ''
            end
        else
            current_space = current_space .. char
        end
    end

    if current_space ~= '' then
        table.insert(whitespaces, current_space)
    end

    return whitespaces
end

function utils.split_into_words(sentence)
    local words = {}
    local current_word = ''

    for i = 1, #sentence do
        local char = string.sub(sentence, i, i)

        if char == ' ' then
            if current_word ~= '' then -- Check for empty words due to multiple spaces
                table.insert(words, current_word)
                current_word = ''
            end
        else
            current_word = current_word .. char -- Or current_word ..= char in Lua 5.3+
        end
    end

    if current_word ~= '' then -- Add the last word (if any)
        table.insert(words, current_word)
    end

    return words
end

function utils.create_spaces_string(nb_spaces)
    local spaces = ''
    for _ = 1, nb_spaces do
        spaces = spaces .. ' '
    end
    return spaces
end

function utils.calculate_id_and_description_space_nb(longest_id_length)
    return longest_id_length == 0 and 1 or 2
end

function utils.create_spaces(word, longest_word, spaces_between)
    local nb_spaces = longest_word - word:len() + spaces_between
    return utils.create_spaces_string(nb_spaces)
end

function utils.get_nodes_from_type(type, root_node)
    local bufnr = vim.api.nvim_get_current_buf()
    local parser = vim.treesitter.get_parser(bufnr, vim.bo.filetype)
    local tree = parser:parse()[1]
    local root = root_node ~= nil and root_node or tree:root()

    local comment_nodes = {}

    -- Recursively find comment nodes
    local function find_comments(node)
        for child in node:iter_children() do
            local child_type = child:type()
            if child_type == type then
                table.insert(comment_nodes, child)
            else
                find_comments(child)
            end
        end
    end

    find_comments(root)

    return comment_nodes
end

function utils.get_lines_from_row_range(start_row, end_row)
    local bufnr = vim.api.nvim_get_current_buf()

    local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row, false)

    return lines
end

function utils.get_line_from_row(row)
    local bufnr = vim.api.nvim_get_current_buf()

    local lines = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)

    return lines
end

function utils.get_lines_from_node(node)
    local bufnr = vim.api.nvim_get_current_buf()
    local start_row, start_col, end_row, end_col = node:range()

    local lines = vim.api.nvim_buf_get_text(bufnr, start_row, start_col, end_row, end_col, {})

    return lines
end

function utils.is_doxygen_file_header_present()
    local file_string = '/** @file '
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    for _, line in ipairs(lines) do
        if line:find(file_string, 1, true) then
            return true
        end
    end

    return false
end

return utils
