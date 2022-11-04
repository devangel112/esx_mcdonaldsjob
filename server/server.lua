ESX = nil
-- TriggerEvent('esx_phone:registerNumber', 'bahamas', true, true)
TriggerEvent("esx_society:registerSociety", Config.JobName, Config.JobName, "society_" .. Config.JobName, "society_" .. Config.JobName, "society_" .. Config.JobName, {type = "private"})

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent(Config.ScriptName .. ':shop:buy')
AddEventHandler(Config.ScriptName .. ':shop:buy', function(item, cantidad, price)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = price * cantidad
	if(xPlayer.getMoney() >= price) then
		xPlayer.removeMoney(price)
		xPlayer.addInventoryItem(item, cantidad)
	end
end)

ESX.RegisterServerCallback(Config.ScriptName .. ':getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

RegisterServerEvent(Config.ScriptName .. ':putStockItems')
AddEventHandler(Config.ScriptName .. ':putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. Config.JobName, function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, 'Has depositado ', count, inventoryItem.label)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, 'Cantidad invalida')
		end
	end)
end)

ESX.RegisterServerCallback(Config.ScriptName .. ':getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. Config.JobName, function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent(Config.ScriptName .. ':getStockItem')
AddEventHandler(Config.ScriptName .. ':getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. Config.JobName, function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then

			-- can the player carry the said amount of x item?
			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				xPlayer.showNotification('Has cogido', count, inventoryItem.name)
			else
				xPlayer.showNotification('Cantidad invalida')
			end
		else
			xPlayer.showNotification('Cantidad invalida')
		end
	end)
end)    
