-- Cleanup old instances
local existing = game:GetService("CoreGui"):FindFirstChild("AutoSenderGui") or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("AutoSenderGui")
if existing then existing:Destroy() end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = game:GetService("Players").LocalPlayer
local updateRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Update")

-- GUI Creation
local screenGui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
screenGui.Name = "AutoSenderGui"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 260, 0, 130)
mainFrame.Position = UDim2.new(0.5, -130, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0

local textBox = Instance.new("TextBox", mainFrame)
textBox.Size = UDim2.new(0.9, 0, 0, 45)
textBox.Position = UDim2.new(0.05, 0, 0.1, 0)
textBox.PlaceholderText = "Enter message..."
textBox.Text = "" 
textBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
textBox.TextColor3 = Color3.new(1, 1, 1)
textBox.ClearTextOnFocus = false

local toggleBtn = Instance.new("TextButton", mainFrame)
toggleBtn.Size = UDim2.new(0.9, 0, 0, 45)
toggleBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
toggleBtn.Text = "START SPAM"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 0)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)

-- Logic
local active = false

toggleBtn.MouseButton1Click:Connect(function()
    active = not active
    
    if active then
        toggleBtn.Text = "STOP SPAM"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(140, 0, 0)
        
        task.spawn(function()
            while active do
                local input = textBox.Text
                if input ~= "" then
                    -- Wrap the text in <p> tags
                    local wrappedMessage = "<p>" .. input .. "</p>"
                    
                    -- Convert the string to a buffer
                    local data = buffer.fromstring(wrappedMessage)
                    
                    -- Fire it to the server
                    task.spawn(function()
                        updateRemote:InvokeServer(data)
                    end)
                end
                task.wait(0.1) -- Sends every 0.1 seconds
            end
        end)
    else
        toggleBtn.Text = "START SPAM"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 0)
    end
end)
