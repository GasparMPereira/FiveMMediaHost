--print(GetResourcePath(GetCurrentResourceName()))
--local imageDirectory = "resources/"..GetCurrentResourceName().."/images/"
local imageDirectory = "resources/[phone]/"..GetCurrentResourceName().."/images/"

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

local function getExtension(content_type)
    if content_type == "image/png" then
        return ".png"
    elseif content_type == "image/jpeg" then
        return ".jpg"
    elseif content_type == "image/webp" then
        return ".webp"
    else
        return ".jpg"
    end
end

SetHttpHandler(function(request, response)
    if request.method == 'POST' and request.path == '/upload' then
        request.setDataHandler(function(body)
            if(body)then
                local imageID
                local imageName
                local imagePath
                local content_type = (body:match("Content%-Type:%s*(.-)\n") or ""):gsub("^%s*(.-)%s*$", "%1")

                repeat
                    imageID = generateID()
                    imageName = imageID..getExtension(content_type)
                    imagePath = imageDirectory..imageName
                until not fileExists(imagePath)

                local boundary = request.headers['Content-Type']:match('boundary=(.*)')

                local start_index, end_index = string.find(body, boundary, 1, true)
                if not start_index or not end_index then
                    return false
                end
                -- Encontra o início do corpo da imagem
                local image_start_index = string.find(body, "\r\n\r\n", end_index + 1, true)
                if not image_start_index then
                    return false
                end
                -- Escreve o corpo da imagem num arquivo
                local image_data = string.sub(body, image_start_index + 4)

                local imageFile = io.open(imagePath, 'wb')
                imageFile:write(image_data)
                imageFile:close()
                    
                local url = "http://"..Config.ServerHost..":30120/"..GetCurrentResourceName().."/images/" .. imageName
                response.writeHead(200, { ['Content-Type'] = 'application/json' })
                response.send(json.encode({ id = imageID, attachments = {{proxy_url = url}}, url = url }))
            else
                response.writeHead(400, { ['Content-Type'] = 'text/plain' })
                response.send("No images uploaded")
            end
        end)
    elseif request.method == 'GET' and request.path:match("^/images/%w+%.([png|jpg|webp]+)$") then
        local imageID = request.path:match("^/images/(%w+)%.([png|jpg|webp]+)$")
        local imageName = imageID .. "." .. request.path:match("%.([png|jpg|webp]+)$")
        local imagePath = imageDirectory .. imageName
        if fileExists(imagePath) then
            local file = io.open(imagePath, "rb")
            local imageData = file:read("*all")
            file:close()

            local contentType = ''
            if request.path:match("%.png$") then
                contentType = 'image/png'
            elseif request.path:match("%.jpg$") then
                contentType = 'image/jpeg'
            elseif request.path:match("%.webp$") then
                contentType = 'image/webp'
            end

            response.writeHead(200, { ['Content-Type'] = contentType })
            response.send(imageData)
        else
            response.writeHead(404, { ['Content-Type'] = 'text/plain' })
            response.send("Image not found")
        end
    else
        response.writeHead(404, { ['Content-Type'] = 'text/plain' })
        response.send("Endpoint not found")
    end
end)
