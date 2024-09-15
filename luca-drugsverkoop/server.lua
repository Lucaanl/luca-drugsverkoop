ESX = exports["es_extended"]:getSharedObject() -- ESX export, niet aan zitten.

RegisterNetEvent('reward')
AddEventHandler('reward', function(item)
    exports.ox_inventory:RemoveItem(source, item, 5)
    exports.ox_inventory:AddItem(source, 'black_money', math.random(3000, 6000))
end)
