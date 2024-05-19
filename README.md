<h1 align='center'><strong>FiveMMediaHost</strong></h1>
<div align='center'><a href='https://discord.com/invite/4GV6a335ae'>Discord</a><br><br><p><b>This resource for FiveM Servers lets you host media files directly on your server, eliminating the need to upload files to third-party websites.</b></p></div>

## Installation

1. Paste the `FiveMMediaHost` folder in your `resources` folder
2. Add `ensure FiveMMediaHost` at the start, before other resources, in your `server.cfg`
3. Start the server and that's all

> [!WARNING]
> **Always ensure to have enough disk space when using this resource!**

> [!IMPORTANT]
> **If you place the resource in a subfolder (e.g., `resources/[utils]/FiveMMediaHost`) your `ImageDirectory` property would need to be `Config.ImageDirectory = "resources/[utils]/"..GetCurrentResourceName().."/images/"`**

> [!NOTE]
> This resource currently supports:
> 
> - Images (webp/png/jpg) 
> - Audio (ogg/mp3/webm)
> - Video (mp4/webm)
> 
> Note: Use _webp_ and _webm_ for faster loading and smaller files.

## Configuration Settings

```lua
Config = {}
Config.UseCFXReDomain = true -- Use your server's CfxX.re domain? (Recommended true)
Config.ServerHost = "http://127.0.0.1:30120/"..GetCurrentResourceName() -- Or you can replace it with your custom domain name/IP address
Config.IDLength = 30 -- Image name length
Config.MediaEndpoint = 'media' -- The endpoint from where you can get media files
Config.ImageDirectory = "resources/"..GetCurrentResourceName().."/images/"
Config.SoundDirectory = "resources/"..GetCurrentResourceName().."/sounds/"
Config.VideoDirectory = "resources/"..GetCurrentResourceName().."/videos/"
```

## Usage Instructions

### How to pass the Upload URL to an encrypted resource

`Config.ImageUploadURL = exports.FiveMMediaHost:getUploadServer()`

### Usage example with `screenshot-basic`

```lua
local imageUploadPromise = promise.new()

exports['screenshot-basic']:requestScreenshotUpload(Config.ImageUploadURL, 'image', { ['encoding'] = 'webp' }, function(uploadResponse) 
    if not uploadResponse then imageUploadPromise:resolve(nil) return

    local responseJson = json.decode(uploadResponse) 
    imageUploadPromise:resolve(responseJson and responseJson.attachments[1].proxy_url) 
end)

local uploadedImageUrl = Citizen.Await(imageUploadPromise)
```

### How to Upload Audio

In this repository I created, you can test how to send audio to the script:
https://github.com/GasparMPereira/HTML-Microphone-Recorder

### How to Upload Video

In this repository I created, you can test how to send video to the script:
https://github.com/GasparMPereira/HTML-Camera-Recorder

### How to pass the server's URL to a resource that needs it in text format

1. Copy your _Cfx.re_ server URL, from the server console
![cfx_re_domain](https://github.com/GasparMPereira/FiveMMediaHost/assets/71574610/e40eacfa-680c-4e6e-a3fa-e4759bae2025)
2. Paste it in your script as `https://your_cfx_re_domain/FiveMMediaHost/upload`
3. You can then get the images like so: `https://your_cfx_re_domain/FiveMMediaHost/media/your_media_file_id.extension`

## Contributions
Please submit an _Issue_, if you have any suggestions/bugs. And also a _Pull Request_ if you would like to contribute with some code.
All help is welcome!

_Copyright (C) 2024 - Gaspar Pereira_
