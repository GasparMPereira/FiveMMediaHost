AddEventHandler('playerSpawned', function()
    TriggerServerEvent('fivemimagehost:reqUploadUrl')
end)

RegisterNetEvent('fivemimagehost:uploadUrl')
AddEventHandler('fivemimagehost:uploadUrl', function(url)
    Config.ServerHost = url
end)

exports('getUploadServer', function()
    return Config.ServerHost
end)