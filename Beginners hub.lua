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

   KeySystem = false,
   KeySettings = {
      Title = "🔰Beginners hub🔰 | Key",
      Subtitle = "Key System",
      Note = "Keys from Pastebin",
      FileName = "BeginnersHubKey",
      SaveKey = false,
      GrabKeyFromSite = false,
      Key = keys
   }
})

Rayfield:Notify({
   Title = "Executed!",
   Content = "You Executed The Script!",
   Duration = 6.5,
   Image = 4483362458,
})

-- Movement Tab
local MovementTab = Window:CreateTab("Main", 4483362458)

local walkSpeedValue = 16
local jumpPowerValue = 20

local Slider = MovementTab:CreateSlider({
   Name = "Walkspeed",
   Range = {0, 100},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "dasdafe",
   Callback = function(Value)
      walkSpeedValue = Value
      game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = Value
   end,
})

local Slider = MovementTab:CreateSlider({
   Name = "JumpPower",
   Range = {0, 250},
   Increment = 1,
   Suffix = "JumpPower",
   CurrentValue = 20,
   Flag = "bdgrgdergwdas",
   Callback = function(Value)
      jumpPowerValue = Value
      game.Players.LocalPlayer.Character:WaitForChild("Humanoid").JumpPower = Value
   end,
})

local Toggle = MovementTab:CreateToggle({
    Name = "Enable Walkspeed Config",
    CurrentValue = false,
    Flag = "grdfgdge",
    Callback = function(Value)
        local humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
        if Value then
            humanoid.WalkSpeed = 16
        else
            humanoid.WalkSpeed = walkSpeedValue
        end
    end,
})

local Slider = MovementTab:CreateSlider({
    Name = "Slide Multiplier",
    Range = {0, 100},
    Increment = 1,
    Suffix = "x",
    CurrentValue = 10,
    Flag = "rorfwgoefuyvwe",
    Callback = function(Value)
        local humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
        local baseSlideSpeed = humanoid.WalkSpeed
        local slideSpeed = baseSlideSpeed * Value
        humanoid.WalkSpeed = slideSpeed
        print("Slide multiplier set to:", Value, "→ Slide speed:", slideSpeed)
    end,
})

-- Combat Tab
local CombatTab = Window:CreateTab("Combat", 4483362458)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local silentAimActive = false

local Toggle = CombatTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Flag = "qsafeawe",
    Callback = function(Value)
        silentAimActive = Value
    end,
})

local function getNearestHead()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local closest, shortest = nil, math.huge
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

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and silentAimActive then
        local target = getNearestHead()
        if target and ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Attack") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            ReplicatedStorage.Remotes.Attack:FireServer(target)
        end
    end
end)

-- Visual Tab
local VisualTab = Window:CreateTab("Visual", 4483362458)

local RunService = game:GetService("RunService")
local espList = {}
local espActive = false

local Toggle = VisualTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Flag = "SBACOD",
    Callback = function(Value)
        espActive = Value
    end,
})

local function createESP(player)
    if player == LocalPlayer then return end
    local box = Drawing.new("Quad")
    box.Thickness = 2
    box.Color = Color3.fromRGB(0, 0, 255)
    box.Transparency = 1
    box.Visible = false
    espList[player] = {drawing = box}
    player.AncestryChanged:Connect(function()
        if not player:IsDescendantOf(game) and espList[player] then
            box:Remove()
            espList[player] = nil
        end
    end)
end

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

end