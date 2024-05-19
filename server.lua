local cfxReDomain = ""
local svHost = nil

Citizen.CreateThread(function()
    if(Config.UseCFXReDomain)then
        while cfxReDomain == "" do
            Citizen.Wait(10)
            cfxReDomain = GetConvar("web_baseUrl", "")
        end
        svHost = "https://"..cfxReDomain.."/"..GetCurrentResourceName()
    else
        svHost = Config.ServerHost
    end
end)

RegisterServerEvent('fivemimagehost:reqUploadUrl')
AddEventHandler('fivemimagehost:reqUploadUrl', function()
    local source = source
    while svHost == nil do
        Wait(10)
    end
    TriggerClientEvent('fivemimagehost:uploadUrl', source, svHost)
end)

exports('getUploadServer', function()
    while svHost == nil do
        Wait(10)
    end
    return svHost..'/upload'
end)

local function fileExists(path)
    local file = io.open(path, "r")
    if file then
        file:close()
        return true
    end
    return false
end

local function generateID()
    local characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local id = ""
    for _ = 1, Config.IDLength do
        local randomIndex = math.random(#characters)
        id = id .. string.sub(characters, randomIndex, randomIndex)
    end
    return id
end

local function getExtensionAndFolder(contentType)
    local res = {ext = 'unsupported', folder = ''}
    if contentType == "image/png" then
        res = {ext = '.png', folder = Config.ImageDirectory}
    elseif contentType == "image/jpeg" then
        res = {ext = '.jpg', folder = Config.ImageDirectory}
    elseif contentType == "image/webp" then
        res = {ext = '.webp', folder = Config.ImageDirectory}
    elseif contentType == "audio/mpeg" then
        res = {ext = '.mp3', folder = Config.SoundDirectory}
    elseif contentType == "audio/ogg" then
        res = {ext = '.ogg', folder = Config.SoundDirectory}
    elseif contentType == "audio/webm" then
        res = {ext = '.audio.webm', folder = Config.SoundDirectory}
    elseif contentType == "video/mp4" then
        res = {ext = '.mp4', folder = Config.VideoDirectory}
    elseif contentType == "video/webm" then
        res = {ext = '.video.webm', folder = Config.VideoDirectory}
    end
    return res
end

local function getContentTypeAndFolder(reqPath)
    local res = {type = 'unsupported', folder = ''}
    if reqPath:match("%.png$") then
        res = {type = 'image/png', folder = Config.ImageDirectory}
    elseif reqPath:match("%.jpg$") then
        res = {type = 'image/jpeg', folder = Config.ImageDirectory}
    elseif reqPath:match("%.webp$") then
        res = {type = 'image/webp', folder = Config.ImageDirectory}
    elseif reqPath:match("%.mp3$") then
        res = {type = 'audio/mpeg', folder = Config.SoundDirectory}
    elseif reqPath:match("%.ogg$") then
        res = {type = 'audio/ogg', folder = Config.SoundDirectory}
    elseif reqPath:match("%.audio%.webm$") then
        res = {type = 'audio/webm', folder = Config.SoundDirectory}
    elseif reqPath:match("%.video%.webm$") then
        res = {type = 'video/webm', folder = Config.VideoDirectory}
    elseif reqPath:match("%.mp4$") then
        res = {type = 'video/mp4', folder = Config.VideoDirectory}
    end
    return res
end

SetHttpHandler(function(request, response)
    print(request.method, request.path)
    if request.method == 'POST' and request.path == '/upload' then
        request.setDataHandler(function(body)
            if(body)then
                local mediaID
                local mediaName
                local mediaPath
                local contentType = (body:match("Content%-Type:%s*(.-)\n") or ""):gsub("^%s*(.-)%s*$", "%1")

                local info = getExtensionAndFolder(contentType)
                if info.ext == 'unsupported' then
                    response.writeHead(400, { ['Content-Type'] = 'application/json' })
                    response.send(json.encode({ error = '400', description = 'Unsupported media type' }))
                    return
                end

                repeat
                    mediaID = generateID()
                    mediaName = mediaID..info.ext
                    mediaPath = info.folder..mediaName
                until not fileExists(mediaPath)

                local boundary = request.headers['Content-Type']:match('boundary=(.*)')

                local startIndex, endIndex = string.find(body, boundary, 1, true)
                if not startIndex or not endIndex then
                    response.writeHead(400, { ['Content-Type'] = 'application/json' })
                    response.send(json.encode({ error = '400', description = 'Invalid multipart data' }))
                    return
                end
                -- Encontra o início do corpo do ficheiro
                local mediaStartIndex = string.find(body, "\r\n\r\n", endIndex + 1, true)
                if not mediaStartIndex then
                    response.writeHead(400, { ['Content-Type'] = 'application/json' })
                    response.send(json.encode({ error = '400', description = 'Invalid multipart data' }))
                    return
                end
                -- Escreve o corpo da media num ficheiro
                local mediaData = string.sub(body, mediaStartIndex + 4)

                local mediaFile = io.open(mediaPath, 'wb')
                mediaFile:write(mediaData)
                mediaFile:close()
                    
                local url = svHost.."/"..Config.MediaEndpoint.."/" .. mediaName
                response.writeHead(200, { ['Content-Type'] = 'application/json' })
                response.send(json.encode({ id = mediaID, attachments = {{proxy_url = url}}, url = url }))
            else
                response.writeHead(400, { ['Content-Type'] = 'application/json' })
                response.send(json.encode({ error = '400', description = 'No media uploaded' }))
            end
        end)
    elseif request.method == 'GET' and request.path:match("^/"..Config.MediaEndpoint.."/%w+%.([png|jpg|webp|mp3|ogg|audio%.webm|video%.webm|mp4]+)$") then
        local info = getContentTypeAndFolder(request.path)
        if(info.type ~= 'unsupported')then
            local mediaID = request.path:match("^/"..Config.MediaEndpoint.."/(%w+)%.([png|jpg|webp|mp3|ogg|audio%.webm|video%.webm|mp4]+)$")
            local mediaName = mediaID..".".. request.path:match("%.([png|jpg|webp|mp3|ogg|audio%.webm|video%.webm|mp4]+)$")
            local mediaPath = info.folder..mediaName
            if fileExists(mediaPath) then
                local file = io.open(mediaPath, "rb")
                local imageData = file:read("*all")
                file:close()
                response.writeHead(200, { ['Content-Type'] = info.type })
                response.send(imageData)
            else
                response.writeHead(404, { ['Content-Type'] = 'application/json' })
                response.send(json.encode({ error = '400', description = 'Media file not found' }))
            end
        else
            response.writeHead(404, { ['Content-Type'] = 'application/json' })
            response.send(json.encode({ error = '400', description = 'Media file not found' }))
        end
    else
        response.writeHead(404, { ['Content-Type'] = 'application/json' })
        response.send(json.encode({ error = '400', description = 'Endpoint not found' }))
    end
end)
