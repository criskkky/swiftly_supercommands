commands:Register("hp", function(playerid, args, argsCount, silent, prefix)
    local admin = nil
    
    if playerid == -1 then
        -- Set admin name to CONSOLE if executed by the server console
        admin = "CONSOLE"
    else
        -- Set admin name to the player name if executed by a player
        local player = GetPlayer(playerid)
        if not player then return end

        local hasAccess = exports["admins"]:HasFlags(playerid, "c")
    
        -- Permission Check
        if not hasAccess then
            return ReplyToCommand(playerid, config:Fetch("admins.prefix"), string.format(FetchTranslation("admins.no_permission"), prefix))
        end

        if player:IsValid() then
            admin = player:CBasePlayerController().PlayerName
        end
    end
    
    if argsCount < 2 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"), string.format(FetchTranslation("supercommands.hp.usage"), prefix))
    end

    local players = FindPlayersByTarget(args[1], true)
    if #players == 0 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.invalid_player"))
    end

    local health = tonumber(args[2])
    if not health then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("supercommands.hp.invalid_health"))
    end

    local armor = nil
    if argsCount >= 3 then
        armor = tonumber(args[3])
        if not armor then
            return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("supercommands.hp.invalid_armor"))
        end
    end

    local helmet = nil
    if argsCount >= 4 then
        helmet = tonumber(args[4])
        if not helmet then
            return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("supercommands.hp.invalid_helmet"))
        end
    end

    for i = 1, #players do
        local pl = players[i]
        pl:CBaseEntity().Health = health
        if helmet == 1 then
            NextTick(function()
                pl:GetWeaponManager():GiveWeapon("item_assaultsuit")
            end)
        elseif helmet == 0 then
            NextTick(function()
                pl:CCSPlayerPawn().ArmorValue = 0
            end)
        end
        pl:CCSPlayerPawn().ArmorValue = armor or pl:CCSPlayerPawn().ArmorValue

        if pl:CBaseEntity().Health <= 0 then
            pl:Kill()
        end
    end

    -- Message handling for multiple players
    local message = nil
    if #players > 1 then
        if argsCount == 2 then
            message = FetchTranslation("supercommands.hp.mult_message")
                :gsub("{ADMIN_NAME}", admin)
                :gsub("{PLAYER_COUNT}", tostring(#players))
                :gsub("{HEALTH}", tostring(health))
        elseif argsCount == 3 then
            message = FetchTranslation("supercommands.hp.mult_message_with_armor")
                :gsub("{ADMIN_NAME}", admin)
                :gsub("{PLAYER_COUNT}", tostring(#players))
                :gsub("{HEALTH}", tostring(health))
                :gsub("{ARMOR}", tostring(armor))
        elseif argsCount == 4 then
            message = FetchTranslation("supercommands.hp.mult_message_with_helmet")
                :gsub("{ADMIN_NAME}", admin)
                :gsub("{PLAYER_COUNT}", tostring(#players))
                :gsub("{HEALTH}", tostring(health))
                :gsub("{ARMOR}", tostring(armor))
                :gsub("{HELMET}", tostring(helmet))
        end
        ReplyToCommand(playerid, config:Fetch("admins.prefix"), message)
    else
        -- Message handling for single player
        local pl = players[1]
        if argsCount == 2 then
            message = FetchTranslation("supercommands.hp.message")
                :gsub("{ADMIN_NAME}", admin)
                :gsub("{PLAYER_NAME}", pl:CBasePlayerController().PlayerName)
                :gsub("{HEALTH}", tostring(health))
        elseif argsCount == 3 then
            message = FetchTranslation("supercommands.hp.message_with_armor")
                :gsub("{ADMIN_NAME}", admin)
                :gsub("{PLAYER_NAME}", pl:CBasePlayerController().PlayerName)
                :gsub("{HEALTH}", tostring(health))
                :gsub("{ARMOR}", tostring(armor))
        elseif argsCount == 4 then
            message = FetchTranslation("supercommands.hp.message_with_helmet")
                :gsub("{ADMIN_NAME}", admin)
                :gsub("{PLAYER_NAME}", pl:CBasePlayerController().PlayerName)
                :gsub("{HEALTH}", tostring(health))
                :gsub("{ARMOR}", tostring(armor))
                :gsub("{HELMET}", tostring(helmet))
        end
        ReplyToCommand(playerid, config:Fetch("admins.prefix"), message)
    end
end)
