ESX = nil

local PlayerData = {}
local playerInService = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end 

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

Citizen.CreateThread(function()
    local cloakroom = { x = -172.525, y = 290.2113, z = 93.762 }
    local shop = { x = 55.08, y = -1739.24, z = 29.6 }
    local garage = { x = -1399.28, y = -639.96, z = 28.68 }
    local armory = { x = -172.651, y = 295.4512, z = 93.762 }
    local boss = { x = -1366.08, y = -624.4, z = 30.32 }
    
    while true do
        local _msec = 250
        if PlayerData.job and PlayerData.job.name == Config.JobName then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)


            local dist_cloakroom = Vdist(playerCoords, Config.Locations['cloakroom'].pos.x, Config.Locations['cloakroom'].pos.y, Config.Locations['cloakroom'].pos.z, true)
            
            if dist_cloakroom < 3 then
                _msec = 0
                Draw3DText( Config.Locations['cloakroom'].pos.x, Config.Locations['cloakroom'].pos.y, Config.Locations['cloakroom'].pos.z, _U('cloakroom'))
                if dist_cloakroom <= 1.5 and IsControlJustPressed(0, 38) then
                    OpenTaquilla()
                end
            end

            --if playerInService then
                local dist_shop = Vdist(playerCoords, Config.Locations['shop'].pos.x, Config.Locations['shop'].pos.y, Config.Locations['shop'].pos.z, true)

                if dist_shop < 3 then
                    _msec = 0
                    Draw3DText( Config.Locations['shop'].pos.x, Config.Locations['shop'].pos.y, Config.Locations['shop'].pos.z, _U('shop'))
                    if dist_shop <= 1.5 and IsControlJustPressed(0, 38) then
                        ExecuteCommand('me Abre el catálogo de la tienda')
                        OpenShopMenu()
                    end
                end

                local dist_garage = Vdist(playerCoords, Config.Locations['garage'].pos.x, Config.Locations['garage'].pos.y, Config.Locations['garage'].pos.z, true)
                local dist_garage_dv = Vdist(playerCoords, Config.Locations['garage_dv'].pos.x, Config.Locations['garage_dv'].pos.y, Config.Locations['garage_dv'].pos.z, true)

                if dist_garage < 3 then
                    _msec = 0
                    if not IsPedInAnyVehicle(playerPed, true) then
                        Draw3DText( Config.Locations['garage'].pos.x, Config.Locations['garage'].pos.y, Config.Locations['garage'].pos.z + 1, _U('garage_get_vehicle'))
                        if dist_garage <= 1.5 and IsControlJustPressed(0, 38) then
                            OpenGarageMenu()
                        end
                    end
                end
                
                if dist_garage_dv < 3 then
                    _msec = 0
                    if IsPedInAnyVehicle(playerPed, true) then
                        Draw3DText( Config.Locations['garage_dv'].pos.x, Config.Locations['garage_dv'].pos.y, Config.Locations['garage_dv'].pos.z + 1, _U('garage_return_vehicle'))
                        if dist_garage_dv <= 1.5 and IsControlJustPressed(0, 38) then
                            local vehicle = GetVehiclePedIsIn(playerPed, false)
                            ESX.Game.DeleteVehicle(vehicle)
                        end
                    end
                end

                local dist_armory = Vdist(playerCoords, Config.Locations['armory'].pos.x, Config.Locations['armory'].pos.y, Config.Locations['armory'].pos.z, true)

                if dist_armory < 3 then
                    _msec = 0
                    Draw3DText( Config.Locations['armory'].pos.x, Config.Locations['armory'].pos.y, Config.Locations['armory'].pos.z + 1, _U('armory'))
                    if dist_armory <= 1.5 and IsControlJustPressed(0, 38) then
                        ExecuteCommand('me Mete la llave y abre la puerta')
                        OpenArmoryMenu()
                    end
                end
                
                
                local dist_boss = Vdist(playerCoords, Config.Locations['boss'].pos.x, Config.Locations['boss'].pos.y, Config.Locations['boss'].pos.z + 1, true)
            
                if PlayerData.job and PlayerData.job.name == Config.JobName and PlayerData.job.grade_name == Config.BossGradeLabel then
                    if dist_boss < 3 then
                        _msec = 0
                        Draw3DText( Config.Locations['boss'].pos.x, Config.Locations['boss'].pos.y, Config.Locations['boss'].pos.z, _U('boss'))
                        if dist_boss <= 1.5 and IsControlJustPressed(0, 38) then
                            ExecuteCommand('me Enciende el ordenador y mira la lista de empleados')
                            OpenBossMenu()
                        end
                    end
                end

                
           -- end
        end 


        Citizen.Wait(_msec)
    end
end)

RegisterKeyMapping('menu' .. Config.JobName, 'Menu ' .. Config.JobName, 'keyboard', 'F6')
RegisterCommand('menu'.. Config.JobName, function()
    if PlayerData.job and PlayerData.job.name == Config.JobName then
        OpenMobileMenu()
    end
end)
function OpenMobileMenu()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'facturas', {
        title = 'Facturas'
    }, function(data, menu)

        local amount = tonumber(data.value)
        if amount == nil then
            ESX.ShowNotification('Cantidad invalida')
        else
            menu.close()
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestPlayer == -1 or closestDistance > 3.0 then
                ESX.ShowNotification('No hay nadie cerca')
            else
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_' .. Config.JobName, Config.JobName, amount)
                ESX.ShowNotification('Factura emitada')
            end

        end

    end, function(data, menu)
        menu.close()
    end)
end


Draw3DText = function( x, y, z, text )
    local onScreen, _x, _y = World3dToScreen2d( x, y, z )

    if onScreen then
        SetTextScale( 0.4, 0.4)
        SetTextFont( 4 )
        SetTextColour( 255, 255, 255, 255)
        SetTextOutline()
        SetTextEntry( "STRING" )
        SetTextCentre( 1 )
        AddTextComponentString( text )
        DrawText( _x, _y)
    end
end


OpenTaquilla = function()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',{
        title = 'Taquilla',
        align = 'bottom-right',
        elements = {
            { label = 'Ropa de civil', value = 'citizen_wear'},
            { label = 'Uniforme', value = 'uniform'}
        }
    }, function( data, menu)
        local value = data.current.value

        local playerPed = PlayerPedId()

        if value == 'citizen_wear' then 
           -- if playerInService then 
              --  playerInService = false
                ExecuteCommand('me Abre la taquilla y se pone su ropa')
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                    local model = nil
          
                    if skin.sex == 0 then
                      model = GetHashKey("mp_m_freemode_01")
                    else
                      model = GetHashKey("mp_f_freemode_01")
                    end
          
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                      RequestModel(model)
                      Citizen.Wait(1)
                    end
          
                    SetPlayerModel(PlayerId(), model)
                    SetModelAsNoLongerNeeded(model)
          
                    TriggerEvent('skinchanger:loadSkin', skin)
                    TriggerEvent('esx:restoreLoadout')
                end)
                menu.close()
           -- end
        elseif value == 'uniform' then 
           -- if not playerInService then
                ExecuteCommand('me Abre la taquilla y se pone la ropa de trabajo')
            --    playerInService = true
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

                    if skin.sex == 0 then
                        TriggerEvent('skinchanger:change', 'torso_1', 8)
                        TriggerEvent('skinchanger:change', 'torso_2', 0)
                        TriggerEvent('skinchanger:change', 'tshirt_1', 15)
                        TriggerEvent('skinchanger:change', 'arms', 8)
                        TriggerEvent('skinchanger:change', 'pants_1', 82)
                        TriggerEvent('skinchanger:change', 'pants_2', 2)
                        TriggerEvent('skinchanger:change', 'shoes_1', 31)
                        TriggerEvent('skinchanger:change', 'shoes_2', 0)
                        TriggerEvent('skinchanger:change', 'chain_1', 0)
                        TriggerEvent('skinchanger:change', 'chain_2', 0)
                        TriggerEvent('skinchanger:change', 'helmet_1', 5)
                        TriggerEvent('skinchanger:change', 'helmet_2', 0)
                    else
                        TriggerEvent('skinchanger:change', 'torso_1', 89)
                        TriggerEvent('skinchanger:change', 'torso_2', 0)
                        TriggerEvent('skinchanger:change', 'tshirt_1', 152)
                        TriggerEvent('skinchanger:change', 'tshirt_2', 0)
                        TriggerEvent('skinchanger:change', 'arms', 14)
                        TriggerEvent('skinchanger:change', 'pants_1', 51)
                        TriggerEvent('skinchanger:change', 'pants_2', 0)
                        TriggerEvent('skinchanger:change', 'shoes_1', 74)
                        TriggerEvent('skinchanger:change', 'shoes_2', 24)
                        TriggerEvent('skinchanger:change', 'chain_1', 0)
                        TriggerEvent('skinchanger:change', 'chain_2', 0)
                        TriggerEvent('skinchanger:change', 'helmet_1', -1)
                        TriggerEvent('skinchanger:change', 'helmet_2', 0)
                        TriggerEvent('skinchanger:change', 'mask_1', -1)
                        TriggerEvent('skinchanger:change', 'mask_2', 0)
                        TriggerEvent('skinchanger:change', 'bags_1', 0)
                        TriggerEvent('skinchanger:change', 'bags_2', 0)
                        TriggerEvent('skinchanger:change', 'glasses_1', 5)
                        TriggerEvent('skinchanger:change', 'glasses_2', 0)
                        TriggerEvent('skinchanger:change', 'bproof_1', 0)
                        TriggerEvent('skinchanger:change', 'bproof_2', 0)
                    end
                end)
                menu.close()
           -- end
        end
    end, function(data, menu)
        menu.close()
    end)
end

OpenShopMenu = function()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'GiGi_Shops',
		{
			title    = 'Bienvenido/a al Supermercado',
			align    = 'bottom-right',
			elements = Config.ShopItems
		},
		function(data, menu)
            local item = data.current.item
            local price = data.current.price
            local cantidad = data.current.value
            TriggerServerEvent(Config.ScriptName .. ':shop:buy', item, cantidad, price)
		end,
	function(data, menu)
		menu.close()
	end)
end

OpenGarageMenu = function()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'GiGi_Shops',
		{
			title    = 'Bienvenido/a al Supermercado',
			align    = 'bottom-right',
			elements = Config.GarageCars
		},
		function(data, menu)
            if ESX.Game.IsSpawnPointClear(vector3(Config.Locations['garage_spawn'].pos.x, Config.Locations['garage_spawn'].pos.y, Config.Locations['garage_spawn'].pos.z), 5) then
                ESX.Game.SpawnVehicle(data.current.model, vector3(Config.Locations['garage_spawn'].pos.x, Config.Locations['garage_spawn'].pos.y, Config.Locations['garage_spawn'].pos.z), Config.Locations['garage_spawn'].heading, function(vehicle)
                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                    SetVehicleNumberPlateText(vehicle, 'MCD')
                end)
            else
                ESX.ShowNotification('Aparcarmiento obtruido')
            end
            menu.close()
		end,
	function(data, menu)
		menu.close()
	end)
end


OpenArmoryMenu = function()
	local elements = {
		{label = 'Abrir inventario', value = 'open_society'}
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
		title    = 'Almacén',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
	    if data.current.value == 'open_society' then
            ESX.UI.Menu.CloseAll()
            exports.ox_inventory:openInventory('stash', 'society_' .. Config.JobName)
		end
	end, function(data, menu)
		menu.close()
	end)
end

--[[OpenPutStocksMenu = function()
	ESX.TriggerServerCallback(Config.ScriptName .. ':getPlayerInventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = 'Inventario',
			align    = 'bottom-right',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = 'Cantidad'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification('Cantidad invalida')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent(Config.ScriptName .. ':putStockItems', itemName, count)

					Citizen.Wait(300)
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end


OpenGetStocksMenu = function()
	ESX.TriggerServerCallback(Config.ScriptName .. ':getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {
				label = 'x' .. items[i].count .. ' ' .. items[i].label,
				value = items[i].name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = 'Almacén',
			align    = 'bottom-right',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = 'Cantidad'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification('Cantidad invalida')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent(Config.ScriptName .. ':getStockItem', itemName, count)

					Citizen.Wait(1000)
					OpenGetStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end]]

OpenBossMenu = function()
    TriggerEvent('esx_society:openBossMenu', Config.JobName, function(data, menu)
        menu.close()
    end, { wash = false })
end