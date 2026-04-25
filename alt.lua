local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- UI 
local ScreenGui = Instance.new("ScreenGui")
local KickButton = Instance.new("TextButton")
ScreenGui.Parent = game.CoreGui
KickButton.Parent = ScreenGui
KickButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green for "Go"
KickButton.Position = UDim2.new(0.7, 0, 0.5, 0)
KickButton.Size = UDim2.new(0, 100, 0, 100)
KickButton.Text = "FLING KICK"
KickButton.TextScaled = true
KickButton.Draggable = true

-- The "Netless" Fix: This helps bypass some FE protections
local function setNetless(part)
    part.Velocity = Vector3.new(0, -30, 0) -- Constant slight downward force tricks the server
end

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
        
        -- 1. Create a "Thrust" instead of just Angular Velocity
        local thrust = Instance.new("BodyThrust")
        thrust.Parent = root
        thrust.Force = Vector3.new(9999, 9999, 9999) -- Extreme raw force
        thrust.Location = Vector3.new(0, 0, 5) -- Offset makes you "wobble" into them, causing a fling

        -- 2. Make yourself non-collidable so you don't fly too
        for _, p in pairs(character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end

        -- 3. The "Dropkick" Lunge
        root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 1.2)
        
        -- 4. Netless Loop (Briefly)
        local connection
        connection = game:GetService("RunService").Heartbeat:Connect(function()
            setNetless(root)
        end)

        task.wait(0.15) -- Speed is key

        -- 5. Cleanup
        connection:Disconnect()
        thrust:Destroy()
        root.Velocity = Vector3.new(0,0,0)
        root.Anchored = true -- Instant stop
        task.wait(0.05)
        root.Anchored = false

        for _, p in pairs(character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
    end
end)
