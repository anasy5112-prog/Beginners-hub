local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Fetch keys from Pastebin
local HttpService = game:GetService("HttpService")
local success, response = pcall(function()
    return game:HttpGet("https://pastebin.com/raw/nVYtFJec")
end)

local keys = {}
if success and response then
    for line in string.gmatch(response, "[^\r\n]+") do
        table.insert(keys, line)
    end
end

local Window = Rayfield:CreateWindow({
   Name = "🔰Beginners hub🔰",
   Icon = 0,
   LoadingTitle = "Loading The Script!",
   LoadingSubtitle = "by Javix",
   ShowText = "Rayfield",
   Theme = "Default",

   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = true, -- ✅ Enabled
   KeySettings = {
      Title = "🔰Beginners hub🔰 | Key",
      Subtitle = "Key System",
      Note = "Keys from Pastebin",
      FileName = "BeginnersHubKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = keys -- ✅ Uses your Pastebin keys
   }
})
