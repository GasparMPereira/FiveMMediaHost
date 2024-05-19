Config = {}
Config.UseCFXReDomain = true --// Use CFX.re domain of your server? TRUE RECOMMENDED
Config.ServerHost = "http://127.0.0.1:30120/"..GetCurrentResourceName() --// OR you can replace with your custom domain name/IP address
Config.IDLength = 30 --// Image name length
Config.MediaEndpoint = 'media' --//
Config.ImageDirectory = "resources/"..GetCurrentResourceName().."/images/" --//
Config.SoundDirectory = "resources/"..GetCurrentResourceName().."/sounds/" --//
Config.VideoDirectory = "resources/"..GetCurrentResourceName().."/videos/" --//
