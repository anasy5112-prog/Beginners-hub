if game.PlaceId == 17625359962 then

    -- 1. Configuration Setup
    getgenv().sneeky_blatant = false
    getgenv().sneeky_silent_aim = false
    getgenv().sneeky_aimbot = false
    getgenv().sneeky_fov_size = 300

    local scriptLoaded = false

    -- Centralized fallback loader (Fixes 404 error)
    local function safeLoadScript()
        if not scriptLoaded then
            scriptLoaded = true
            task.spawn(function()
                loadstring(game:HttpGet("https://githubusercontent.com"))()
            end)
        end
    end

    -- 2. Initialize Rayfield UI Library
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

    -- 3. Tabs & Notifications
    local CombatTab = Window:CreateTab("Combat", 4483362458)

    Rayfield:Notify({
        Title = "Executed",
        Content = "You Executed the script successfully",
        Duration = 3.5,
        Image = 4483362458,
    })

    -- 4. Silent Aim UI Toggle
    local SilentAimToggle = CombatTab:CreateToggle({
        Name = "Silent Aim",
        CurrentValue = false,
        Flag = "SilentAimToggle",
        Callback = function(Value)
            getgenv().sneeky_silent_aim = Value
            getgenv().sneeky_blatant = (Value or getgenv().sneeky_aimbot)

            if Value then
                safeLoadScript()
            end
        end,
    })

    -- 5. Camera Aimbot UI Toggle
    local AimbotToggle = CombatTab:CreateToggle({
        Name = "Aimbot",
        CurrentValue = false,
        Flag = "A1mb0tToggle",
        Callback = function(Value)
            getgenv().sneeky_aimbot = Value
            getgenv().sneeky_blatant = (Value or getgenv().sneeky_silent_aim)
            
            if Value then 
                safeLoadScript()
            end
        end,
    })

end -- FIXED: Closed the game.PlaceId if statement properly
