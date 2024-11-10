commands:Register("hp", function(playerid, args, argsCount, silent, prefix)
    -- Server Logic
    if playerid == -1 then
        if argsCount < 2 then
            return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("supercommands.hp.usage"))
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
            pl:CBaseEntity().Armor = armor or pl:CBaseEntity().Armor
            pl:CBaseEntity().Helmet = helmet or pl:CBaseEntity().Helmet

            if pl:CBaseEntity().Health <= 0 then
                pl:Kill()
            end
        end

        -- Enviar mensaje único para múltiples jugadores
        local message = nil
        if #players > 1 then
            if argsCount == 2 then
                -- Solo se aplica la salud
                message = FetchTranslation("supercommands.hp.mult_message")
                    :gsub("{ADMIN_NAME}", "CONSOLE")
                    :gsub("{PLAYER_COUNT}", tostring(#players))
                    :gsub("{HEALTH}", tostring(health))
                elseif argsCount == 3 then
                    -- Salud y armadura
                    message = FetchTranslation("supercommands.hp.mult_message_with_armor")
                    :gsub("{ADMIN_NAME}", "CONSOLE")
                    :gsub("{PLAYER_COUNT}", tostring(#players))
                    :gsub("{HEALTH}", tostring(health))
                    :gsub("{ARMOR}", tostring(armor))
                elseif argsCount == 4 then
                    -- Salud, armadura y casco
                    message = FetchTranslation("supercommands.hp.mult_message_with_helmet")
                    :gsub("{ADMIN_NAME}", "CONSOLE")
                    :gsub("{PLAYER_COUNT}", tostring(#players))
                    :gsub("{HEALTH}", tostring(health))
                    :gsub("{ARMOR}", tostring(armor))
                    :gsub("{HELMET}", tostring(helmet))
            end
            ReplyToCommand(playerid, config:Fetch("admins.prefix"), message)
        else
            -- Enviar mensaje individual para un solo jugador
            local pl = players[1]
            if argsCount == 2 then
                message = FetchTranslation("supercommands.hp.message")
                    :gsub("{ADMIN_NAME}", "CONSOLE")
                    :gsub("{PLAYER_NAME}", pl:CBasePlayerController().PlayerName)
                    :gsub("{HEALTH}", tostring(health))
            elseif argsCount == 3 then
                message = FetchTranslation("supercommands.hp.message_with_armor")
                    :gsub("{ADMIN_NAME}", "CONSOLE")
                    :gsub("{PLAYER_NAME}", pl:CBasePlayerController().PlayerName)
                    :gsub("{HEALTH}", tostring(health))
                    :gsub("{ARMOR}", tostring(armor))
            elseif argsCount == 4 then
                message = FetchTranslation("supercommands.hp.message_with_helmet")
                    :gsub("{ADMIN_NAME}", "CONSOLE")
                    :gsub("{PLAYER_NAME}", pl:CBasePlayerController().PlayerName)
                    :gsub("{HEALTH}", tostring(health))
                    :gsub("{ARMOR}", tostring(armor))
                    :gsub("{HELMET}", tostring(helmet))
            end
            ReplyToCommand(playerid, config:Fetch("admins.prefix"), message)
        end
    else
        -- Player Logic (to be implemented)
        local player = GetPlayer(playerid)
        if not player then return end

        -- Permission Check
        if not hasAccess then
            return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.no_permission"))
        end
    end
end)
