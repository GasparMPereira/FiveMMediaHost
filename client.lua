local svHost = nil

Citizen.CreateThread(function()
    Citizen.Wait(10)
    TriggerServerEvent('fivemimagehost:reqUploadUrl')
end)

RegisterNetEvent('fivemimagehost:uploadUrl')
AddEventHandler('fivemimagehost:uploadUrl', function(url)
    svHost = url
end)

exports('getUploadServer', function()
    while svHost == nil do
        Wait(10)
    end
    return svHost..'/upload'
end)
