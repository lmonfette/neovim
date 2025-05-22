local logging = require('lmonfette/logging')
local utils = require('lmonfette/config/coding_style/doxygen/utils')
local types = require('lmonfette/config/coding_style/doxygen/types')

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
    local spacers = {}
    for i, _ in ipairs(words) do
        spacers[i] = ' '
    end
    spacers[1] = '  '

    local new_line = ''

    for i = 1, #words do
        new_line = new_line .. words[i] .. spacers[i]
    end

    return new_line
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

    utils.format_sentence_grammar(3, #words, words)

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
    spacers[2] = utils.create_spaces(words[2], lmd[longest_tag_index], 1)
    spacers[3] = utils.create_spaces(words[3], lmd[longest_id_index], 2)
    spacers[#spacers] = ''

    utils.format_sentence_grammar(4, #words, words)

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

    utils.format_sentence_grammar(4, #words, words)

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
    spacers[2] = ' '
    spacers[3] = '  '
    -- spacers[2] = utils.create_spaces(words[2], lmd[longest_tag_index], 1)
    -- spacers[3] = utils.create_spaces(words[3], lmd[longest_id_index], 2)
    spacers[#spacers] = ''

    utils.format_sentence_grammar(4, #words, words)

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
    spacers[2] = ' '
    -- spacers[2] = utils.create_spaces(words[2], lmd[longest_tag_index], 1)
    -- spacers[2] = spacers[2]
    --     .. utils.create_spaces(
    --         '',
    --         lmd[longest_id_index],
    --         utils.calculate_id_and_description_space_nb(lmd[longest_id_index])
    --     )
    spacers[#spacers] = ''

    utils.format_sentence_grammar(3, #words, words)

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
    spacers[2] = utils.create_spaces(words[2], lmd[longest_tag_index], 1)
    spacers[2] = spacers[2]
        .. utils.create_spaces(
            '',
            lmd[longest_id_index],
            utils.calculate_id_and_description_space_nb(lmd[longest_id_index])
        )
    spacers[#spacers] = ''

    utils.format_sentence_grammar(3, #words, words)

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
    [types.line.unknown] = format_unknown_line,
    [types.line.file] = format_file_line,
    [types.line.author] = format_author_line,
    [types.line.date] = format_date_line,
    [types.line.version] = format_version_line,
    [types.line.brief] = format_brief_line,
    [types.line.param] = format_param_line,
    [types.line.list_item] = format_list_item_line,
    [types.line.retval] = format_retval_line,
    [types.line.return_] = format_return_line,
    [types.line.syntax] = format_syntax_line,
    [types.line.text] = format_text_line,
    [types.line.copyright] = format_copyright_line,
    [types.line.license] = format_license_line,
    [types.line.empty] = format_empty_line,
    [types.line.start] = format_start_line,
    [types.line.end_] = format_end_line,
}

return formatter
