local coding_style_config = {}

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
    local is_param_statement = false
    local is_retval_statement = false
    local is_li_statement = false
    local is_return_statement = false

    for _, word in ipairs(words) do
        if word == '@param[in]' or word == '@param[out]' or word == '@param[in|out]' then
            is_param_statement = true
        elseif word == '@li' then
            is_li_statement = true
        elseif word == '@retval' then
            is_retval_statement = true
        elseif word == '@return' or word == '@syntax' then
            is_return_statement = true
        end
    end
    return is_param_statement, is_retval_statement, is_li_statement, is_return_statement
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

local function format_doygen_comments(lines, whitespaces)
    local replace = false
    local words_array = {}

    for i, line in ipairs(lines) do
        words_array[i] = split_into_words(line)
    end

    local longest_tag = 0
    local longest_id = 0
    local format_flags = {}

    for i, words in ipairs(words_array) do
        local ips, irvs, ilis, irns = get_line_info(words)
        format_flags[i] = { ips or irvs or ilis or irns, irns, ilis } -- { to be formatted, is a return statement, is a list item }

        local tag_len
        local id_len = 0

        if #words > 2 then
            if ips or irvs or ilis or irns then
                replace = true
                tag_len = words[2]:len()
                if ips or irvs or ilis then
                    id_len = words[3]:len()
                end

                longest_tag = tag_len > longest_tag and tag_len or longest_tag
                longest_id = id_len > longest_id and id_len or longest_id
            end
        end
    end

    for i, words in ipairs(words_array) do
        local minimum_spaces_between_tag_and_description = 2
        if i == 1 then
            lines[i] = whitespaces .. lines[i]
        elseif format_flags[i][1] == true then
            local word_index = 1

            local line = ' ' .. words[word_index]
            word_index = word_index + 1

            if format_flags[i][3] then
                line = line .. '  '
            end

            line = line .. ' ' .. words[word_index]
            word_index = word_index + 1

            local nb_spaces

            if format_flags[i][2] == true then
                -- we format a retval
                nb_spaces = longest_tag - words[word_index - 1]:len() + minimum_spaces_between_tag_and_description
                nb_spaces = nb_spaces + longest_id + minimum_spaces_between_tag_and_description

                for _ = 1, nb_spaces do
                    line = line .. ' '
                end
            else
                -- we format a param or return
                nb_spaces = longest_tag - words[word_index - 1]:len() + minimum_spaces_between_tag_and_description

                if format_flags[i][3] then
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
                lines[i] = whitespaces .. line .. ensure_period(capitalize_first_letter(words[word_index]))
            else
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
    return replace
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

    for _, comment_node in ipairs(comment_nodes) do
        local start_row, start_col, end_row, end_col = comment_node:range()

        -- Extract the text for the comment
        local lines = vim.api.nvim_buf_get_text(bufnr, start_row, start_col, end_row, end_col, {})

        local whitespaces = ''

        for _ = 1, start_col do
            whitespaces = whitespaces .. ' '
        end

        if format_doygen_comments(lines, whitespaces) then
            for i, _ in ipairs(lines) do
                lines[i] = lines[i]
            end
            replace_lines(start_row, end_row + 1, lines)
        end
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
