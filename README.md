<h1 align='center'><strong>FiveMMediaHost</strong></h1>
<div align='center'><a href='https://discord.gg/4GV6a335ae/'>Discord</a><br><br><p><b>This resource for FiveM Servers allows you to host media files in your server, without uploading any file to third party websites</b></p></div>

## How to configure
  1. Paste the FiveMMediaHost in your resources/ folder
  2. Add ```ensure FiveMMediaHost``` at start before other resources in your server.cfg
  3. Start the server and that's all

> [!WARNING]
> **When using this script instead of uploading photos to an external server, you must have space available on the server's storage!**

> [!IMPORTANT]
> **If you put the script inside some other folder like reesources/[utils]/FiveMMediaHost you need to change**
> 
> ```Config.ImageDirectory = "resources/"..GetCurrentResourceName().."/images/"```
> 
> **TO**
> 
> ```Config.ImageDirectory = "resources/[utils]/"..GetCurrentResourceName().."/images/"```

> [!NOTE]
> The resource currently support:<br>
> • Images [webp/png/jpg]<br>
> • Audio [ogg/mp3/webm]<br>
> • Video [mp4/webm]<br>
> Use webp/webm for faster loading and less media storage

## Config File
```
Config = {}
Config.UseCFXReDomain = true --// Use CFX.re domain of your server? TRUE RECOMMENDED
Config.ServerHost = "http://127.0.0.1:30120/"..GetCurrentResourceName() --// OR you can replace with your custom domain name/IP address
Config.IDLength = 30 --// Image name length
Config.MediaEndpoint = 'media' --// The endpoint where you can get media files
Config.ImageDirectory = "resources/"..GetCurrentResourceName().."/images/" --//
Config.SoundDirectory = "resources/"..GetCurrentResourceName().."/sounds/" --//
Config.VideoDirectory = "resources/"..GetCurrentResourceName().."/videos/" --//
```

## How to pass the url server for an encrypted resource
```
Config.ImageUploadURL = exports['FiveMMediaHost']:getUploadServer()
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

## Example of how to upload audio
In this repository I created, you can test how to send audio to the script:
https://github.com/GasparMPereira/HTML-Microphone-Recorder

## Example of how to upload video
In this repository I created, you can test how to send video to the script:
https://github.com/GasparMPereira/HTML-Camera-Recorder

## How to pass the url server for an resource that needs it in text format

1. Check your CFX.re domain in server console

![cfx_re_domain](https://github.com/GasparMPereira/FiveMMediaHost/assets/71574610/e40eacfa-680c-4e6e-a3fa-e4759bae2025)

2. Copy and paste it in your script as ```https://your_cfx_re_domain/FiveMMediaHost/upload```
3. Then you can get the images making a request to ```https://your_cfx_re_domain/FiveMMediaHost/media/your_media_file_id.extension```

# Legal

> [!TIP]
> If you have any suggestions to add to the project, open a pull request.
> All help is welcome!

### License
FiveMMediaHost - Image host for FiveM Servers

Copyright (C) 2024 - Gaspar Pereira
