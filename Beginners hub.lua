if game.PlaceId == 17625359962 then

    -- 1. Configuration Setup
    getgenv().sneeky_silent_aim = false
    getgenv().sneeky_aimbot = false
    getgenv().sneeky_fov_size = 180 

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local RunService = game:GetService("RunService")

    -- 2. Visual FOV Screen Center Target Identifier
    local function getClosestPlayerToCenter()
        local closestTarget = nil
        local shortestDistance = getgenv().sneeky_fov_size
        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and player.Character then
                local character = player.Character
                local head = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChildOfClass("Humanoid")

                if head and humanoid and humanoid.Health > 0 then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
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

    -- 3. Core Raycast Hook Interception (Fixes Silent Aim Missing)
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        -- Intercepts workspace calculations for finding hit paths
        if (method == "Raycast" or method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay") and getgenv().sneeky_silent_aim then
            local target = getClosestPlayerToCenter()
            if target then
                -- Re-routes the mathematical path vector to hit the target's head precisely
                if method == "Raycast" and typeof(args[1]) == "Vector3" and typeof(args[2]) == "Vector3" then
                    local origin = args[1]
                    args[2] = (target.Position - origin).Unit * 1000 -- Forces bullet length redirection
                end
            end
        end
        return oldNamecall(self, unpack(args))
    end)

    -- 4. Traditional Camera Aimbot Loop
    RunService.RenderStepped:Connect(function()
        if getgenv().sneeky_aimbot then
            local target = getClosestPlayerToCenter()
            if target then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), 0.15)
            end
        end
    end)

    -- 5. Initialize Rayfield Gen2 UI Library
    local Rayfield = loadstring(game:HttpGet("https://sirius.menu"))()

    local Window = Rayfield:CreateWindow({
        name = "🔰Beginners hub🔰",
        subtitle = "by Javix",
        theme = "Default"
    })

    -- 6. Tabs Setup
    local CombatTab = Window:CreateTab({
        name = "Combat",
        icon = 4483362458
    })

    -- 7. Silent Aim UI Toggle
    CombatTab:CreateToggle({
        name = "Silent Aim",
        currentValue = false,
        callback = function(Value)
            getgenv().sneeky_silent_aim = Value
        end,
    })

    -- 8. Camera Aimbot UI Toggle
    CombatTab:CreateToggle({
        name = "Aimbot",
        currentValue = false,
        callback = function(Value)
            getgenv().sneeky_aimbot = Value
        end,
    })

end
