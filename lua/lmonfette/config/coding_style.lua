local coding_style_config = {}

local statement_type = {
    none_s = 0,
    empty_line_s = 1,
    brief_s = 2,
    param_s = 3,
    list_item_s = 4,
    retval_s = 5,
    return_s = 6,
    syntax_s = 7,
    file_s = 8,
}

local function st_to_string(st)
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

local function print_st(st)
    print(st_to_string(st))
end

local function split_into_words(sentence)
    local words = {}
    local current_word = ''

    for i = 1, #sentence do
        local char = string.sub(sentence, i, i) -- Or just sentence[i] in Lua 5.3+

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

local function get_line_info(words)
    if #words == 1 then
        if words[1] == '*' or words[1] == '/*' or words[1] == '/**' then
            return statement_type.empty_line_s
        end
    end
    for _, word in ipairs(words) do
        if word == '@param[in]' or word == '@param[out]' or word == '@param[in|out]' then
            return statement_type.param_s
        elseif word == '@li' then
            return statement_type.list_item_s
        elseif word == '@retval' then
            return statement_type.retval_s
        elseif word == '@return' then
            return statement_type.return_s
        elseif word == '@syntax' then
            return statement_type.syntax_s
        elseif word == '@brief' then
            return statement_type.brief_s
        elseif word == '@file' then
            return statement_type.file_s
        end
    end
    return statement_type.none_s
end

local function capitalize_first_letter(str)
    return str:sub(1, 1):upper() .. str:sub(2)
end

local function ensure_period(str)
    if str:sub(-1) ~= '.' then
        return str .. '.'
    end
    return str
end

local function replace_lines(start_line, end_line, new_lines)
    local bufnr = vim.api.nvim_get_current_buf() -- Get the current buffer
    vim.api.nvim_buf_set_lines(bufnr, start_line, end_line, false, new_lines)
end

local function delete_line(line_number)
    local bufnr = vim.api.nvim_get_current_buf() -- Get the current buffer
    vim.api.nvim_buf_set_lines(bufnr, line_number - 1, line_number, false, {})
end

local function format_brief_line(words)
    local spacers = {}
    for i = 1, #words do
        spacers[i] = ' '
    end

    local word_index = 2

    local line = '/**' .. spacers[word_index] .. words[word_index]
    word_index = word_index + 1

    if #words < 3 then
        return line
    end

    print('3')
    words[word_index] = capitalize_first_letter(words[word_index])
    words[#words] = ensure_period(words[#words])

    for i = word_index, #words do
        line = line .. spacers[i] .. words[i]
    end
    return line
end

local function format_syntax_line(lines) end

local function contains_statement_type(stmt_types, the_statement_type)
    for _, stmt_type in ipairs(stmt_types) do
        if stmt_type == the_statement_type then
            return true
        end
    end
    return false
end

local function format_doygen_comments(lines, whitespaces)
    local replace = false
    local words_array = {}

    for i, line in ipairs(lines) do
        words_array[i] = split_into_words(line)
    end

    local longest_tag = 0
    local longest_id = 0
    local stmt_types = {}

    for i, words in ipairs(words_array) do
        stmt_types[i] = get_line_info(words)
        local tag_len
        local id_len = 0

        if #words > 2 then
            if stmt_types[i] ~= statement_type.empty_line_s and stmt_types[i] ~= statement_type.none_s then
                replace = true
                tag_len = words[2]:len()
                if
                    stmt_types[i] == statement_type.param_s
                    or stmt_types[i] == statement_type.retval_s
                    or stmt_types[i] == statement_type.list_item_s
                then
                    id_len = words[3]:len()
                end

                longest_tag = tag_len > longest_tag and tag_len or longest_tag
                longest_id = id_len > longest_id and id_len or longest_id
            end
        end
    end

    for i, words in ipairs(words_array) do
        local minimum_spaces_between_tag_and_description = 2
        print_st(stmt_types[i])
        print('line = ' .. lines[i])
        if stmt_types[i] == statement_type.brief_s then
            if contains_statement_type(stmt_types, statement_type.file_s) == false then
                lines[i] = format_brief_line(words)
            end
        elseif i == 1 then
            lines[i] = whitespaces .. lines[i]
        elseif
            stmt_types[i] == statement_type.list_item_s
            or stmt_types[i] == statement_type.param_s
            or stmt_types[i] == statement_type.return_s
            or stmt_types[i] == statement_type.retval_s
        then
            local word_index = 1

            local line = ' ' .. words[word_index]
            word_index = word_index + 1

            if stmt_types[i] == statement_type.list_item_s then
                line = line .. '  '
            end

            line = line .. ' ' .. words[word_index]
            word_index = word_index + 1

            local nb_spaces

            if stmt_types[i] == statement_type.retval_s then
                -- we format a retval
                nb_spaces = longest_tag - words[word_index - 1]:len() + minimum_spaces_between_tag_and_description
                nb_spaces = nb_spaces + longest_id + minimum_spaces_between_tag_and_description

                for _ = 1, nb_spaces do
                    line = line .. ' '
                end
            else
                -- we format a param or return
                nb_spaces = longest_tag - words[word_index - 1]:len() + minimum_spaces_between_tag_and_description

                if stmt_types[i] == statement_type.list_item_s then
                    nb_spaces = nb_spaces - 2
                end

                for _ = 1, nb_spaces do
                    line = line .. ' '
                end

                line = line .. words[word_index]
                word_index = word_index + 1

                nb_spaces = longest_id - words[word_index - 1]:len() + minimum_spaces_between_tag_and_description
                for _ = 1, nb_spaces do
                    line = line .. ' '
                end
            end

            if word_index == #words then
                print('1')
                lines[i] = whitespaces .. line .. ensure_period(capitalize_first_letter(words[word_index]))
            else
                print('2')
                print('#words = ' .. tostring(#words))
                print('word_index = ' .. tostring(word_index))
                line = line .. capitalize_first_letter(words[word_index]) .. ' '
                word_index = word_index + 1

                for j = word_index, #words - 1 do
                    line = line .. words[j] .. ' '
                end

                line = line .. ensure_period(words[#words])

                lines[i] = whitespaces .. line
            end
        end
    end

    if contains_statement_type(stmt_types, statement_type.brief_s) == false then
        return replace and lines or nil
    end

    local lines_indices_to_remove = {}

    for i, stmt_type in ipairs(stmt_types) do
        if stmt_type == statement_type.empty_line_s then
            lines_indices_to_remove[#lines_indices_to_remove + 1] = i
        else
            break
        end
    end

    for i = #stmt_types - 1, 1, -1 do
        if stmt_types[i] == statement_type.empty_line_s then
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
            replace_lines(start_row, new_end_row, new_lines)

            for i = new_end_row, end_row do
                lines_to_remove[#lines_to_remove + 1] = i
            end
        end
    end

    for i = #lines_to_remove, 1, -1 do
        delete_line(lines_to_remove[i])
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
