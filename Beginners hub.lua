if game.PlaceID == 17625359962 then

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

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

   KeySystem = false, -- ✅ Enabled
   KeySettings = {
      Title = "🔰Beginners hub🔰 | Key",
      Subtitle = "Key System",
      Note = "Keys from Pastebin",
      FileName = "BeginnersHubKey",
      SaveKey = false,
      GrabKeyFromSite = false,
      Key = keys -- ✅ Uses your Pastebin keys
   }
})

Rayfield:Notify({
   Title = "Executed!",
   Content = "You Executed The Script!",
   Duration = 6.5,
   Image = 4483362458,
})

local MovementTab = Window:CreateTab("Main", 4483362458) -- Title, Image

local Slider = MovementTab:CreateSlider({
   Name = "Walkspeed",
   Range = {0, 100},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "dasdafe", -- A flag is the identifier for the configuration file; make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
    game.Players.LocalPlayer.Character.WaitForChild('Humanoid').WalkSpeed = (Value)
   end,
})

local Slider = MovementTab:CreateSlider({
   Name = "JumpPower",
   Range = {0, 250},
   Increment = 1,
   Suffix = "Jumpower",
   CurrentValue = 20,
   Flag = "bdgrgdergwdas", -- A flag is the identifier for the configuration file; make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value1)
    game.Players.LocalPlayer.Character.WaitForChild('Humanoid').JumpPower = (Value1)
   end,
})

local Toggle = MovementTab:CreateToggle({
    Name = "Enable Walkspeed Config",
    CurrentValue = false,
    Flag = "grdfgdge", -- unique flag so configs don't overlap
    Callback = function(Value)
        local humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
        if Value then
            humanoid.WalkSpeed = 16 -- if its on Walkspeed uses the default Walkspeed num which is 16
        else
            humanoid.WalkSpeed = (Value1) -- if the toggle is off then the Walkspeed will rely on the slider
        end
    end,
})

local Slider = MovementTab:CreateSlider({
    Name = "Slide Multiplier",
    Range = {0, 100}, -- min and max multiplier
    Increment = 1,    -- step size
    Suffix = "x",     -- shows multiplier suffix
    CurrentValue = 10,
    Flag = "rorfwgoefuyvwe", -- unique flag
    Callback = function(Value)
        local humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")

        -- Base slide speed is your WalkSpeed
        local baseSlideSpeed = humanoid.WalkSpeed

        -- Apply multiplier from slider
        local slideSpeed = baseSlideSpeed * Value

        -- Set the humanoid WalkSpeed to the new slide speed
        humanoid.WalkSpeed = slideSpeed

        print("Slide multiplier set to:", Value, "→ Slide speed:", slideSpeed)
    end,
})

local CombatTab = Window:CreateTab("Combat", 4483362458) -- Title, Image

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local silentAimActive = false -- global flag

local Toggle = CombatTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Flag = "qsafeawe", -- unique flag
    Callback = function(Value)
        silentAimActive = Value
    end,
})

-- Nearest Head
local function getNearestHead()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local closest = nil
    local shortest = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortest then
                shortest = dist
                closest = player
            end
        end
    end

    if closest and closest.Character and closest.Character:FindFirstChild("Head") then
        return closest.Character.Head
    end

    return nil
end

-- Silent Aim logic (only when toggle ON)
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and silentAimActive then
        local target = getNearestHead()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            ReplicatedStorage.Remotes.Attack:FireServer(target)
        end
    end
end)

local VisualTab = Window:CreateTab("Visual", 4483362458) -- Title, Image

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local espList = {}
local espActive = false -- global flag

-- Toggle
local Toggle = VisualTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Flag = "SBACOD", -- unique flag
    Callback = function(Value)
        espActive = Value
    end,
})

-- Setup ESP
local function createESP(player)
    if player == LocalPlayer then return end

    local box = Drawing.new("Quad")
    box.Thickness = 2
    box.Color = Color3.fromRGB(0, 0, 255)
    box.Transparency = 1
    box.Visible = false

    espList[player] = {
        drawing = box,
        connection = nil
    }

    player.AncestryChanged:Connect(function()
        if not player:IsDescendantOf(game) and espList[player] then
            box:Remove()
            espList[player] = nil
        end
    end)
end

-- Add ESP to all players
for _, player in pairs(Players:GetPlayers()) do
    createESP(player)
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(function(player)
    if espList[player] then
        espList[player].drawing:Remove()
        espList[player] = nil
    end
end)

-- Main ESP Loop
RunService.RenderStepped:Connect(function()
    for player, data in pairs(espList) do
        local box = data.drawing
        if espActive and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") then
            local root = player.Character.HumanoidRootPart
            local head = player.Character.Head

            local rootPos, onScreen1 = Camera:WorldToViewportPoint(root.Position)
            local headPos, onScreen2 = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))

            if onScreen1 and onScreen2 then
                box.PointA = Vector2.new(rootPos.X - 15, rootPos.Y + 30)
                box.PointB = Vector2.new(rootPos.X + 15, rootPos.Y + 30)
                box.PointC = Vector2.new(headPos.X + 15, headPos.Y)
                box.PointD = Vector2.new(headPos.X - 15, headPos.Y)
                box.Visible = true
            else
                box.Visible = false
            end
        else
            box.Visible = false
        end
    end
end)
