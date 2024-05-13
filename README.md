# FiveMImageHost
Image hosting for FiveM servers

# Example of usage with screenshot-basic
```
exports['screenshot-basic']:requestScreenshotUpload(Config.ImageUploadURL, 'image', {['encoding'] = 'webp'}, function(img)
  if(img)then
  local json = json.decode(img)
    found:resolve(json.attachments[1].proxy_url)
  else
    found:resolve(nil)
  end
end)
```
