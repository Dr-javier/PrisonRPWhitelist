local config = {}
config.DebugLogs = true

----- USER FEEDBACK -----
config.Language = "English"
config.SendWelcomeMessage = true
config.ChatMessageType = ChatMessageType.Private    -- Error = red | Private = green | Dead = blue | Radio = yellow

----- GAMEPLAY -----
config.Codewords = {
    "hull", "tabacco", "separatist", "fish", "clown", "quartermaster", "fast", "possibility",
	"thalamus", "hungry", "water", "looks", "renegade", "angry", "green", "sink", "rubber",
	"mask", "sweet", "ice", "charybdis", "cult", "secret", "frequency",
	"husk", "rust", "ruins", "red", "boat", "cats", "rats", "blast",
	"tire", "trunk", "weapons", "threshers", "convict", "method", "monkey"
}

config.AmountCodeWords = 2

config.OptionalTraitors = true        -- players can use !toggletraitor
config.RagdollOnDisconnect = false
config.EnableControlHusk = false     -- EXPERIMENTAL: enable to control husked character after death
config.DeathLogBook = true

-- This overrides the game's respawn shuttle, and uses it as a submarine injector, to spawn submarines in game easily. Respawn should still work as expected, but the shuttle submarine file needs to be manually added here.
-- Note: If this is disabled, traitormod will disable all functions related to submarine spawning.
-- Warning: Only respawn shuttles will be used, the option to spawn people directly into the submarine doesnt work.
config.OverrideRespawnSubmarine = true
config.RespawnSubmarineFile = "Content/Submarines/Selkie.sub"
config.RespawnText = "Respawn in %s seconds."
config.RespawnTeam = CharacterTeamType.Team1
config.RespawnOnKillPoints = 0

----- POINTS + LIVES -----
config.PermanentPoints = true      -- sets if points and lives will be stored in and loaded from a file
config.RemotePoints = nil
config.RemoteServerAuth = {}
config.PermanentStatistics = true  -- sets if statistics be stored in and loaded from a file
config.MaxLives = 10
config.MinRoundTimeToLooseLives = 300
config.RespawnedPlayersDontLooseLives = true
config.MaxExperienceFromPoints = 100000     -- if not nil, this amount is the maximum experience players gain from stored points (30k = lvl 10 | 38400 = lvl 12)
config.RemoveSkillBooks = true
config.NerfSwords = false

config.FreeExperience = 950         -- temporary experience given every ExperienceTimer seconds
config.ExperienceTimer = 120
config.StartPoints = 250

config.PointsGainedFromSkill = {
    medical = 30,
    weapons = 20,
    mechanical = 19,
    electrical = 19,
    helm = 9,
}

config.PointsLostAfterNoLives = function (x)
    return x * 0.75
end

config.AmountExperienceWithPoints = function (x)
    return x
end

----- GAMEMODE -----
config.GamemodeConfig = {
    Secret = {
        EndOnComplete = true,           -- end round everyone but traitors are dead
        EnableRandomEvents = true,
        EndGameDelaySeconds = 15,

        TraitorSelectDelayMin = 120,
        TraitorSelectDelayMax = 150,

        PointsGainedFromHandcuffedTraitors = 1000,
        DistanceToEndOutpostRequired = 8000,

        MissionPoints = {
            Salvage = 1100,
            Monster = 1050,
            Cargo = 1000,
            Beacon = 1200,
            Nest = 1700,
            Mineral = 1000,
            Combat = 1400,
            AbandonedOutpost = 500,
            Escort = 1200,
            Pirate = 1300,
            GoTo = 1000,
            ScanAlienRuins = 1600,
            ClearAlienRuins = 2000,
            Default = 1000,
        },
        PointsGainedFromCrewMissionsCompleted = 1000,
        LivesGainedFromCrewMissionsCompleted = 1,

        TraitorTypeChance = {
            Traitor = 90, -- Traitors have 90% chance of being a normal traitor
            Cultist = 10,
        },

        AmountTraitors = function (amountPlayers)
            config.TestMode = false
            if amountPlayers > 12 then return 3 end
            if amountPlayers > 7 then return 2 end            
            if amountPlayers > 3 then return 1 end
            if amountPlayers == 1 then 
                Traitormod.SendMessageEveryone("1P testing mode - no points can be gained or lost") 
                config.TestMode = true
                return 1
            end
            print("Not enough players to start traitor mode.")
            return 0
        end,

        -- 0 = 0% chance
        -- 1 = 100% chance
        TraitorFilter = function (client)
            if client.Character.TeamID ~= CharacterTeamType.Team1 then return 0 end
            if not client.Character.IsHuman then return 0 end
            if client.Character.HasJob("warden") then return 0 end
            if client.Character.HasJob("headguard") then return 0 end
            if client.Character.HasJob("convict") then return 0 end
            if client.Character.HasJob("guard") then return 0.004 end
            if client.Character.HasJob("prisondoctor") then return 0.4 end
            if client.Character.HasJob("he-chef") then return 0.5 end

            return 1
        end
    },

    PvP = {
        EnableRandomEvents = false, -- most events are coded to only affect the main submarine
        WinningPoints = 1000,
        WinningDeadPoints = 500,
        MinimumPlayersForPoints = 4,
        ShowSonar = true,
        IdCardAllAccess = true,
        CrossTeamCommunication = true,
    },
}

config.RoleConfig = {
    Crew = {
        AvailableObjectives = {
            ["captain"] = {},
            ["engineer"] = {},
            ["mechanic"] = {"Repair"},
            ["janitor"] = {"Repair"},
            ["staff"] = {"Repair"},
            ["securityofficer"] = {"KillMonsters"},
            ["warden"] = {"KillMonsters"},
            ["guard"] = {"KillMonsters"},
            ["headguard"] = {"KillMonsters"},
            ["medic"] = {},
            ["prisondoctor"] = {},
            ["convict"] = {"Escape"},
        }
    },

    Cultist = {
        SubObjectives = {"Assassinate", "Kidnap", "TurnHusk", "DestroyCaly"},
        MinSubObjectives = 2,
        MaxSubObjectives = 3,

        NextObjectiveDelayMin = 30,
        NextObjectiveDelayMax = 60,

        TraitorBroadcast = true,           -- traitors can broadcast to other traitors using !tc
        TraitorBroadcastHearable = false,  -- if true, !tc will be hearable in the vicinity via local chat
        TraitorDm = true,                  -- traitors can send direct messages to other players using !tdm

        -- Names, None
        TraitorMethodCommunication = "Names",

        SelectBotsAsTargets = true,
        SelectPiratesAsTargets = false,
    },

    HuskServant = {
        TraitorBroadcast = true,
    },

    Pirate = {
        TraitorBroadcast = true,
    },

    Traitor = {
        SubObjectives = {"StealCaptainID", "Survive", "Kidnap", "PoisonCaptain", "SavePrisoner"},
        MinSubObjectives = 2,
        MaxSubObjectives = 3,

        NextObjectiveDelayMin = 30,
        NextObjectiveDelayMax = 60,

        TraitorBroadcast = true,           -- traitors can broadcast to other traitors using !tc
        TraitorBroadcastHearable = false,  -- if true, !tc will be hearable in the vicinity via local chat
        TraitorDm = true,                  -- traitors can send direct messages to other players using !tdm

        -- Names, Codewords, None
        TraitorMethodCommunication = "Names",

        SelectBotsAsTargets = true,
        SelectPiratesAsTargets = false,
        SelectUniqueTargets = true,     -- every traitor target can only be chosen once per traitor (respawn+false -> no end)
        PointsPerAssassination = 100,
    },
}

config.ObjectiveConfig = {
    Assassinate = {
        AmountPoints = 600,
    },

    SavePrisoner = {
        AmountPoints = 2100,
    },

    OnAcid = {
        AmountPoints = 500,
    },

    Survive = {
        AlwaysActive = true,
        AmountPoints = 500,
        AmountLives = 1,
    },

    StealCaptainID = {
        AmountPoints = 1300,
    },

    Kidnap = {
        AmountPoints = 2500,
        Seconds = 100,
    },

    PoisonCaptain = {
        AmountPoints = 1600,
    },

    Husk = {
        AmountPoints = 750,
    },

    TurnHusk = {
        AmountPoints = 500,
        AmountLives = 1,
    },

    DestroyCaly = {
        AmountPoints = 500,
    },
}

----- EVENTS -----
config.RandomEventConfig = {
    Events = {
        dofile(Traitormod.Path .. "/Lua/config/randomevents/communicationsoffline.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/superballastflora.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/maintenancetoolsdelivery.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/medicaldelivery.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/ammodelivery.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/electricalfixdischarge.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/wreckpirate.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/beaconpirate.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/lightsoff.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/emergencyteam.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/shadymission.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/oxygengenpoison.lua"),
    }
}

config.PointShopConfig = {
    Enabled = true,
    DeathTimeoutTime = 120,
    ItemCategories = {
        dofile(Traitormod.Path .. "/Lua/config/pointshop/cultist.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/traitor.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/security.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/maintenance.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/experimental.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/deathspawn.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/ships.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/prisoner.lua"),
    }
}

config.GhostRoleConfig = {
    Enabled = true,
    MiscGhostRoles = {
        ["Mudraptor_pet"] = true,
        ["Orangeboy"] = true,
        ["Peanut"] = true,
        ["Huskcontainer"] = true,
        ["Psilotoad"] = true,
        ["Humanzombiestaggerer"] = true,
    }
}

return config
