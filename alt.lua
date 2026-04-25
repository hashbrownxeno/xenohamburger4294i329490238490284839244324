local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- Create the Mobile Button
local ScreenGui = Instance.new("ScreenGui")
local KickButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui -- Puts it over the game UI
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

KickButton.Name = "KickButton"
KickButton.Parent = ScreenGui
KickButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
KickButton.Position = UDim2.new(0.7, 0, 0.5, 0) -- Right side of screen
KickButton.Size = UDim2.new(0, 100, 0, 100)
KickButton.Text = "DROPKICK"
KickButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KickButton.TextScaled = true
KickButton.Draggable = true -- You can move it if it's in the way

-- Function to find nearest player
local function getNearest()
    local closest, dist = nil, 25 -- Range
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

-- The Action
KickButton.MouseButton1Click:Connect(function()
    local target = getNearest()
    if target and target.Character:FindFirstChild("HumanoidRootPart") then
        local targetRoot = target.Character.HumanoidRootPart
        
        -- Create the Fling Force
        local velocity = Instance.new("BodyAngularVelocity")
        velocity.Name = "FlingForce"
        velocity.Parent = root
        velocity.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        velocity.AngularVelocity = Vector3.new(0, 999999, 0)
        
        -- Mock Animation: Tilt character forward and lunge
        local originalCFrame = root.CFrame
        root.CFrame = CFrame.new(root.Position, targetRoot.Position) * CFrame.Angles(math.rad(-45), 0, 0)
        
        -- Lunge at target
        root.Velocity = (targetRoot.Position - root.Position).Unit * 100
        
        -- Disable collisions to pass through and fling
        for _, p in pairs(character:GetChildren()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end

        task.wait(0.3) -- Kick duration

        -- Clean up
        velocity:Destroy()
        for _, p in pairs(character:GetChildren()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
    end
end)
