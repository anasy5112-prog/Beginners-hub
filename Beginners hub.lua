if game.PlaceId == 17625359962 then

    -- 1. Configuration Setup
    getgenv().sneeky_silent_aim = false
    getgenv().sneeky_aimbot = false
    getgenv().sneeky_fov_size = 150 

    local run_service = game:GetService("RunService")
    local players = game:GetService("Players")
    local camera = workspace.CurrentCamera

    local closest = nil

    -- 2. Fixed Target Finder (Uses Mobile Screen Center Instead of PC Mouse)
    local function get_closest_player()
        local closest_distance, player = math.huge, nil
        -- Finds the exact center point of your iOS screen
        local screen_center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

        for _, value in ipairs(players:GetPlayers()) do
            if value ~= local_player then
                local character = value.Character
                local root_part = character and character:FindFirstChild("HumanoidRootPart")
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    
                -- Ensure target is alive and valid
                if not root_part or (humanoid and humanoid.Health <= 0) then continue end

                local screen_position, visible = camera:WorldToViewportPoint(root_part.Position)
                -- Measures distance relative to the center of your mobile screen
                local distance = (Vector2.new(screen_position.X, screen_position.Y) - screen_center).Magnitude

                if not visible then continue end

                -- Enforce the custom interface FOV limit bubble
                if distance < closest_distance and distance <= getgenv().sneeky_fov_size then
                    player = value
                    closest_distance = distance
                end
            end
        end
        return player
    end

    -- Continuous loop tracking for target data
    run_service.RenderStepped:Connect(function()
        if getgenv().sneeky_silent_aim or getgenv().sneeky_aimbot then
            closest = get_closest_player()
        else
            closest = nil
        end

        -- Standard Camera Tracking (Aimbot Mode Logic)
        if getgenv().sneeky_aimbot and closest and closest.Character then
            local head = closest.Character:FindFirstChild("Head")
            if head then
                camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, head.Position), 0.12)
            end
        end
    end)

    -- 3. High-Security Game UI Module Interception (Your Script Core)
    local local_player = players.LocalPlayer
    local common_functions = require(local_player.PlayerGui.GameUI.ClientMaster.CommonFunctions)
    local old_func = common_functions.RayCast

    common_functions.RayCast = function(origin, direction, i_dont_know_what_this_is, idk_either_but_probably_ignore_list)
        if getgenv().sneeky_silent_aim and closest and closest.Character then
            local head = closest.Character:FindFirstChild("Head")
            if head then
                -- FIXED MATH: Pushes a proper normalized mathematical directional trajectory unit 
                local target_pos = head.Position
                local distance = (target_pos - origin).Magnitude
                direction = (target_pos - origin).Unit * distance
            end
        end
        return old_func(origin, direction, i_dont_know_what_this_is, idk_either_but_probably_ignore_list)
    end

    -- 4. Initialize Rayfield Gen2 UI Library
    local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

    local Window = Rayfield:CreateWindow({
        name = "🔰Beginners hub🔰",
        subtitle = "by Javix",
        theme = "Default",
        loading = true,
        loadingtitle = "Loading The Script",
        loadingsubtitle = "by Javix",
        configurationSaving = {
            enabled = true,
            folderName = "BeginnersHub",
            fileName = "config"
        }
    })

    -- 5. Tabs Setup (FIXED: Converted to Gen2 dictionary format)
    local CombatTab = Window:CreateTab({
        name = "Combat",
        icon = 4483362458
    })

    -- 6. Silent Aim UI Toggle (FIXED: Uses lowercase parameters for Gen2)
    CombatTab:CreateToggle({
        name = "Silent Aim",
        currentValue = false,
        callback = function(Value)
            getgenv().sneeky_silent_aim = Value
        end,
    })

    -- 7. Camera Aimbot UI Toggle (FIXED: Uses lowercase parameters for Gen2)
    CombatTab:CreateToggle({
        name = "Aimbot",
        currentValue = false,
        callback = function(Value)
            getgenv().sneeky_aimbot = Value
        end,
    })

end
