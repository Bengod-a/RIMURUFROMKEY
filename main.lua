local http_request = http_request or request
local httpService = game:GetService("HttpService")

local clientId = game:GetService("RbxAnalyticsService"):GetClientId() or tostring(game:GetService("Players").LocalPlayer.UserId)

local dataToSend = {
    key = getgenv().key,
    clientId = clientId
}

local response = http_request({
    Url = "https://apikey-aw89.onrender.com/check-key",
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = httpService:JSONEncode(dataToSend)
})

local jsonResponse = httpService:JSONDecode(response.Body)

if jsonResponse.status == "ok" then
loadstring(game:HttpGet("https://raw.githubusercontent.com/Bengod-a/RIMURUHUB-NOKEY/refs/heads/main/main.lua"))()   
elseif jsonResponse.status == "TimeOut" then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "RIMURUHUB",
        Text = "Key ไม่ถูกต้องหรือหมดอายุ!",
        Duration = 5
    })
end


