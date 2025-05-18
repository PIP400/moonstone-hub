local DiscordWebhook = "YOUR_WEBHOOK_URL_HERE" -- You'll need to replace this with your webhook URL

local function SendToDiscord(message)
    local data = {
        ["content"] = message,
        ["username"] = "Moonstone Hub",
        ["avatar_url"] = "https://raw.githubusercontent.com/PIP400/moonstone-hub/main/moonstone_icon.png"
    }
    
    local success, response = pcall(function()
        return game:HttpGet("https://discord.com/api/webhooks/" .. DiscordWebhook, {
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = game:GetService("HttpService"):JSONEncode(data)
        })
    end)
    
    if not success then
        warn("Failed to send Discord notification:", response)
    end
end

return SendToDiscord 