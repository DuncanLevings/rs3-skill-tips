-- small PersistentDB wrapper the storage modules share. saved tables carry a version number,
-- anything missing, the wrong type or from another version loads as nil so the caller can
-- start fresh (or recover what it can)

local saved_table = {}

function saved_table.load(key, version)
    local ok, saved = pcall(function()
        return PersistentDB:GetStructuredData(key)
    end)

    if not ok or type(saved) ~= "table" or saved.version ~= version then
        return nil
    end

    return saved
end

-- a failed save keeps the change for this session, it just wont be there next time
function saved_table.save(key, data)
    local ok, saved = pcall(function()
        return PersistentDB:SetStructuredData(key, data)
    end)

    if not ok or not saved then
        log("Skill Tips: couldn't save " .. key .. " for next session")
        return false
    end

    return true
end

return saved_table
