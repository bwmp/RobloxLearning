local SolarisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Oli-idk/RobloxLearning/main/Scripts/UILib2.lua"))()
local WorkSpace = game:GetService("Workspace");
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;

local win = SolarisLib:New({
    Name = "Mic Up",
    FolderToSave = "MicUp"
})

local stalls = game:GetService("Workspace").Stalls

local stall1 = stalls.Stall3
local stall2 = stalls.Stall2
local stall3 = stalls.Stall1
local stall4 = stalls.Stall5
local stall5 = stalls.Stall4

local CurrentStall = stall1

local Main = win:Tab("Main")
local Stalls = win:Tab("Stalls")
local Settings = win:Tab("Settings")
local Movement = win:Tab("Movement")

local RandomSection = Main:Section("Random")
local FlipsSection = Movement:Section("Flips")
local MemeSection = Movement:Section("Memes")
local StallsSection = Stalls:Section("Stalls")

-- bools
local tripped = false
--end bools

StallsSection:Dropdown("Selected Stall", {"Stall 1","Stall 2","Stall 3","Stall 4","Stall 5"},"Stall 1","Dropdown", function(t)
    if t == "Stall 1" then
        CurrentStall = stall1
    elseif t == "Stall 2" then
        CurrentStall = stall2
    elseif t == "Stall 3" then
        CurrentStall = stall3
    elseif t == "Stall 4" then
        CurrentStall = stall4
    elseif t == "Stall 5" then
        CurrentStall = stall5
    end
end)

StallsSection:Button("Teleport To Stall", function()
    LocalPlayer.Character:MoveTo(CurrentStall.ProxPart.Position)
end)

StallsSection:Button("Claim Stall", function()
    for i, v in pairs(stalls:GetChildren()) do
        v.CloseStall:FireServer()
    end
    LocalPlayer.Character:MoveTo(CurrentStall.ProxPart.Position)
    fireproximityprompt(CurrentStall.ProxPart.ProximityPrompt)
end)

StallsSection:Button("Close All Stalls", function()
    for i, v in pairs(stalls:GetChildren()) do
        v.CloseStall:FireServer()
        LocalPlayer.Character:MoveTo(v.ProxPart.Position)
        wait(0.5)
        fireproximityprompt(v.ProxPart.ProximityPrompt)
        v.CloseStall:FireServer()
        wait(0.5)
    end
end)

FlipsSection:Bind("Front Flip", Enum.KeyCode.X, false, "BindNormal", function()
    Frontflip()
end)
FlipsSection:Bind("Back Flip", Enum.KeyCode.Z, false, "BindNormal", function()
    Backflip()
end)
FlipsSection:Bind("Left Flip", Enum.KeyCode.C, false, "BindNormal", function()
    Leftflip()
end)
FlipsSection:Bind("Right Flip", Enum.KeyCode.V, false, "BindNormal", function()
    Rightflip()
end)
FlipsSection:Bind("Left Twirl", Enum.KeyCode.B, false, "BindNormal", function()
    LeftTwirl()
end)
FlipsSection:Bind("Right Twirl", Enum.KeyCode.N, false, "BindNormal", function()
    RightTwirl()
end)

MemeSection:Bind("Trip", Enum.KeyCode.M, false, "BindNormal", function()
    Trip()
end)

--Flip Funcs
function Frontflip()
    LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    wait()
    LocalPlayer.Character.Humanoid.Sit = true
    for i = 1,360 do 
        delay(i/720,function()
        LocalPlayer.Character.Humanoid.Sit = true
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(-0.0174533,0,0)
        end)
    end
    wait(0.55)
    LocalPlayer.Character.Humanoid.Sit = false
end
function Backflip()
    LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    wait()
    LocalPlayer.Character.Humanoid.Sit = true
    for i = 1,360 do
        delay(i/720,function()
        LocalPlayer.Character.Humanoid.Sit = true
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0.0174533,0,0)
        end)
    end
    wait(0.55)
    LocalPlayer.Character.Humanoid.Sit = false
end
function Leftflip()
    LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    wait()
    LocalPlayer.Character.Humanoid.Sit = true
    for i = 1,360 do
        delay(i/720,function()
        LocalPlayer.Character.Humanoid.Sit = true
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0,0,0.0174533)
        end)
    end
    wait(0.55)
    LocalPlayer.Character.Humanoid.Sit = false
end
function Rightflip()
    LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    wait()
    LocalPlayer.Character.Humanoid.Sit = true
    for i = 1,360 do
        delay(i/720,function()
        LocalPlayer.Character.Humanoid.Sit = true
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0,0,-0.0174533)
        end)
    end
    wait(0.55)
    LocalPlayer.Character.Humanoid.Sit = false
end
function LeftTwirl()
    LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    wait()
    LocalPlayer.Character.Humanoid.Sit = true
    for i = 1,360 do
        delay(i/720,function()
        LocalPlayer.Character.Humanoid.Sit = true
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0,0.0174533,0)
        end)
    end
    wait(0.55)
    LocalPlayer.Character.Humanoid.Sit = false
end
function RightTwirl()
    LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    wait()
    LocalPlayer.Character.Humanoid.Sit = true
    for i = 1,360 do
        delay(i/720,function()
        LocalPlayer.Character.Humanoid.Sit = true
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0,-0.0174533,0)
        end)
    end
    wait(0.55)
    LocalPlayer.Character.Humanoid.Sit = false
end
--end Flip Funcs
--Meme Movement Funcs
function Trip()
    if(tripped) then
        tripped = false
        LocalPlayer.Character.Humanoid.PlatformStand = false
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(90,0,0)
    else
        tripped = true
        LocalPlayer.Character.Humanoid.PlatformStand = true
        for i = 1,90 do 
            delay(i/720,function()
                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(-0.0174533,0,0)
            end)
        end
    end
end