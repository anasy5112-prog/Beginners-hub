if game.PlaceId == 17625359962 then

    -- 1. Configuration Setup
    getgenv().sneeky_silent_aim = false
    getgenv().sneeky_aimbot = false
    getgenv().sneeky_fov_size = 180 

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")

    -- 2. Visual FOV Screen Center Identifier
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

    -- 3. Universal Device Emulation Loop
    RunService.RenderStepped:Connect(function()
        local target = getClosestPlayerToCenter()
        if not target then return end

        -- Aimbot Tracking (Camera Lock)
        if getgenv().sneeky_aimbot then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), 0.15)
        end

        -- Silent Aim Tracking (Input Emulation Intercept)
        if getgenv().sneeky_silent_aim then
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or #UserInputService:GetFocusedTextBox() == 0 then
                pcall(function()
                    local oldIndex
                    oldIndex = hookmetamethod(game, "__index", function(self, index)
                        if self == LocalPlayer:GetMouse() and (index == "Hit" or index == "Target") and getgenv().sneeky_silent_aim then
                            if index == "Hit" then
                                return target.CFrame
                            elseif index == "Target" then
                                return target
                            end
                        end
                        return oldIndex(self, index)
                    end)
                end)
            end
        end
    end)

    -- 4. Initialize Official Rayfield Gen2 UI Library
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

    -- 6. Silent Aim UI Toggle (FIXED: Connected directly to CombatTab)
    CombatTab:CreateToggle({
        name = "Silent Aim",
        currentValue = false,
        callback = function(Value)
            getgenv().sneeky_silent_aim = Value
        end,
    })

    -- 7. Camera Aimbot UI Toggle (FIXED: Connected directly to CombatTab)
    CombatTab:CreateToggle({
        name = "Aimbot",
        currentValue = false,
        callback = function(Value)
            getgenv().sneeky_aimbot = Value
        end,
    })

end
