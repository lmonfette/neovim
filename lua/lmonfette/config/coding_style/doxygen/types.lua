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

types.file_section = {
    includes = 0,
    constants = 1,
    macros = 2,
    types = 3,
    externs = 4,
    public_globals = 5,
    private_globals = 6,
    public_function_prototypes = 7,
    private_function_prototypes = 8,
    public_functions = 9,
    private_functions = 10,
    unknown = 11,
}

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
    [types.file_section.private_function_prototypes] = '* PRIVATE FUNCTIONS *',
}

return types
