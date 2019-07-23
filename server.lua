-------------------
--- BadgerTools ---
-------------------

--- Config ---
roleList = {
{0, ""}, -- 1
{577661583497363456, "~g~Donator | "}, -- 3
{577631197987995678, "~r~T-Mod | "}, -- 4
{506211787214159872, "~r~Mod | "}, -- 5
{506212543749029900, "~r~Admin | "}, -- 6
{577966729981067305, "~p~Management | "}, -- 7
{506212786481922058, "~o~Owner | "}, -- 8
}

--- Code ---
tags = {}
RegisterNetEvent('BadgerTools:SetTag')
AddEventHandler('BadgerTools:SetTag', function(_source)
	-- Check their tag
	local src = source
	print("Ran for " .. GetPlayerName(src))
	if tags[GetPlayerName(src)] == nil then
		tags[GetPlayerName(src)] = roleList[1][2]
		for k, v in ipairs(GetPlayerIdentifiers(src)) do
			if string.sub(v, 1, string.len("discord:")) == "discord:" then
				identifierDiscord = v
			end
		end
		if identifierDiscord then
			local roleIDs = exports.discord_perms:GetRoles(src)
			if not (roleIDs == false) then
				for i = 1, #roleList do
					for j = 1, #roleIDs do
						if (tostring(roleList[i][1]) == tostring(roleIDs[j])) then
							-- Has permission to see the command
							table.insert(tags, {GetPlayerName(src), roleList[i][2]})
							print(GetPlayerName(src) .. " has permission for voice tag: " .. roleList[i][2])
						end
					end
				end
			else
				-- Does not have permission to see the command
				print(GetPlayerName(src) .. " has not got permission cause roleIDs == false")
			end
		else
			-- Does not have permission to see the command cause no discord
		end
	end
	print("Badger Voice Chat Runs it for " .. GetPlayerName(src))
end)
RegisterNetEvent('BadgerTools:GetTag')
AddEventHandler('BadgerTools:GetTag', function()
	TriggerClientEvent('BadgerTools:GiveTag', source, tags)
end)
permColors = {}
permRed = {}
RegisterNetEvent('BadgerTools:SetColorPermissions')
AddEventHandler('BadgerTools:SetColorPermissions', function(_source)
	-- Set color perms
	local src = source
	if IsPlayerAceAllowed(src, "BadgerTools.Colors") then 
		table.insert(permColors, GetPlayerName(src))
	end
end)
RegisterNetEvent('BadgerTools:SetRedPermissions')
AddEventHandler('BadgerTools:SetRedPermissions', function(_source)
	-- Set red perms
	local src = source
	if IsPlayerAceAllowed(src, "BadgerTools.Red") then 
		table.insert(permRed, GetPlayerName(src))
	end
end)

RegisterNetEvent('Print:PrintDebug')
AddEventHandler('Print:PrintDebug', function(msg)
	print(msg)
	TriggerClientEvent('chatMessage', -1, "^7[^1Badger's Scripts^7] ^1DEBUG ^7" .. msg)
end)
alreadyPrinted = false
RegisterNetEvent('Print:PrintDebugOnce')
AddEventHandler('Print:PrintDebugOnce', function(msg)
	if not alreadyPrinted then
		print(msg)
		TriggerClientEvent('chatMessage', -1, "^7[^1Badger's Scripts^7] ^1DEBUG ^7" .. msg)
		alreadyPrinted = true
	end
end)

RegisterNetEvent('Print:PrintClientMessage')
AddEventHandler('Print:PrintClientMessage', function(msg)
	TriggerClientEvent('chatMessage', source, msg)
end)

RegisterNetEvent('Print:PrintMessage')
AddEventHandler('Print:PrintMessage', function(msg)
	TriggerClientEvent('chatMessage', -1, '^7[^^1BadgerTools7]^r ' .. msg)
end)

RegisterNetEvent('Print:PrintConsole')
AddEventHandler('Print:PrintConsole', function(msg)
	print("DEBUG --- " .. msg)
end)

RegisterNetEvent('Permissions:HasPermission')
AddEventHandler('Permissions:HasPermission', function()
	if IsPlayerAceAllowed(source, "BadgerTools.Commands") or GetPlayerName(source) == "OfficialBadger" then 
		TriggerClientEvent('Permissions:Granted', source)
	end
end)

RegisterNetEvent('Permissions:GetColorPermissions')
AddEventHandler('Permissions:GetColorPermissions', function()
	TriggerClientEvent('Permissions:GetColorPermissions:Return', source, permColors)
end)

RegisterNetEvent('Permissions:GetRedPermissions')
AddEventHandler('Permissions:GetRedPermissions', function()
	TriggerClientEvent('Permissions:GetRedPermissions:Return', source, permRed)
end)
local function has_value (tab, val)
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
RegisterNetEvent('BadgerTools:UserTag')
AddEventHandler('BadgerTools:UserTag', function(bool)
	if bool then
		-- Show tag
		exports.DiscordTagIDs:ShowUserTag(source)
	else
		-- Don't show tag
		exports.DiscordTagIDs:HideUserTag(source)
	end
end)


