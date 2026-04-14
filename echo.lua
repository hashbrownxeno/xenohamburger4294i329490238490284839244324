--[[
    NIGHTFALL ELITE: SCRIPT HIERARCHY SCANNER
    Focuses only on finding the 'Brains' of the game.
--]]

local count = 0
print("--- [ STARTING SCRIPT-ONLY SCAN ] ---")

local function scan(parent)
    for _, v in pairs(parent:GetDescendants()) do
        if v:IsA("LocalScript") or v:IsA("ModuleScript") then
            count = count + 1
            print("-------------------------")
            print("NAME: " .. v.Name)
            print("TYPE: " .. v.ClassName)
            print("PATH: " .. v:GetFullName())
            
            -- Check if it has children (like those Remotes you mentioned)
            local children = v:GetChildren()
            if #children > 0 then
                print(" > HAS CHILDREN: " .. #children .. " objects inside.")
            end
        end
    end
end

-- Focus on where the most important scripts hide
scan(game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
scan(game:GetService("ReplicatedStorage"))
scan(game:GetService("StarterGui"))
scan(game:GetService("StarterPack"))

print("--- [ SCAN COMPLETE: " .. count .. " SCRIPTS FOUND ] ---")
