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

function utils.extract_file_section(line)
    for _, file_section in ipairs(types.file_section) do
        if line.find(types.file_section_keywords[file_section]) then
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
