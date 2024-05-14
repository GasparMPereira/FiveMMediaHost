<h1 align='center'><strong>FiveMImageHost</strong></h1>
<div align='center'><a href='https://https://discord.gg/4GV6a335ae/'>Discord</a><br><br><p><b>This resource for FiveM Servers allows you to host images in your server, without uploading any file to 3 party websites</b></p></div>

## How to configure
  1. Paste the FiveMImageHost in your resources/ folder
  2. Add ```ensure FiveMImageHost``` at start before other resources in your server.cfg
  3. Start the server and that's all

> [!WARNING]
> **When using this script instead of uploading photos to an external server, you must have space available on the server's storage!**

> [!IMPORTANT]
> **If you put the script inside some other folder like reesources/[utils]/FiveMImageHost you need to change**
> 
> ```Config.ImageDirectory = "resources/"..GetCurrentResourceName().."/images/"```
> 
> **TO**
> 
> ```Config.ImageDirectory = "resources/[utils]/"..GetCurrentResourceName().."/images/"```

> [!NOTE]
> The resource support webp/png/jpg images, use webp for faster loading, less media storage and higher image quality

## Config File
```
Config = {}
Config.ServerHost = "https://"..GetConvar("web_baseUrl", "").."/"..GetCurrentResourceName() --// Use CFX.re domain of your server
--Config.ServerHost = "http://127.0.0.1:30120/"..GetCurrentResourceName() --// OR you can replace with your custom domain name/IP address
Config.IDLength = 30 --// Image name length
Config.ImageDirectory = "resources/"..GetCurrentResourceName().."/images/" --//
```

## How to pass the url server for an encrypted resource
```
Config.ImageUploadURL = exports['FiveMImageHost']:getUploadServer()
```

## Example of usage with screenshot-basic
```
local found = promise.new()
exports['screenshot-basic']:requestScreenshotUpload(Config.ImageUploadURL, 'image', {['encoding'] = 'webp'}, function(img)
  if(img)then
    local json = json.decode(img)
    found:resolve(json.attachments[1].proxy_url)
  else
    found:resolve(nil)
  end
end)
local newPicture = Citizen.Await(found)
```

# Legal

> [!TIP]
> If you have any suggestions to add to the project, open a pull request.
> All help is welcome!

### License
FiveMImageHost - Image host for FiveM Servers

Copyright (C) 2024 - Gaspar Pereira
