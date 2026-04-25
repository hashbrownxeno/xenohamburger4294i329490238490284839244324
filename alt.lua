local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local torso = char:WaitForChild("Torso")

-- Create UI
local sg = Instance.new("ScreenGui", game.CoreGui)
local openBtn = Instance.new("TextButton", sg)
openBtn.Size = UDim2.new(0, 80, 0, 80)
openBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
openBtn.Text = "EMOTES"
openBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Draggable = true

local wheelFrame = Instance.new("Frame", sg)
wheelFrame.Size = UDim2.new(0, 300, 0, 300)
wheelFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
wheelFrame.BackgroundTransparency = 1
wheelFrame.Visible = false

-- Function to make joints move like a "Monster"
local activeEmote = false
local function stopEmotes()
    activeEmote = false
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("Motor6D") then
            v.Transform = CFrame.new() -- Reset limbs
        end
    end
end

local function monsterMash()
    activeEmote = true
    while activeEmote do
        local t = tick()
        -- Zombie arm reach + wobble
        char.Torso["Right Shoulder"].Transform = CFrame.Angles(math.rad(90) + math.sin(t*5)*0.2, 0, 0)
        char.Torso["Left Shoulder"].Transform = CFrame.Angles(math.rad(90) + math.cos(t*5)*0.2, 0, 0)
        -- Leg kick
        char.Torso["Right Hip"].Transform = CFrame.Angles(0, 0, math.sin(t*10)*0.5)
        char.Torso["Left Hip"].Transform = CFrame.Angles(0, 0, math.cos(t*10)*0.5)
        task.wait()
    end
end

-- Wheel Buttons
local emotes = {
    {Name = "Monster Mash", Func = monsterMash},
    {Name = "Stop", Func = stopEmotes}
}

for i, data in pairs(emotes) do
    local btn = Instance.new("TextButton", wheelFrame)
    btn.Size = UDim2.new(0, 100, 0, 100)
    -- Arrange in a circle
    local angle = (i / #emotes) * math.pi * 2
    btn.Position = UDim2.new(0.5 + math.cos(angle)*0.4, -50, 0.5 + math.sin(angle)*0.4, -50)
    btn.Text = data.Name
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1,1,1)
    
    btn.MouseButton1Click:Connect(function()
        stopEmotes()
        wheelFrame.Visible = false
        task.spawn(data.Func)
    end)
end

openBtn.MouseButton1Click:Connect(function()
    wheelFrame.Visible = not wheelFrame.Visible
end)
