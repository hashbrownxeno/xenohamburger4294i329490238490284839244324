-- [[ XENO RIVALS ELITE SUITE ]] --
-- Repository: hashbrownxeno/Xeno-Hub
-- Version: 1.0.4

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- // CONFIGURATION
local Settings = {
    AimbotEnabled = true,
    AimPart = "Head", -- Options: "Head", "UpperTorso", "HumanoidRootPart"
    FOV = 120,
    FOVVisible = true,
    AimAssistStrength = 0.35, -- Lower is smoother/more legit
    ESPEnabled = true,
    InfJumpEnabled = true,
    TeamCheck = true, -- Don't lock onto teammates
    ThemeColor = Color3.fromRGB(255, 165, 0) -- Xeno Amber
}

-- // FOV CIRCLE SETUP
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Settings.ThemeColor
FOVCircle.Filled = false
FOVCircle.Transparency = 0.8
FOVCircle.Visible = Settings.FOVVisible

-- // CORE FUNCTIONS
local function getClosestPlayer()
    local target = nil
    local shortestDistance = Settings.FOV
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(Settings.AimPart) then
            -- Team Check Logic
            if Settings.TeamCheck and v.Team == LocalPlayer.Team then continue end
            
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character[Settings.AimPart].Position)
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                
                if distance < shortestDistance then
                    shortestDistance = distance
                    target = v
                end
            end
        end
    end
    return target
end

-- // ESP HANDLER
local function CreateESP(player)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Settings.ThemeColor
    box.Thickness = 1
    box.Transparency = 0.9

    local function update()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and Settings.ESPEnabled then
                local rootPart = player.Character.HumanoidRootPart
                local head = player.Character:FindFirstChild("Head")
                
                if head then
                    local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                    local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    local legPos = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))

                    if onScreen then
                        box.Size = Vector2.new(2500 / rootPos.Z, headPos.Y - legPos.Y)
                        box.Position = Vector2.new(rootPos.X - box.Size.X / 2, rootPos.Y - box.Size.Y / 2)
                        box.Visible = true
                    else
                        box.Visible = false
                    end
                end
            else
                box.Visible = false
                if not player or not player.Parent then
                    box:Remove()
                    connection:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(update)()
end

-- // RUNTIME LOOPS
RunService.RenderStepped:Connect(function()
    -- Sync FOV Circle
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Radius = Settings.FOV
    
    -- Aimbot Execution
    if Settings.AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(Settings.AimPart) then
            local aimPos = target.Character[Settings.AimPart].Position
            local targetCFrame = CFrame.new(Camera.CFrame.Position, aimPos)
            -- Smooth Aim Assist Lerp
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Settings.AimAssistStrength)
        end
    end
end)

-- // INFINITE JUMP
UserInputService.JumpRequest:Connect(function()
    if Settings.InfJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- // INITIALIZE ESP
for _, v in pairs(Players:GetPlayers()) do
    if v ~= LocalPlayer then CreateESP(v) end
end
Players.PlayerAdded:Connect(CreateESP)

print("--- [ XENO RIVALS ELITE LOADED ] ---")
