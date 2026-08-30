if game.PlaceId == 17625359962 then

    -- 1. Configuration Setup
    getgenv().sneeky_blatant = false
    getgenv().sneeky_silent_aim = false
    getgenv().sneeky_aimbot = false
    getgenv().sneeky_fov_size = 300

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera

    -- 2. Localized Aim Processing Engine
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

    -- 3. Initialize Rayfield Gen2 UI Library (Fixed the nil loading crash)
    local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

    local Window = Rayfield:CreateWindow({
        name = "🔰Beginners hub🔰",
        subtitle = "by Javix",
        theme = "Default"
    })

    -- 4. Tabs Setup (Updated to Gen2 dictionary format)
    local CombatTab = Window:CreateTab({
        name = "Combat",
        icon = 4483362458
    })

    -- 5. Silent Aim UI Toggle
    CombatTab:CreateToggle({
        name = "Silent Aim",
        currentValue = false,
        callback = function(Value)
            getgenv().sneeky_silent_aim = Value
            getgenv().sneeky_blatant = (Value or getgenv().sneeky_aimbot)

            if Value then
                initializeCombatHooks()
            end
        end,
    })

    -- 6. Camera Aimbot UI Toggle
    CombatTab:CreateToggle({
        name = "Aimbot",
        currentValue = false,
        callback = function(Value)
            getgenv().sneeky_aimbot = Value
            getgenv().sneeky_blatant = (Value or getgenv().sneeky_silent_aim)
            
            if Value then 
                initializeCombatHooks()
            end
        end,
    })

end