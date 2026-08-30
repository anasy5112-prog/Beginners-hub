if game.PlaceId == 17625359962 then

    -- 1. Configuration Setup
    getgenv().sneeky_blatant = false
    getgenv().sneeky_silent_aim = false
    getgenv().sneeky_aimbot = false
    getgenv().sneeky_fov_size = 300

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera

    -- 2. Localized Aim Processing Engine (Bypasses HTTP/DNS Network Lookups)
    local function getClosestPlayer()
        local closestTarget = nil
        local shortestDistance = getgenv().sneeky_fov_size

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and player.Character then
                local character = player.Character
                local head = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChildOfClass("Humanoid")

                if head and humanoid and humanoid.Health > 0 then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local mousePos = LocalPlayer:GetMouse()
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                        if distance < shortestDistance then
                            closestTarget = head
                            shortestDistance = distance
                        end
                    end
                end
            end
        end
        return closestTarget
    end

    -- Background runtime hooks
    local hookActive = false
    local function initializeCombatHooks()
        if hookActive then return end
        hookActive = true
        
        -- Camera Aimbot Tracking Loop
        game:GetService("RunService").RenderStepped:Connect(function()
            if getgenv().sneeky_blatant and getgenv().sneeky_aimbot then
                local target = getClosestPlayer()
                if target then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
                end
            end
        end)

        -- Silent Aim Bullet Manipulation Hook
        local namecall
        namecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}

            if tostring(method) == "FireServer" and getgenv().sneeky_blatant and getgenv().sneeky_silent_aim then
                local target = getClosestPlayer()
                if target then
                    -- Updates raycast position context arguments to force headshots
                    for i, arg in ipairs(args) do
                        if typeof(arg) == "Vector3" then
                            args[i] = target.Position
                            break
                        end
                    end
                end
            end
            return namecall(self, unpack(args))
        end)
    end

    -- 3. Initialize Rayfield UI Library (FIXED LINK BELOW)
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
            Title = "Nothing also",
            Subtitle = "Key System",
            Note = "Nothing",
            FileName = "Key",
            SaveKey = true,
            GrabKeyFromSite = false,
            Key = {"Hello"}
        }
    })

    -- 4. Tabs Setup
    local CombatTab = Window:CreateTab("Combat", 4483362458)

    Rayfield:Notify({
        Title = "Executed",
        Content = "You Executed the script successfully",
        Duration = 3.5,
        Image = 4483362458,
    })

    -- 5. Silent Aim UI Toggle
    local SilentAimToggle = CombatTab:CreateToggle({
        Name = "Silent Aim",
        CurrentValue = false,
        Flag = "SilentAimToggle",
        Callback = function(Value)
            getgenv().sneeky_silent_aim = Value
            getgenv().sneeky_blatant = (Value or getgenv().sneeky_aimbot)

            if Value then
                initializeCombatHooks()
            end
        end,
    })

    -- 6. Camera Aimbot UI Toggle
    local AimbotToggle = CombatTab:CreateToggle({
        Name = "Aimbot",
        CurrentValue = false,
        Flag = "A1mb0tToggle",
        Callback = function(Value)
            getgenv().sneeky_aimbot = Value
            getgenv().sneeky_blatant = (Value or getgenv().sneeky_silent_aim)
            
            if Value then 
                initializeCombatHooks()
            end
        end,
    })

end
