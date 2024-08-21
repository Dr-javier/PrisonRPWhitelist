local price = 500
local board = {}

Hook.Add("character.death","prisonerdeath",function(character)
    if character.JobIdentifier == "convict" then
        print(character.Name)
        if character.LastAttacker.JobIdentifier == "convict" then
            local killer = character.LastAttacker
            local killerID = killer.ID -- Use a unique identifier
            if not board[killerID] then
                board[killerID] = { RealName = killer.Name, ClientCharacter = Util.FindClientCharacter(killer), Count = 0 }
            end
            board[killerID].Count = board[killerID].Count + 1
            Traitormod.RoundEvents.SendEventMessage(character.LastAttacker.Name.." is to be excecuted for killing fellow prisoner's, the warden shall be the excecutioner.", nil, Color.Red)
        else
            print(character.LastAttacker.JobIdentifier)
		end
    end
end)

if CLIENT then return end -- stops this from running on the client


local discordWebHook = "https://discord.com/api/webhooks/1271640835334738044/e_09fWKRKACmN7gcU-C0JkqJdCl7PAKBWop6JII4rQoQJPWNW6CJUvJ5TsIOkYKsJf80"

local function escapeQuotes(str)
    return str:gsub("\"", "\\\"")
end
local msg
local escapedName
for _, info in pairs(board) do
    print(info.RealName)
    print(info.ClientCharacter)
    print(info.Count)
    escapedName = escapeQuotes(info.RealName)
    msg = info.RealName .. "has killed " .. info.Count .. " Prisoners"
end
local escapedMessage = escapeQuotes(msg)

Networking.RequestPostHTTP(discordWebHook, function(result) end, '{\"content\": \"'..escapedMessage..'\", \"username\": \"'..escapedName..'\"}')
