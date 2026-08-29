local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🔰Beginners hub🔰",
   Icon = 0,
   LoadingTitle = "Loading The Script",
   LoadingSubtitle = "by Javix",
   ShowText = "Rayfield",
   Theme = "Default",
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Beginners hub beta"
   },

   Discord = {
      Enabled = false,
      Invite = "nil",
      RememberJoins = true
   },

   KeySystem = false,
   KeySettings = {
      Title = "nil",
      Subtitle = "Key System",
      Note = "nil",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

local MiscTab = Window:CreateTab("Misc", 4483362458)

Rayfield:Notify({
   Title = "Executed",
   Content = "You Executed the script sucessfully",
   Duration = 6.5,
   Image = 4483362458,
})

local Toggle = MiscTab:CreateToggle({
   Name = "Infinite jump", -- FIXED
   CurrentValue = false,
   Flag = "Infinite?",
   Callback = function(Value)

      local Player = game.Players.LocalPlayer
      local UserInputService = game:GetService("UserInputService")

      UserInputService.JumpRequest:Connect(function()
          if Player.Character and Player.Character:FindFirstChild("Humanoid") then
              Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
          end
      end)

   end,
})
