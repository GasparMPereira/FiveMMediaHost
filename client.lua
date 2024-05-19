local svHost = nil

Citizen.CreateThread(function()
    Citizen.Wait(10)
    TriggerServerEvent('fivemmediahost:reqUploadUrl')
end)

RegisterNetEvent('fivemmediahost:uploadUrl')
AddEventHandler('fivemmediahost:uploadUrl', function(url)
    svHost = url
end)

exports('getUploadServer', function()
    while svHost == nil do
        Wait(10)
    end
    return svHost..'/upload'
end)
