-------------------
--- BadgerTools ---
-------------------
function spectatePlayer(targetPed)
	local playerPed = PlayerPedId() -- yourself
	enable = true
	if targetPed == playerPed then enable = false end

	if(enable)then

			local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))

			--RequestCollisionAtCoord(targetx,targety,targetz)
			NetworkSetInSpectatorMode(true, targetPed)

			--DrawPlayerInfo(target)
			--ShowNotification("Spectating")
	else

			local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))

			--RequestCollisionAtCoord(targetx,targety,targetz)
			NetworkSetInSpectatorMode(false, targetPed)

			--StopDrawPlayerInfo()
			--ShowNotification("No longer spectating")
	end
end
function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end
function get_index (tab, val)
	local counter = 1
    for index, value in ipairs(tab) do
        if value == val then
            return counter
        end
		counter = counter + 1
    end

    return nil
end
function GetPlayers()
    local players = {}

    for _, i in ipairs(GetActivePlayers()) do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end
function GetPlayersButSkipMyself()
    local players = {}

    for _, i in ipairs(GetActivePlayers()) do
        if NetworkIsPlayerActive(i) then
			if GetPlayerName(i) ~= GetPlayerName(PlayerId()) then
				table.insert(players, i)
			end
		end
    end

    return players
end

function GetPlayersCountButSkipMe()
    local count = 0
    for _, i in ipairs(GetActivePlayers()) do
        if NetworkIsPlayerActive(i) then
			if GetPlayerPed(i) ~= GetPlayerPed(-1) then
				count = count + 1
			end
		end
    end
    return count
end
tags = {}
RegisterNetEvent('BadgerTools:GiveTag')
AddEventHandler('BadgerTools:GiveTag', function(givenTag)
	tags = givenTag
end)
isSpecatingBool = false
arguments = nil
playerIsSpectatingPlayer = nil
RegisterCommand("spectate", function(source, args, rawCommand)
	arguments = args[1]
	TriggerServerEvent('Permissions:HasPermission')
end)
savedCoords = nil
RegisterNetEvent('Permissions:Granted')
AddEventHandler('Permissions:Granted', function()
	if (arguments == nil) or (arguments == "") then 
		local players = GetPlayersButSkipMyself()
		if not isSpecatingBool then
			-- They do want to specate someone
			local specPlayer = nil
			specPlayer = players[1]
			playerIsSpectatingPlayer = 1
			-- Spectate this player
			if specPlayer ~= nil then
				savedCoords = GetEntityCoords(PlayerPedId()) -- Save their coords
				spectatePlayer(GetPlayerPed(specPlayer))
				TriggerServerEvent('BadgerTools:UserTag', false)
				SetEntityInvincible(GetPlayerPed(-1), true)
				SetPlayerInvincible(GetPlayerPed(-1), true)
				SetEntityVisible(GetPlayerPed(-1), false, 0)
				isSpecatingBool = true
				ShowNotification("~b~Spectating ~f~" .. GetPlayerName(specPlayer))
				TriggerServerEvent('Print:PrintClientMessage', "^5Spectating ^7" .. GetPlayerName(specPlayer))
			else
				-- NO ONE TO Spectate
				ShowNotification("~r~Error: Nobody is available to be spectated...")
			end
		else
			-- They don't want to spectate anymore
			isSpecatingBool = false
			SetEntityNoCollisionEntity(GetPlayerPed(-1), GetPlayerPed(players[playerIsSpectatingPlayer]), false)
			playerIsSpectatingPlayer = nil
			spectatePlayer(GetPlayerPed(-1))
			ShowNotification("~g~Success: No longer spectating anyone!")
			SetEntityVisible(GetPlayerPed(-1), true, 0) -- Set not invisible
			TriggerServerEvent('BadgerTools:UserTag', true)
			SetEntityInvincible(GetPlayerPed(-1), false)
			SetPlayerInvincible(GetPlayerPed(-1), false)
			DetachEntity(GetPlayerPed(-1), false, false)
			SetEntityCoords(GetPlayerPed(-1), savedCoords.x, savedCoords.y, savedCoords.z) -- Teleport them
			alreadyAttached = false
		end
	else 
		-- Has an argument, we need to spectate the ID specified
		if not isSpecatingBool then
			local players = GetPlayersButSkipMyself()
			for i = 1, #players do
				local playerID = players[i]
				local specPlayer = players[i]
				--TriggerServerEvent('Print:PrintDebug', "Checking arguments " .. arguments .. " to playerServerId " .. tostring(GetPlayerServerId(playerID)))
				if (tonumber(arguments) == GetPlayerServerId(playerID)) then
					-- Spectate this player
					playerIsSpectatingPlayer = i
					savedCoords = GetEntityCoords(PlayerPedId()) -- Save their coords
					spectatePlayer(GetPlayerPed(specPlayer))
					TriggerServerEvent('BadgerTools:UserTag', false)
					SetEntityInvincible(GetPlayerPed(-1), true)
					SetPlayerInvincible(GetPlayerPed(-1), true)
					SetEntityVisible(GetPlayerPed(-1), false, 0)
					isSpecatingBool = true
					ShowNotification("~b~Spectating ~f~" .. GetPlayerName(specPlayer))
					TriggerServerEvent('Print:PrintClientMessage', "^5Spectating ^7" .. GetPlayerName(specPlayer))
				end
			end
		end
	end
	arguments = nil
end)
-- START CONTROLS
alreadyAttached = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		-- LEFT ARROW = 174 RIGHT ARROW = 175
		local players = GetPlayersButSkipMyself()
		if isSpecatingBool then
			-- They are spectating, check control input
			if IsControlJustReleased(0, 174) then
				-- Go backwards
				if not isInVoice then
					SetEntityNoCollisionEntity(GetPlayerPed(-1), GetPlayerPed(players[playerIsSpectatingPlayer]), false)
					SendVoiceToPlayer(players[playerIsSpectatingPlayer], false)
					local newSpectatePlayer = playerIsSpectatingPlayer - 1
					if (players[newSpectatePlayer] == nil) then
						-- Can't go backwards any more
						newSpectatePlayer = #players
					end
					playerIsSpectatingPlayer = newSpectatePlayer
					spectatePlayer(GetPlayerPed(players[newSpectatePlayer]))
					ShowNotification("~b~Spectating ~f~" .. GetPlayerName(players[newSpectatePlayer]))
					TriggerServerEvent('Print:PrintClientMessage', "^5Spectating ^7" .. GetPlayerName(players[newSpectatePlayer]))
					-- TSTING:
					alreadyAttached = false
					alreadyAttachedVeh = false
				else
					-- Can't change cause they are speaking to player
					ShowNotification("~r~Error: You are currently speaking to player ~b~" .. GetPlayerName(players[newSpectatePlayer]))
					TriggerServerEvent('Print:PrintClientMessage', "^1Error: You are currently speaking to player ^5" .. GetPlayerName(players[newSpectatePlayer]))
				end
			elseif IsControlJustReleased(0, 175) then
				-- Go forwards
				if not isInVoice then
					SetEntityNoCollisionEntity(GetPlayerPed(-1), GetPlayerPed(players[playerIsSpectatingPlayer]), false)
					SendVoiceToPlayer(players[playerIsSpectatingPlayer], false)
					local newSpectatePlayer = playerIsSpectatingPlayer + 1
					if (players[newSpectatePlayer]  == nil) then
						-- Can't go forwards any more
						newSpectatePlayer = 1
					end
					playerIsSpectatingPlayer = newSpectatePlayer
					spectatePlayer(GetPlayerPed(players[newSpectatePlayer]))
					ShowNotification("~b~Spectating ~f~" .. GetPlayerName(players[newSpectatePlayer]))
					TriggerServerEvent('Print:PrintClientMessage', "^5Spectating ^7" .. GetPlayerName(players[newSpectatePlayer]))
					-- TESTING:
					alreadyAttached = false
					alreadyAttachedVeh = false
				else
					-- Can't change cause they are speaking to player
					ShowNotification("~r~Error: You are currently speaking to player ~b~" .. GetPlayerName(players[newSpectatePlayer]))
					TriggerServerEvent('Print:PrintClientMessage', "^1Error: You are currently speaking to player ^5" .. GetPlayerName(players[newSpectatePlayer]))
				end
			end
		end
	end
end)
-- END CONTROLS
----[[
alreadyGivenVoice = false
AddEventHandler('playerSpawned', function()
	-- Give voice if not given alreadyGivenVoice
	if not alreadyGivenVoice then
		alreadyGivenVoice = true
		NetworkSetTalkerProximity(10.0) -- 10 Meters
		NetworkSetVoiceChannel(0)
		--NetworkSetVoiceActive(true)
	end
end)

function displayText(text, justification, red, green, blue, alpha, posx, posy)
    SetTextFont(4)
    SetTextWrap(0.0, 1.0)
    SetTextScale(1.0, 0.5)
    SetTextJustification(justification)
    SetTextColour(red, green, blue, alpha)
    SetTextOutline()

    BeginTextCommandDisplayText("STRING") -- old: SetTextEntry()
    AddTextComponentSubstringPlayerName(text) -- old: AddTextComponentString
    EndTextCommandDisplayText(posx, posy) -- old: DrawText()
end

function DrawText2(text, x, y)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextScale(0.0, 0.45)
		SetTextJustification(1) -- Center Text
		SetTextCentre(true)
        SetTextDropshadow(1, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(x, y)
end
	
function SendVoiceToPlayer(intPlayer, boolSend)
	Citizen.InvokeNative(0x97DD4C5944CC2E6A, intPlayer, boolSend)
end

isInVoice = false
isBeingSpectated = false
colorPerms = {}
redPerms = {}
setUp = false
AddEventHandler('playerSpawned', function()
	local src = source
	TriggerServerEvent('BadgerTools:SetTag', src)
	TriggerServerEvent('BadgerTools:SetColorPermissions', src)
	TriggerServerEvent('BadgerTools:SetRedPermissions', src)
end)

RegisterNetEvent('Permissions:GetColorPermissions:Return')
AddEventHandler('Permissions:GetColorPermissions:Return', function(colorPermArr)
	colorPerms = colorPermArr
end)
RegisterNetEvent('Permissions:GetRedPermissions:Return')
AddEventHandler('Permissions:GetRedPermissions:Return', function(colorPermArr)
	redPerms = colorPermArr
end)
alreadyAttachedVeh = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if isSpecatingBool then
			-- Check if their player is still active:
			--[[
			if not NetworkIsPlayerActive(playerIsSpectatingPlayer) then
				-- They are not online anymore
				local players = GetPlayersButSkipMyself()
				for i = 1, #players do
					playerIsSpectatingPlayer = players[i]
				end
			end
			--]]--
			local playersList = GetPlayersButSkipMyself()
			local specID = playersList[playerIsSpectatingPlayer]
			local pedSpectated = GetPlayerPed(playersList[playerIsSpectatingPlayer])
			local spectatedCoords = GetEntityCoords(GetPlayerPed(playersList[playerIsSpectatingPlayer]))
			local spectatedVeh = GetVehiclePedIsUsing(pedSpectated)
			SendVoiceToPlayer(specID, true)
			SetEntityInvincible(GetPlayerPed(-1), true)
			SetPlayerInvincible(GetPlayerPed(-1), true)
			SetEntityVisible(GetPlayerPed(-1), false, 0)
			----[[
			if not alreadyAttached then
				DetachEntity(GetPlayerPed(-1), false, false)
				AttachEntityToEntity(GetPlayerPed(-1), pedSpectated, 0, 0, 0, spectatedCoords.z - 10, 0, 0, 0, false, false, true, 0, false)
				alreadyAttached = true
				alreadyAttachedVeh = false
			end
			--]]--
			--TriggerServerEvent('Print:PrintConsole', "Player " .. GetPlayerName(PlayerId()) .. " is spectating player " .. GetPlayerName(i))
			if spectatedVeh ~= nil and spectatedVeh ~= 0 then
				if AreAnyVehicleSeatsFree(spectatedVeh) then
					--TaskWarpPedIntoVehicle(GetPlayerPed(-1), spectatedVeh, -2)
					--SetEntityCoords(GetPlayerPed(-1), spectatedCoords.x, spectatedCoords.y, spectatedCoords.z + 10)
					--SetEntityNoCollisionEntity(GetPlayerPed(-1), pedSpectated, true)
					----[[
					if not alreadyAttachedVeh then
						DetachEntity(GetPlayerPed(-1), false, false)
						AttachEntityToEntity(GetPlayerPed(-1), spectatedVeh, 0, 0, 0, spectatedCoords.z - 10, 0, 0, 0, false, false, false, 0, false)
						alreadyAttached = false
						alreadyAttachedVeh = true
					end
					--]]--
				else
					--SetEntityCoords(GetPlayerPed(-1), spectatedCoords.x, spectatedCoords.y, spectatedCoords.z + 10)
					SetEntityNoCollisionEntity(GetPlayerPed(-1), pedSpectated, true)
					----[[
					if not alreadyAttachedVeh then
						DetachEntity(GetPlayerPed(-1), false, false)
						AttachEntityToEntity(GetPlayerPed(-1), spectatedVeh, 0, 0, 0, spectatedCoords.z - 10, 0, 0, 0, false, false, false, 0, false)
						alreadyAttached = false
						alreadyAttachedVeh = true
					end
					--SetEntityCoordsNoOffset(PlayerPedId(), spectatedCoords.x, spectatedCoords.y, spectatedCoords.z, 0, 0, 0)
					--]]--
				end
			else
				SetEntityNoCollisionEntity(GetPlayerPed(-1), pedSpectated, true)
				--SetEntityCoords(GetPlayerPed(-1), spectatedCoords.x, spectatedCoords.y, spectatedCoords.z + 10)
				--SetEntityCoordsNoOffset(PlayerPedId(), spectatedCoords.x, spectatedCoords.y, spectatedCoords.z, 0, 0, 0)
				----[[
				if not alreadyAttached then
					DetachEntity(GetPlayerPed(-1), false, false)
					AttachEntityToEntity(GetPlayerPed(-1), pedSpectated, 0, 0, 0, spectatedCoords.z - 10, 0, 0, 0, false, false, true, 0, false)
					alreadyAttached = true
					alreadyAttachedVeh = false
				end
				--]]--
			end
			if GetPlayersCountButSkipMe() == 0 then
				-- End spectate, nobody to spectate
				SendVoiceToPlayer(specID, true)
				SetEntityCoords(GetPlayerPed(-1), savedCoords.x, savedCoords.y, savedCoords.z) -- Teleport them
				SetEntityNoCollisionEntity(GetPlayerPed(-1), pedSpectated, false)
				playerIsSpectatingPlayer = nil
				spectatePlayer(GetPlayerPed(-1))
				isSpecatingBool = false
				SetEntityVisible(GetPlayerPed(-1), true, 0) -- Set not invisible
				TriggerServerEvent('BadgerTools:UserTag', true)
				SetEntityInvincible(GetPlayerPed(-1), false)
				ShowNotification("~r~Error: Nobody left to spectate")
			end
		else 
			-- Send voice to no one
			for i=0,31 do
				if (NetworkIsPlayerActive(i)) then
					SendVoiceToPlayer(i, false)
				end
			end
		end
		-- Normal voice chat if not inVoice and not being spectated
		NetworkSetVoiceChannel(0)
		NetworkSetTalkerProximity(15.01)
		NetworkClearVoiceChannel()
		NetworkSetVoiceActive(true)
		local playersTalking = {'empty'}
		local counter = 1
		for _, i in ipairs(GetActivePlayers()) do
			if NetworkIsPlayerTalking(i) then
				local playerCoords2 = GetEntityCoords(GetPlayerPed(i))
				local playerCoords = GetEntityCoords(GetPlayerPed(-1))
				if(GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, playerCoords2.x, playerCoords2.y, playerCoords2.z, true) < 16.0) then
					playersTalking[counter] = GetPlayerName(i)
					counter = counter + 1
					--SendVoiceToPlayer(i, true)
				else
					--SendVoiceToPlayer(i, false)
				end
			end
		end
		counter = 0
		if playersTalking[1] ~= "empty" then
			for k,v in pairs(playersTalking) do
				-- TODO Take color out of their name if they are not donator and red out if not staff
				local playerName = v
				local pid = k
				TriggerServerEvent('Permissions:GetColorPermissions')
				TriggerServerEvent('Permissions:GetRedPermissions')
				local colors = {"~b~", "~g~", "~y~", "~p~", "~c~", "~m~", "~u~", "~o~", "~w~",}
				local red = "~r~"
				local name = playerName
				if not has_value(colorPerms, playerName) then
					-- Get rid of colors out of their name
					for i = 1, #colors do
						name = name:gsub(colors[i], "")
					end
				end
				if not has_value(redPerms, playerName) then
					-- Get rid of colors out of their name
					name = name:gsub(red, "")
				end
				TriggerServerEvent('BadgerTools:GetTag')
				tag = ""
				for i = 1, #tags do
					if tags[i][1] == playerName then
						tag = tags[i][2]
					end
				end
				DrawText2("~f~" .. tag .. name, .50, 0.030 + (0.025*(counter)))
				counter = counter + 1
			end
		end
	end
end)

RegisterNetEvent('Permissions:GrantColors')
AddEventHandler('Permissions:GrantColors', function(bool)
	colorPerms = bool
end)

RegisterNetEvent('Permissions:GrantRed')
AddEventHandler('Permissions:GrantRed', function(bool)
	redPerms = bool
end)
--]]--

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(0,1)
end