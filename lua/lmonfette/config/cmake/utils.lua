local utils = {}

function utils.get_presets()
    local handle = io.popen("cmake --list-presets | grep '\"' | sed 's/  \"//g' | sed 's/\"//g'")  -- run your shell command
    local result = handle:read("*a")  -- read all output
    handle:close()

    local presets = {}
    local nb_presets = 1
    local preset = ""

    -- presets[nb_presets] = "Select one of these presets:\n"
    -- nb_presets = nb_presets + 1

    for i = 1, #result do
        local c = result:sub(i,i)

        if c == "\n" then
            presets[nb_presets] = preset
            nb_presets = nb_presets + 1
            preset = ""
            goto continue
        end
        preset = preset .. c

        ::continue::
    end

    return presets
end

function utils.select_preset()
    local presets = utils.get_presets()
    local numbered_presets = {}

    for i = 1, #presets do
        numbered_presets[i] = tostring(i) .. ": " .. presets[i] .. "\n"
    end
    print("Select one of these presets:\n\n" .. table.concat(numbered_presets) .. "\n")

    local got_proper_input = false
    local prompt_count = 0
    local selected_preset_index = 0

    while got_proper_input == false and prompt_count < 100 do
        local user_input = vim.fn.input("Enter input: ")
        for i = 1, #presets do
            if tostring(i) == user_input then
                selected_preset_index = i
                got_proper_input = true
                break
            end
        end

        print("Wrong input ...")
        prompt_count = prompt_count + 1
    end

    if selected_preset_index <= 0 or selected_preset_index > #presets then
        print("The selected preset does not exist: " .. tostring(selected_preset_index))
        return
    end

    print("Selecting preset: " .. presets[selected_preset_index])
    print("cmake --preset=" .. presets[selected_preset_index])

    local handle = io.popen("cmake --preset=" .. presets[selected_preset_index])
    local result = handle:read("*a")  -- read all output
    handle:close()

    print(result)
end

return utils
