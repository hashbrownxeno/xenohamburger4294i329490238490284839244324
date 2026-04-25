local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
local KickButton = Instance.new("TextButton")
ScreenGui.Parent = game.CoreGui
KickButton.Parent = ScreenGui
KickButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
KickButton.Position = UDim2.new(0.7, 0, 0.5, 0)
KickButton.Size = UDim2.new(0, 100, 0, 100)
KickButton.Text = "DROPKICK"
KickButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KickButton.TextScaled = true
KickButton.Draggable = true

local function getNearest()
    local closest, dist = nil, 20
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local d = (v.Character.HumanoidRootPart.Position - root.Position).Magnitude
            if d < dist then
                dist = d
                closest = v
            end
        end
    end
    return closest
end

KickButton.MouseButton1Click:Connect(function()
    local target = getNearest()
    if target and target.Character:FindFirstChild("HumanoidRootPart") then
        local targetRoot = target.Character.HumanoidRootPart
        
        -- 1. Preparation: Make yourself "Ghost-like"
        local parts = {}
        for _, p in pairs(character:GetDescendants()) do
            if p:IsA("BasePart") then
                parts[p] = {p.CanCollide, p.Massless} -- Save original settings
                p.CanCollide = false
                p.Massless = true
            end
        end

        -- 2. Create the Fling Force
        local velocity = Instance.new("BodyAngularVelocity")
        velocity.Name = "FlingForce"
        velocity.Parent = root
        velocity.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        velocity.AngularVelocity = Vector3.new(0, 999999, 0) -- THE SPIN
        
        -- 3. The Lunge (CFrame toward target)
        root.CFrame = CFrame.new(root.Position, targetRoot.Position) * CFrame.Angles(math.rad(-90), 0, 0)
        root.Velocity = (targetRoot.Position - root.Position).Unit * 150 -- Speed boost

        task.wait(0.25) -- Hold the kick briefly

        -- 4. Cleanup: Reset everything
        velocity:Destroy()
        for p, settings in pairs(parts) do
            if p and p.Parent then
                p.CanCollide = settings[1]
                p.Massless = settings[2]
            end
        end
        
        -- Stop your momentum so you don't keep drifting
        root.Velocity = Vector3.new(0, 0, 0)
        root.RotVelocity = Vector3.new(0, 0, 0)
    end
end)
