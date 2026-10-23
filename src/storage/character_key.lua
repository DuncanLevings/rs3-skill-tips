-- PersistentDB is shared by every character played on this computer, so per character data
-- gets the character's name in its key. names are lowercased and anything that isnt a letter
-- or digit becomes _ (rs names can contain spaces, which come through as odd characters).
--
-- a name change means a fresh start for that character, which is fine for tip progress

local character_key = {}

function character_key.from_name(display_name)
    if type(display_name) ~= "string" or display_name == "" then
        return nil
    end

    -- filter before lowercasing: %w and lower() can treat utf-8 bytes as letters in
    -- the host's locale. Saved keys must only contain ASCII letters, digits and _.
    return (display_name:gsub("[^A-Za-z0-9]", "_"):lower())
end

-- nil until a character is logged in
function character_key.current()
    local ok, display_name = pcall(function()
        if not Player.IsAvailable() then
            return nil
        end

        return Player.GetEntity().displayName
    end)

    return ok and character_key.from_name(display_name) or nil
end

return character_key
