local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- UI (Same as before)
local ScreenGui = Instance.new("ScreenGui")
local KickButton = Instance.new("TextButton")
ScreenGui.Parent = game.CoreGui
KickButton.Parent = ScreenGui
KickButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
KickButton.Position = UDim2.new(0.7, 0, 0.5, 0)
KickButton.Size = UDim2.new(0, 100, 0, 100)
KickButton.Text = "DROPKICK"
KickButton.TextScaled = true
KickButton.Draggable = true

local function getNearest()
    local closest, dist = nil, 25
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
        
        -- 1. Lock your Y-axis (Prevents going up)
        local bg = Instance.new("BodyGyro")
        bg.Parent = root
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.CFrame = root.CFrame -- Keep you upright/tilted exactly as you are
        
        -- 2. Massive Spinning Force
        local bav = Instance.new("BodyAngularVelocity")
        bav.Parent = root
        bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bav.AngularVelocity = Vector3.new(0, 999999, 0)

        -- 3. The "Ghost" Phase
        for _, p in pairs(character:GetDestendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end

        -- 4. Execute the hit
        root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 1) -- Lunge into them
        task.wait(0.1) -- Very short hit window

        -- 5. THE FIX: Stop all movement instantly
        bav:Destroy()
        bg:Destroy()
        root.Velocity = Vector3.new(0, 0, 0)
        root.RotVelocity = Vector3.new(0, 0, 0)
        
        -- 6. Brief Anchor (This stops the "Heaven" trip)
        root.Anchored = true
        task.wait(0.1)
        root.Anchored = false
        
        -- Reset Collisions
        for _, p in pairs(character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
    end
end)
