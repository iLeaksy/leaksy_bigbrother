ESX = nil
local resName = GetCurrentResourceName()
local active = false


Citizen.CreateThread(function()
	if GetResourceKvpString(resName..":checked") == "false" then
        active = true
    end
	SendNuiMessage(json.encode({
        banner = GetResourceKvpString(resName..":banner")
    }))

	while ESX == nil do
	TriggerEvent('esx:GetSharedObjects', function(obj) ESX = obj end)
	Wait(0)
	end
end)

local InSpectatorMode	= false
local TargetSpectate	= nil
local LastPosition		= nil
local polarAngleDeg		= 0;
local azimuthAngleDeg	= 90;
local radius			= -3.5;
local cam 				= nil
local PlayerDate		= {}
local ShowInfos			= false
local group


function polar3DToWorld3D(entityPosition, radius, polarAngleDeg, azimuthAngleDeg)
	-- convert degrees to radians
	local polarAngleRad   = polarAngleDeg   * math.pi / 180.0
	local azimuthAngleRad = azimuthAngleDeg * math.pi / 180.0

	local pos = {
		x = entityPosition.x + radius * (math.sin(azimuthAngleRad) * math.cos(polarAngleRad)),
		y = entityPosition.y - radius * (math.sin(azimuthAngleRad) * math.sin(polarAngleRad)),
		z = entityPosition.z - radius * math.cos(azimuthAngleRad)
	}

	return pos
end

function spectate(target)

	ESX.TriggerServerCallback('esx:getPlayerData', function(player)
		if not InSpectatorMode then
			LastPosition = GetEntityCoords(GetPlayerPed(-1))
		end

		local playerPed = GetPlayerPed(-1)

		SetEntityCollision(playerPed, false, false)
		SetEntityVisible(playerPed, false)

		PlayerData = player
		if ShowInfos then
			SendNUIMessage({
				type = 'infos',
				data = PlayerData
			})	
		end

		Citizen.CreateThread(function()

			if not DoesCamExist(cam) then
				cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
			end

			
			SetCamActive(cam, true)
			TriggerServerEvent('specaj', target)
			RenderScriptCams(true, true, 10, false, true)
			--PlaySoundFrontend(-1, "RACE_PLACED", "HUD_AWARDS")

			InSpectatorMode = true
			TargetSpectate  = target

		end)
	end, target)

end


--local tabla = {}
function resetNormalCamera()
	InSpectatorMode = false
	TargetSpectate  = nil
	local playerPed = GetPlayerPed(-1)

	SetCamActive(cam,  false)
	RenderScriptCams(false, false, 0, true, true)

	SetEntityCollision(playerPed, true, true)
	SetEntityVisible(playerPed, true)
	--SetEntityCoords(playerPed, vector3(405.75684753418,-947.78145019531,-99.691423416138))
    SetEntityCoords(playerPed, LastPosition.x, LastPosition.y, LastPosition.z)
	CancelEvent('spectate')
end


function getPlayersList()

	local players = ESX.Game.GetPlayers()
	local data = {}
	local kanala
	local imea
	for i=1, #players, 1 do
	
		
		local _data = {
			id = GetPlayerServerId(players[i]),
			name = GetPlayerName(players[i]),
		}
		table.insert(data, _data)
	end

	return data
end

RegisterNetEvent('es_admin:setGroup')
AddEventHandler('es_admin:setGroup', function(g)
	--print('group setted ' .. g)
	group = g
end)

RegisterNetEvent('rsp:spectate')
AddEventHandler('rsp:spectate', function()
	if not IsPauseMenuActive() then
		SetNuiFocus(true, true)
		SetCursorLocation(0.1, 0.1)
		SendNUIMessage({
			json.encode({
				banner = GetResourceKvpString(resName..":banner")
			}),
			type = 'show',
			data = getPlayersList(),
			player = GetPlayerServerId(PlayerId())
		})
		
	end
end)

RegisterNUICallback('select', function(data, cb)
	--local vremetranjanje = math.random(30000 , 50000) 
	::spec_opet::
	local vremetranjanje = 20000
	SetNuiFocus(false)
	print("Odabran Igrac " .. json.encode(data))
	--print("Trajanje specteta svakog igraca " .. vremetranjanje / 1000 .. " sekunda")

	local players = ESX.Game.GetPlayers()
		for k,v in ipairs(players) do
		
		local targetPed = GetPlayerPed(v)
		print('Trenutno spectate ' .. GetPlayerServerId(v))
		ESX.ShowNotification('BigBrother look a player ID ' .. GetPlayerServerId(v).. ' or some active player next ' .. vremetranjanje / 1000 .. ' second')
		-- autospectate
		local playerID = GetPlayerServerId(v)
		local playerPed = GetPlayerPed(v)
		--local health = GetEntityHealth(GetPlayerPed(-1))
		local specosoba = GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1)))
		if playerID == specosoba or IsEntityDead(playerPed) or playerID == 0 then
		playerID = math.random(k,v)
		--goto spec_opet
		else
		spectate(playerID)
		Citizen.Wait(vremetranjanje)
	end
	end
goto spec_opet
end)

--[[
RegisterNUICallback('select', function(data, cb)
	::spec_opet::
	--local vremetranjanje = math.random(3000 , 5000) 
	local vremetranjanje = 15000
	SetNuiFocus(false)
	--print("Sel " .. json.encode(data))
    --print("Spec Vreme -  " .. vremetranjanje / 1000 .. " s")

	local players = ESX.Game.GetPlayers()
		for k,v in ipairs(players) do
		Citizen.Wait(vremetranjanje)
		--local targetPed = GetPlayerPed(v) -- osoba koja pokrene komandu
		-- autospectate
		local playerID = GetPlayerServerId(v) -- osobu koju spec-a
		--local playerPed = GetPlayerPed(v) -- nemam pojma
		local specosoba = GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1))) -- id osobe koja pokrece komandu
		if playerID == specosoba then
			--print('Osoba pokusava da speca sebe, prebacujem na drugog usera')
			--spectate(playerID)
			--break 
			goto spec_opet
		else
		local playerID = GetPlayerServerId(math.random(1,v))
		local playerPed = GetPlayerPed(v)
	    spectate(playerID)
		end
	end

end)

]]

RegisterNUICallback('close', function(data, cb)
	--print("closing UI")
	SetNuiFocus(false)
end)

RegisterNUICallback('quit', function(data, cb)
	SetNuiFocus(false)
	resetNormalCamera()
	
end)

Citizen.CreateThread(function()
  	while true do
		Wait(0)
		if InSpectatorMode then

			local targetPlayerId = GetPlayerFromServerId(TargetSpectate)
			local playerPed	  = GetPlayerPed(-1)
			local targetPed	  = GetPlayerPed(targetPlayerId)
			local coords	 = GetEntityCoords(targetPed)

			for i=0, 255, 1 do
				if i ~= PlayerId() then
					local otherPlayerPed = GetPlayerPed(i)
					SetEntityNoCollisionEntity(playerPed,  otherPlayerPed,  true)
					SetEntityVisible(playerPed, false)
				end
			end

			if radius > -1 then
				radius = -1
			end

			local xMagnitude = GetDisabledControlNormal(0, 1);
			local yMagnitude = GetDisabledControlNormal(0, 2);

			polarAngleDeg = polarAngleDeg + xMagnitude * 10;

			if polarAngleDeg >= 360 then
				polarAngleDeg = 0
			end

			azimuthAngleDeg = azimuthAngleDeg + yMagnitude * 10;

			if azimuthAngleDeg >= 360 then
				azimuthAngleDeg = 0;
			end

			local nextCamLocation = polar3DToWorld3D(coords, radius, polarAngleDeg, azimuthAngleDeg)

			SetCamCoord(cam,  nextCamLocation.x,  nextCamLocation.y,  nextCamLocation.z)
			PointCamAtEntity(cam,  targetPed)
			SetEntityCoords(playerPed,  coords.x, coords.y, coords.z + 5)
		end

  	end
end)
--[[
local ueventu = false
local r,g,b = 20, 20, 170
local x, y = 550.0, 550.0
local xKorda = 1001.5223999023
local yKorda = -3150.1589355469
local zKorda = 5.9007368087769
local korde = vector3(xKorda,yKorda,zKorda)

CreateThread(function()
        while true do
          local kordinate = GetEntityCoords(PlayerPedId())
          Citizen.Wait(3)
          if ueventu then
                DrawMarker(1, korde, 0, 0, 0, 0, 0, 180, x, y, 600.0, r,g,b, 185, 0, 0, 2, 0, 0, 0, 0)
          end
        end
      end)

]]
RegisterNUICallback("save_data", function(data)
    SetResourceKvp(resName..":banner", tostring(data.banner))
	--print('saved')
end)
--[[
local tabelaOruzija = {"rec 1", "rec 2", "rec 3", "rec 4", "rec 5"}

RegisterCommand('testiszona', function(source,args)
    --print(tabelaOruzija[math.random(1, #tabelaOruzija)])
    end,false)
	
	RegisterCommand('mark', function(source,args)
        if args[1] == 'on' then
            xKorda = tonumber(args[3])
            yKorda = tonumber(args[4])
            zKorda = tonumber(args[5])
            korde = vector3(xKorda,yKorda,zKorda)
			--print(korde)
            x = tonumber(args[6])
            y = tonumber(args[6])
            ueventu = true
        elseif args[1] == 'off' then
            ueventu = false
        end
        end,false)]]
		
