local logging = require('lmonfette/logging')
local utils = require('lmonfette/config/coding_style/doxygen/utils')
local line_types = require('lmonfette/config/coding_style/doxygen/line_types')

local should_be_first_line_index = 1
local longest_tag_index = 2
local longest_id_index = 3

local formatter = {}

local function format_unknown_line(line, words, lmd)
    if line ~= '' then
        logging.error("The unknown line type '" .. "' can't be handled")
    end
    return line
end

local function format_file_line(line, words, lmd)
    return line
end

local function format_author_line(line, words, lmd)
    return line
end

local function format_date_line(line, words, lmd)
    return line
end

local function format_version_line(line, words, lmd)
    return line
end

local function format_text_line(line, words, lmd)
    return line
end

local function format_copyright_line(line, words, lmd)
    return line
end

local function format_license_line(line, words, lmd)
    return line
end

-- lmd: (line metadata)
-- - is_first_line
-- - longest_tag_index
-- - longest_id_index
local function format_brief_line(line, words, lmd)
    local spacers = {}
    for i, _ in ipairs(words) do
        spacers[i] = ' '
    end
    spacers[#spacers] = ''

    if #words < 3 then
        logging.error("The brief line '" .. line .. "' does not have enough words.")
        return line
    end

    if lmd[should_be_first_line_index] then
        words[1] = '/**'
    end

    utils.format_sentence_grammar(3, words)

    local new_line = ''

    for i = 1, #words do
        new_line = new_line .. words[i] .. spacers[i]
    end

    return new_line
end

local function format_param_line(line, words, lmd)
    if #words < 4 then
        logging.error("The param line '" .. line .. "' does not have enough words.")
        return line
    end

    local spacers = {}
    for i, _ in ipairs(words) do
        spacers[i] = ' '
    end

    -- format the spaces
    spacers[1] = '  '
    spacers[2] = utils.create_spaces(words[2], lmd[longest_tag_index], 2)
    spacers[3] = utils.create_spaces(words[3], lmd[longest_id_index], 2)
    spacers[#spacers] = ''

    utils.format_sentence_grammar(4, words)

    local new_line = ' '

    for i = 1, #words do
        new_line = new_line .. words[i] .. spacers[i]
    end

    return new_line
end

local function format_list_item_line(line, words, lmd)
    if #words < 4 then
        logging.error("The list item line '" .. line .. "' does not have enough words.")
        return line
    end

    local spacers = {}
    for i, _ in ipairs(words) do
        spacers[i] = ' '
    end

    spacers[1] = spacers[1] .. '  '
    spacers[2] = utils.create_spaces(words[2], lmd[longest_tag_index] - 2, 2)
    spacers[3] = utils.create_spaces(words[3], lmd[longest_id_index], 2)
    spacers[#spacers] = ''

    utils.format_sentence_grammar(4, words)

    local new_line = ' '

    for i = 1, #words do
        new_line = new_line .. words[i] .. spacers[i]
    end

    return new_line
end

local function format_retval_line(line, words, lmd)
    if #words < 4 then
        logging.error("The retval line '" .. line .. "' does not have enough words.")
        return words
    end

    local spacers = {}
    for i, _ in ipairs(words) do
        spacers[i] = ' '
    end

    spacers[1] = '  '
    spacers[2] = utils.create_spaces(words[2], lmd[longest_tag_index], 2)
    spacers[3] = utils.create_spaces(words[3], lmd[longest_id_index], 2)
    spacers[#spacers] = ''

    utils.format_sentence_grammar(4, words)

    local new_line = ' '

    for i = 1, #words do
        new_line = new_line .. words[i] .. spacers[i]
    end

    return new_line
end

local function format_return_line(line, words, lmd)
    if #words < 3 then
        logging.error("The return line '" .. line .. "' does not have enough words.")
        return line
    end

    local spacers = {}
    for i, _ in ipairs(words) do
        spacers[i] = ' '
    end

    spacers[1] = '  '
    spacers[2] = utils.create_spaces(words[2], lmd[longest_tag_index], 2)
    spacers[2] = spacers[2] .. utils.create_spaces('', lmd[longest_id_index], 2)
    spacers[#spacers] = ''

    utils.format_sentence_grammar(3, words)

    local new_line = ' '

    for i = 1, #words do
        new_line = new_line .. words[i] .. spacers[i]
    end

    return new_line
end

local function format_syntax_line(line, words, lmd)
    if #words < 3 then
        logging.error("The syntax line '" .. line .. "' does not have enough words.")
        return line
    end

    local spacers = {}
    for i, _ in ipairs(words) do
        spacers[i] = ' '
    end

    spacers[1] = '  '
    spacers[2] = utils.create_spaces(words[2], lmd[longest_tag_index], 2)
    spacers[2] = spacers[2] .. utils.create_spaces('', lmd[longest_id_index], 2)
    spacers[#spacers] = ''

    utils.format_sentence_grammar(3, words)

    local new_line = ' '

    for i = 1, #words do
        new_line = new_line .. words[i] .. spacers[i]
    end

    return new_line
end

local function format_empty_line(line)
    return line
end

local function format_start_line(line)
    return line
end

local function format_end_line(line)
    return line
end

formatter.handlers = {
    [line_types.unknown] = format_unknown_line,
    [line_types.file] = format_file_line,
    [line_types.author] = format_author_line,
    [line_types.date] = format_date_line,
    [line_types.version] = format_version_line,
    [line_types.brief] = format_brief_line,
    [line_types.param] = format_param_line,
    [line_types.list_item] = format_list_item_line,
    [line_types.retval] = format_retval_line,
    [line_types.return_] = format_return_line,
    [line_types.syntax] = format_syntax_line,
    [line_types.text] = format_text_line,
    [line_types.copyright] = format_copyright_line,
    [line_types.license] = format_license_line,
    [line_types.empty] = format_empty_line,
    [line_types.start] = format_start_line,
    [line_types.end_] = format_end_line,
}

return formatter
