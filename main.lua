local http_request = (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request) or
                     (krnl and krnl.request) or (request) or (http_request) or (httpc and httpc.request) or
                     (game and game.HttpGet and function(tbl)
    return {
        Body = game:HttpGet(tbl.Url)
    }
end)

local httpService = game:GetService("HttpService")

if not _G.key or _G.key == "" then
    print("Key Error")
    return
end

local clientId = game:GetService("RbxAnalyticsService"):GetClientId()
if not clientId or clientId == "" then
    print("Client ID Error")
    return
end

if not http_request then
    print("HTTP request not found")
    return
end

local dataToSend = {
    key = _G.key,
    clientId = clientId
}

local successEncode, jsonBody = pcall(httpService.JSONEncode, httpService, dataToSend)
if not successEncode then
    print("Failed to encode JSON")
    return
else
    print("Encoded JSON:", jsonBody)
end

local success, response = pcall(function()
    return http_request({
        Url = "https://apikey-aw89.onrender.com/check-key",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json", 
            ["Accept"] = "application/json"
        },
        Body = jsonBody
    })
end)

if success and response and response.Body then
    local successDecode, jsonResponse = pcall(httpService.JSONDecode, httpService, response.Body)

    if successDecode and jsonResponse then
        local statusMessages = {
            ["ok"] = "Key ถูกต้อง",
            ["TimeOut"] = "คีย์หมดอายุแล้ว!",
            ["keynotfound"] = "ไม่พบคีย์!",
            ["keyinvalid"] = "Invalid key!",
            ["clientidinvalid"] = "Invalid client ID!",
            ["keyalreadyredeemed"] = "คีย์นี้ถูกใช้ไปแล้ว",
            ["servererror"] = "Server error occurred!"
        }

        local message = statusMessages[jsonResponse.status] or "Error: " .. (jsonResponse.message or "Unknown error")

        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "RIMURUHUB",
            Text = message,
            Duration = 5
        })

        if jsonResponse.status == "ok" and jsonResponse.script then
            loadstring(game:HttpGet(jsonResponse.script))()
			
        end
    else
        print("Failed to decode JSON: " .. (response.Body or "No data received"))
    end
else
    print("Request failed: " .. tostring(success))
end
