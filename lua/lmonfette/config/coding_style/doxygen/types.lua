local types = {}

types.line = {
    unknown = 0,
    file = 1,
    author = 2,
    date = 3,
    version = 4,
    brief = 5,
    param = 6,
    list_item = 7,
    retval = 8,
    return_ = 9,
    syntax = 10,
    text = 11,
    copyright = 12,
    license = 13,
    empty = 14,
    start = 15,
    end_ = 16,
}

types.nb_line_types = 16

types.file_section = {
    unknown = 0,
    includes = 1,
    constants = 2,
    macros = 3,
    types = 4,
    externs = 5,
    public_globals = 6,
    private_globals = 7,
    public_function_prototypes = 8,
    private_function_prototypes = 9,
    public_functions = 10,
    private_functions = 11,
}

types.nb_file_section_types = 11

types.file_section_keywords = {
    [types.file_section.includes] = '* INCLUDES *',
    [types.file_section.constants] = '* CONSTANTS *',
    [types.file_section.macros] = '* MACROS *',
    [types.file_section.types] = '* TYPES *',
    [types.file_section.externs] = '* EXTERNS *',
    [types.file_section.public_globals] = '* PUBLIC GLOBALS *',
    [types.file_section.private_globals] = '* PRIVATE GLOBALS *',
    [types.file_section.public_function_prototypes] = '* PUBLIC FUNCTION PROTOTYPES *',
    [types.file_section.private_function_prototypes] = '* PRIVATE FUNCTION PROTOTYPES *',
    [types.file_section.public_functions] = '* PUBLIC FUNCTIONS *',
    [types.file_section.private_functions] = '* PRIVATE FUNCTIONS *',
}

return types
