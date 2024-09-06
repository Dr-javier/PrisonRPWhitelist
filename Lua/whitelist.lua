local whitelistFilePath = Traitormod.Path .. "/Lua/whitelist.json"

local function loadWhitelist()
    local file = io.open(whitelistFilePath, "r")
    if file then
        local content = file:read("*a")
        file:close()
        return json.decode(content) or { whitelisted = {} }
    else
        return { whitelisted = {} }
    end
end

local function saveWhitelist(whitelist)
    local file = io.open(whitelistFilePath, "w")
    if file then
        file:write(json.encode(whitelist))
        file:close()
    end
end

Traitormod.Whitelist = loadWhitelist()

Traitormod.AddCommand("!addwhitelist", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then
        Traitormod.SendMessage(client, "You do not have permission to use this command.")
        return true
    end

    local steamID = args[1]
    if not steamID then
        Traitormod.SendMessage(client, "Please provide a SteamID.")
        return true
    end

    table.insert(Traitormod.Whitelist.whitelisted, steamID)
    saveWhitelist(Traitormod.Whitelist)
    Traitormod.SendMessage(client, "Added SteamID " .. steamID .. " to the whitelist.")
    return true
end)

Traitormod.AddCommand("!removewhitelist", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then
        Traitormod.SendMessage(client, "You do not have permission to use this command.")
        return true
    end

    local steamID = args[1]
    if not steamID then
        Traitormod.SendMessage(client, "Please provide a SteamID.")
        return true
    end

    for i, id in ipairs(Traitormod.Whitelist.whitelisted) do
        if id == steamID then
            table.remove(Traitormod.Whitelist.whitelisted, i)
            saveWhitelist(Traitormod.Whitelist)
            Traitormod.SendMessage(client, "Removed SteamID " .. steamID .. " from the whitelist.")
            return true
        end
    end

    Traitormod.SendMessage(client, "SteamID " .. steamID .. " is not in the whitelist.")
    return true
end)

Hook.Add("client.connected", "Traitormod.ClientConnected", function (client)
    local steamID = client.steamID
    local isWhitelisted = false

    for _, id in ipairs(Traitormod.Whitelist.whitelisted) do
        if id == steamID then
            isWhitelisted = true
            break
        end
    end

    if not isWhitelisted then
        client.Kick("Client (" .. steamID .. ") not added to whitelist, you can ask for whitelist permission here: https://discord.gg/seVjb94rv4")
    end
end)