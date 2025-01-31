local line_types = require('lmonfette/config/coding_style/doxygen/line_types')
local utils = {}

utils.line_type_to_type_name = {
    [line_types.unknown] = 'unknown',
    [line_types.file] = 'file',
    [line_types.author] = 'author',
    [line_types.date] = 'date',
    [line_types.version] = 'version',
    [line_types.brief] = 'brief',
    [line_types.param] = 'param',
    [line_types.list_item] = 'list item',
    [line_types.retval] = 'retval',
    [line_types.return_] = 'return',
    [line_types.syntax] = 'syntax',
    [line_types.text] = 'text',
    [line_types.copyright] = 'copyright',
    [line_types.license] = 'license',
    [line_types.empty] = 'empty line',
    [line_types.start] = 'start line',
    [line_types.end_] = 'end line',
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

function utils.format_sentence_grammar(first_word_index, words)
    words[first_word_index] = utils.capitalize_first_letter(words[first_word_index])
    words[#words] = utils.ensure_period(words[#words])
end

function utils.replace_lines(start_line, end_line, new_lines)
    local bufnr = vim.api.nvim_get_current_buf() -- Get the current buffer
    vim.api.nvim_buf_set_lines(bufnr, start_line, end_line, false, new_lines)
end

function utils.delete_line(line_number)
    local bufnr = vim.api.nvim_get_current_buf() -- Get the current buffer
    vim.api.nvim_buf_set_lines(bufnr, line_number - 1, line_number, false, {})
end

function utils.contains_statement_type(stmt_types, the_statement_type)
    for _, stmt_type in ipairs(stmt_types) do
        if stmt_type == the_statement_type then
            return true
        end
    end
    return false
end

function utils.extract_line_type(words)
    if #words == 1 then
        if words[1] == '*' then
            return line_types.empty
        elseif words[1] == '/*' or words[1] == '/**' then
            return line_types.start
        elseif words[1] == '*/' or words[1] == '**/' then
            return line_types.end_
        end
    end

    for _, word in ipairs(words) do
        if word == '@file' then
            return line_types.file
        elseif word == '@author' then
            return line_types.file
        elseif word == '@data' then
            return line_types.file
        elseif word == '@version' then
            return line_types.file
        elseif word == '@brief' then
            return line_types.brief
        elseif word == '@param[in]' or word == '@param[out]' or word == '@param[in|out]' then
            return line_types.param
        elseif word == '@li' then
            return line_types.list_item
        elseif word == '@retval' then
            return line_types.retval
        elseif word == '@return' then
            return line_types.return_
        elseif word == '@syntax' then
            return line_types.syntax
        elseif word == '@text' then
            return line_types.text
        elseif word == '@copyright' then
            return line_types.copyright
        elseif word == '@license' then
            return line_types.license
        end
    end

    if #words > 1 then
        return line_types.text
    end

    return line_types.unknown
end

function utils.split_into_words(sentence)
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

function utils.create_spaces_string(nb_spaces)
    local spaces = ''
    for _ = 1, nb_spaces do
        spaces = spaces .. ' '
    end
    return spaces
end

function utils.create_spaces(word, longest_word, spaces_between)
    local nb_spaces = longest_word - word:len() + spaces_between
    return utils.create_spaces_string(nb_spaces)
end

return utils
