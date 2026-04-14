-- NIGHTFALL ELITE: REPLICATED STORAGE DEEP SCAN
local rs = game:GetService("ReplicatedStorage")
print("--- [ REPLICATED STORAGE SCAN ] ---")

local function scan(folder)
    for _, obj in pairs(folder:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            print("Name: " .. obj.Name .. " | Path: " .. obj:GetFullName())
            
            -- This part tries to find if there's a script calling it
            local s, e = pcall(function()
                if obj:IsA("RemoteEvent") then
                    print(" > Type: RemoteEvent")
                else
                    print(" > Type: RemoteFunction")
                end
            end)
        end
    end
end

scan(rs)
print("--- [ SCAN FINISHED ] ---")
