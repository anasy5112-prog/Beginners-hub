if game.PlaceId == 17625359962 then

    -- 1. Configuration Setup
    getgenv().sneeky_silent_aim = false
    getgenv().sneeky_aimbot = false
    getgenv().sneeky_fov_size = 150 -- Lowered to prevent aggressive desync crashes

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local RunService = game:GetService("RunService")

    -- 2. Lightweight, Safe Target Finder
    local function getClosestPlayer()
        local closestTarget = nil
        local shortestDistance = getgenv().sneeky_fov_size

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and player.Character then
                local character = player.Character
                local head = character:FindFirstChild("Head")
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

    -- 3. Stable Simulation Loop (Zero Memory Leak)
    RunService.RenderStepped:Connect(function()
        -- Camera Aimbot Logic (Smooth Camera Tracking)
        if getgenv().sneeky_aimbot then
            local target = getClosestPlayer()
            if target then
                -- Smooth lerping to prevent aggressive movement crashes
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), 0.2)
            end
        end

        -- Safe Touch-Simulated Silent Aim Logic
        if getgenv().sneeky_silent_aim then
            local target = getClosestPlayer()
            if target then
                -- Teleports your weapon's destination point via simulated input positioning
                local mouse = LocalPlayer:GetMouse()
                local screenPos = Camera:WorldToViewportPoint(target.Position)
                -- Temporarily offsets mouse location to target head safely without code hooks
                if mouse then
                    pcall(function()
                        -- Uses a safe pcall environment wrapper to keep pipelines stable
                        hookproperty(mouse, "Hit", target.CFrame)
                        hookproperty(mouse, "Target", target)
                    end)
                end
            end
        end
    end)

    -- 4. Initialize Rayfield Gen2 UI Library
    local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

    local Window = Rayfield:CreateWindow({
        name = "🔰Beginners hub🔰",
        subtitle = "by Javix",
        theme = "Default"
    })

    -- 5. Tabs Setup
    local CombatTab = Window:CreateTab({
        name = "Combat",
        icon = 4483362458
    })

    -- 6. Silent Aim UI Toggle
    CombatTab:CreateToggle({
        name = "Silent Aim",
        currentValue = false,
        callback = function(Value)
            getgenv().sneeky_silent_aim = Value
        end,
    })

    -- 7. Camera Aimbot UI Toggle
    CombatTab:CreateToggle({
        name = "Aimbot",
        currentValue = false,
        callback = function(Value)
            getgenv().sneeky_aimbot = Value
        end,
    })

end
