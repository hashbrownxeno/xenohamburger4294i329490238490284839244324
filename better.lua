--[[
    NIGHTFALL ELITE: VISIBLE REMOTE SCANNER
    Outputs to a custom GUI instead of the console.
--]]

local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
local frame = Instance.new("ScrollingFrame", sg)
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.CanvasSize = UDim2.new(0, 0, 10, 0)
frame.ScrollBarThickness = 8
frame.Active = true
frame.Draggable = true

local layout = Instance.new("UIListLayout", frame)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local function log(text, color)
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -10, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    lbl.Text = " " .. text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 14
end

log("--- SCANNING FOR REMOTES ---", Color3.fromRGB(255, 0, 0))

local count = 0
for _, v in pairs(game:GetDescendants()) do
    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
        count = count + 1
        local rColor = v:IsA("RemoteEvent") and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 200, 255)
        log(string.format("[%s] %s", v.ClassName:sub(7), v.Name), rColor)
        -- Shorten path so it fits the GUI
        local path = v.Parent and v.Parent.Name or "nil"
        log("   Parent: " .. path, Color3.fromRGB(150, 150, 150))
    end
end

log("--- SCAN COMPLETE: " .. count .. " FOUND ---", Color3.fromRGB(255, 0, 0))
