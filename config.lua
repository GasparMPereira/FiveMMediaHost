Config = {}
Config.ServerHost = "https://"..GetConvar("web_baseUrl", "").."/"..GetCurrentResourceName() --// Use CFX.re domain of your server
--Config.ServerHost = "http://127.0.0.1:30120/"..GetCurrentResourceName() --// OR you can replace with your custom domain name/IP address
Config.IDLength = 30 --// Image name length
Config.ImageDirectory = "resources/[phone]/"..GetCurrentResourceName().."/images/"
