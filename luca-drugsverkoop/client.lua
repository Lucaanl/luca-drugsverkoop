ESX = exports["es_extended"]:getSharedObject() -- ESX export, dont touch
local isSelling

------------------------ MAIN MISSION ------------------------------
-- Spawn vehicle when starting job
local function spawnVeh()
    ESX.Game.SpawnVehicle(Luca.VehicleModel, Luca.SpawnVeh, Luca.SpawnVehHeading, function(vehicle)
        SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
    end)
end

-- ShowBlips for delivery locs
local function ShowBlipsAndLoc(bool)
    if bool then
        for k, v in pairs(Luca.DeliveryLoc) do
            local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
            SetBlipSprite(blip, 20)
            SetBlipColour(blip, 0)
            SetBlipScale(blip, 1.0)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('Drugs - Verkopen')
            EndTextCommandSetBlipName(blip)
        end
        lib.notify({
            title = 'Indienst',
            description = 'Ga naar de afleverpunten op de map.',
            type = 'info'
        })
    end
end

-- Handle selling the drugs
--[[ CreateThread(function()
    while true do
        local sleep = 1000
        local playerCoords = GetEntityCoords(PlayerPedId())
        for k, v in pairs(Luca.DeliveryLoc) do
            if #(playerCoords - v.coords) < 2.5 and isSelling == true and not Luca.DeliveryLoc.isDelivered then
                sleep = 0
                DrawMarker(2, v.coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 52, 64, 235, 222, true, false, 2,
                    true,
                    nil, nil, false)

                lib.showTextUI('[E] - Verkoop Drugs ', { position = "top-center" })




                if IsControlJustReleased(0, 38) then -- E key
                    lib.progressCircle({
                        label = 'Drugs afleveren',
                        duration = 5500,
                        position = 'bottom',
                        useWhileDead = false,
                        canCancel = true,
                        disable = {
                            car = true,
                        },
                        anim = {
                            dict = 'amb@prop_human_parking_meter@male@idle_a',
                            clip = 'idle_a'
                        },
                    })
                    if isSelling == true and not Luca.DeliveryLoc.isDelivered then
                        return true
                    else
                        return false
                    end
                end
            else
                lib.hideTextUI()
            end

            Wait(sleep)
        end
    end
end) --]]




local function drugsSellMission(item)
    isSelling = true
    spawnVeh()
    ShowBlipsAndLoc(true)
    while true do
        local sleep = 1000
        local playerCoords = GetEntityCoords(PlayerPedId())
        for k, v in pairs(Luca.DeliveryLoc) do
            if #(playerCoords - v.coords) < 2.5 and isSelling == true and not Luca.DeliveryLoc[k].isDelivered then
                sleep = 0
                DrawMarker(2, v.coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 52, 64, 235, 222, true, false, 2,
                    true,
                    nil, nil, false)

                lib.showTextUI('[E] - Verkoop Drugs ', { position = "top-center" })




                if IsControlJustReleased(0, 38) then -- E key
                    lib.progressCircle({
                        label = 'Drugs afleveren',
                        duration = 5500,
                        position = 'bottom',
                        useWhileDead = false,
                        canCancel = true,
                        disable = {
                            car = true,
                        },
                        anim = {
                            dict = 'amb@prop_human_parking_meter@male@idle_a',
                            clip = 'idle_a'
                        },
                    })
                    if isSelling == true and not Luca.DeliveryLoc.isDelivered then
                        TriggerServerEvent('reward', item)
                        return true
                    else
                        return false
                    end
                end
            else
                lib.hideTextUI()
            end

            Wait(sleep)
        end
    end
end
--------------------------- MAIN MISSION ---------------------------

------------------------ MAIN MENU ------------------------------
lib.registerContext({
    id = 'main',
    title = 'Drugs Verkoop',
    options = {
        {
            title = 'Verkoop Drugs',
            description = 'Verkoop je drugs',
            icon = 'pills',
            menu = 'drugs'
        },
        {
            title = 'Annuleer',
            description = 'Verkoop geen drugs aan deze koper',
            icon = 'xmark',
            iconColor = 'red',
            onSelect = function()
                lib.hideContext('main')
            end
        }
    }
})

lib.registerContext({
    id = 'drugs',
    title = 'Drugs',
    options = {
        {
            title = 'Wiet',
            description = 'Verkoop je wiet',
            icon = 'cannabis',
            onSelect = function()
                local wiet = exports.ox_inventory:GetItemCount(Luca.Items.wiet)
                if wiet >= 5 and not isSelling then
                    drugsSellMission(Luca.Items.wiet)
                else
                    lib.notify({
                        title = 'Ongeldig aantal',
                        description = 'Je hebt niet meer dan 5 wiet zakjes',
                        type = 'error'
                    })
                end
            end
        },
        {
            title = 'Cocaïne',
            description = 'Verkoop je cocaine',
            icon = 'snowflake',
            onSelect = function()
                local coke = exports.ox_inventory:GetItemCount(Luca.Items.coke)
                if coke >= 5 and not isSelling then
                    drugsSellMission(Luca.Items.coke)
                else
                    lib.notify({
                        title = 'Ongeldig aantal',
                        description = 'Je hebt niet meer dan 5 cocaine zakjes',
                        type = 'error'
                    })
                end
            end
        },
        {
            title = 'Meth',
            description = 'Verkoop je meth',
            icon = 'tablets',
            onSelect = function()
                local meth = exports.ox_inventory:GetItemCount(Luca.Items.meth)
                if meth >= 5 and not isSelling then
                    drugsSellMission(Luca.Items.meth)
                else
                    lib.notify({
                        title = 'Ongeldig aantal',
                        description = 'Je hebt niet meer dan 5 meth zakjes',
                        type = 'error'
                    })
                end
            end
        }
    }
})


------------------------ MAIN MENU ------------------------------


------------------------ START ------------------------------
CreateThread(function()
    local wiet = exports.ox_inventory:GetItemCount(Luca.Items.wiet)
    local coke = exports.ox_inventory:GetItemCount(Luca.Items.coke)
    local meth = exports.ox_inventory:GetItemCount(Luca.Items.meth)
    local playerCoords = GetEntityCoords(PlayerPedId())
    if #(playerCoords - Luca.MainPedCoords) < 3.0 then
        if not IsModelValid(Luca.MainPedModel) then return end

        local ped
        RequestModel(joaat(Luca.MainPedModel))
        while not HasModelLoaded(joaat(Luca.MainPedModel)) do
            Wait(5)
        end
        ped = CreatePed(4, Luca.MainPedModel, Luca.MainPedCoords.x, Luca.MainPedCoords.y,
            Luca.MainPedCoords.z, Luca.MainPedHeading, false,
            false)
        SetEntityNoCollisionEntity(PlayerPedId(), ped, false)
        SetEntityCanBeDamaged(ped, false)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        exports.ox_target:addLocalEntity(ped, {
            {
                label = 'Drugs verkopen',
                icon = 'tablets',
                distance = 3.0,
                onSelect = function()
                    if not isSelling and wiet >= 5 or coke >= 5 or meth >= 5 then -- E key
                        lib.showContext('drugs')
                    end
                end
            }
        })
    end
end)

------------------------ START ------------------------------
