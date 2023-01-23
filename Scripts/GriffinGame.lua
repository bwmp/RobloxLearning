---@diagnostic disable: undefined-global
local player = game.Players.LocalPlayer
local VU = game:GetService("VirtualUser")
local Codes = player.Data.Codes
local codesToClaim = {"30klikes", "40klikes", "50klikes", "happychinesenewyear"}
local http = game:GetService("HttpService")
local RedeemCodeRemote = game:GetService("ReplicatedStorage").Remotes.RedeemCodeRemote
local RewardsClient = require(game:GetService("ReplicatedStorage")["_replicationFolder"].RewardsClient);
local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Oli-idk/RobloxLearning/main/Scripts/UILib.lua'))()

local Window = library:CreateWindow("Griffins Destiny", "1.0.0", 10044538000)

local MainTab = Window:CreateTab("Main")

local AutoPage = MainTab:CreateFrame("Automation")
local SettingPage = MainTab:CreateFrame("Settings")
local ClaimCodesBool = false
local AutoDigBool = false
local AutoClaimBool = false

function claimCodes()
    for _, code in pairs(codesToClaim) do
        RedeemCodeRemote:InvokeServer(code)
        wait(1)
    end
end

AntiAFK = AutoPage:CreateToggle("Anti AFK", "Prevent being kicked for being AFK", function(arg)
    if(arg == true) then
        AntiAFK:UpdateToggle("Anti AFK Enabled", "Prevent being kicked for being AFK")
        player.Idled:Connect(function()
            VU:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            wait(1)
            VU:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end)
    else
        AntiAFK:UpdateToggle("Anti AFK", "Prevent being kicked for being AFK")
    end
end)

ClaimCodes = AutoPage:CreateToggle("Claim Codes", "Start claiming codes", function(arg)
    if(arg == true) then
        ClaimCodes:UpdateToggle("Claiming Codes", "Stop claiming codes")
        ClaimCodesBool = true
        autoClaimCodes()
    else
        ClaimCodes:UpdateToggle("Claim Codes", "Start claiming codes")
        ClaimCodesBool = false
    end
end)

function autoClaimCodes()
    while ClaimCodesBool do
        Codes:ClearAllChildren()
        wait(1)
        claimCodes()
    end
end

AutoDig = AutoPage:CreateToggle("Auto Dig", "Automatically do treasure hunt minigame", function(arg)
    if(arg == true) then
        AutoDig:UpdateToggle("Auto Digging", "Stop automatically doing treasure hunt minigame")
        AutoDigBool = true
        autoDig()
    else
        AutoDig:UpdateToggle("Auto Dig", "Automatically do treasure hunt minigame")
        AutoDigBool = false
    end
end)

function autoDig()
    while AutoDigBool do
        for _, treasureModel in ipairs(game:GetService("Workspace").Interactions.Minigames.TreasureHunt:GetChildren()) do
            if(AutoDigBool == false) then
                break
            end
            if treasureModel.Name == "TreasureModel" then
                local time = 0;
                local time2 = 0;
                player.Character:MoveTo(treasureModel.Position)
                wait(0.5)
                local proximityPrompt = treasureModel:WaitForChild("ProximityPrompt")
                proximityPrompt:InputHoldBegin()
                proximityPrompt:InputHoldEnd()
                while (#treasureModel:GetChildren() > 0) do
                    if(time > 10)then
                        player.Character:MoveTo(treasureModel.Position)
                        time = 0;
                        wait(0.5)
                        proximityPrompt:InputHoldBegin()
                        proximityPrompt:InputHoldEnd()
                    end
                    time += 0.1
                    wait(0.1)
                end
                while player.PlayerGui.RewardsGui.RewardsFrame.ClaimButton.Visible == false do
                    if(time > 10)then
                        break
                    end
                    time += 0.1
                    wait(0.1)
                end
                for _, child in ipairs(player.PlayerGui.RewardsGui.RewardsFrame.SingleFrame:GetChildren()) do
                    if(child.name == "UIListLayout") then
                        continue
                    else
                        if(child.Visible) then
                            if(child.Name == "Item") then
                                logItem(child)
                            end
                        end
                    end
                end
                RewardsClient.Stop()
            end
        end
    end
end

AutoClaimReward = AutoPage:CreateToggle("Auto Claim Reward", "Automatically claim reward after treasure hunt minigame", function(arg)
    if(arg == true) then
        AutoClaimReward:UpdateToggle("Auto Claiming Reward", "Stop automatically claiming reward after treasure hunt minigame")
        AutoClaimBool = true
        autoClaimReward()
    else
        AutoClaimReward:UpdateToggle("Auto Claim Reward", "Automatically claim reward after treasure hunt minigame")
        AutoClaimBool = false
    end
end)

function autoClaimReward()
    while AutoClaimBool == true do
        if(player.PlayerGui.RewardsGui.RewardsFrame.Visible == true) then
            RewardsClient.Stop()
        end
        wait(0.1)
    end
end

DisableTreasureCollision = SettingPage:CreateToggle("Disable Treasure Collision", "Disable collision on treasure models", function(arg)
    if(arg == true) then
        DisableTreasureCollision:UpdateToggle("Treasure Collision Disabled", "Enable collision on treasure models")
        game:GetService("ReplicatedStorage")["_replicationFolder"].TreasureHuntClient.TreasureModel.CanCollide = false
        for _, treasureModel in ipairs(game:GetService("Workspace").Interactions.Minigames.TreasureHunt:GetChildren()) do
            if treasureModel.Name == "TreasureModel" then
                treasureModel.CanCollide = false
            end
        end
    else
        DisableTreasureCollision:UpdateToggle("Disable Treasure Collision", "Disable collision on treasure models")
        game:GetService("ReplicatedStorage")["_replicationFolder"].TreasureHuntClient.TreasureModel.CanCollide = false
        for _, treasureModel in ipairs(game:GetService("Workspace").Interactions.Minigames.TreasureHunt:GetChildren()) do
            if treasureModel.Name == "TreasureModel" then
                treasureModel.CanCollide = true
            end
        end
    end
end)

function logItem(Item)
    local msg = ""
    local Color
    local url
    local rarity = Item.RarityLabel.Text
    if(rarity == "Common") then
        Color = 0xFFFFFF
        msg = "Common Item Found!"
        url = getgenv().commonURL
    elseif(rarity == "Uncommon") then
        Color = 0x00FF00
        msg = "Uncommon Item Found!"
        url = getgenv().uncommonURL
    elseif(rarity == "Rare") then
        Color = 0x0000FF
        msg = "Rare Item Found!"
        url = getgenv().rareURL
    elseif(rarity == "Epic") then
        Color = 0xFF00FF
        msg = "Epic Item Found!"
        url = getgenv().epicURL
    elseif(rarity == "Legendary") then
        Color = 0xFF0000
        msg = getgenv().LegendaryMessage
        url = getgenv().legendaryURL
    else
        Color = 0x000000
        msg = "Item Found!"
        url = getgenv().commonURL
    end
    syn.request({
        Url = url,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = http:JSONEncode({
            content = msg,
            embeds = {
                {
                    title = "New Item!",
                    color = Color,
                    fields = {
                        {
                            name = "User",
                            value = player.Name
                        },
                        {
                            name = "Item Name",
                            value = Item.NameLabel.Text
                        },
                        {
                            name = "Item Type",
                            value = Item.TypeLabel.Text
                        },
                        {
                            name = "Item Rarity",
                            value = rarity
                        }
                    }
                }
            }
        })
    })
end

function logCurrency(Currency)
    syn.request({
        Url = url,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = http:JSONEncode({
            embeds = {
                {
                    title = "Currency!",
                    color = 0x00FF00,
                    fields = {
                        {
                            name = "Amount",
                            value = Currency.AmountLabel.Text
                        },
                        {
                            name = "Name",
                            value = Currency.NameLabel.Text
                        }
                    }
                }
            }
        })
    })
end

function logExp(Exp)
    syn.request({
        Url = url,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = http:JSONEncode({
            embeds = {
                {
                    title = "Exp!",
                    color = 0x00FF00,
                    fields = {
                        {
                            name = "Amount",
                            value = Exp.AmountLabel.Text
                        },
                        {
                            name = "Name",
                            value = Exp.NameLabel.Text
                        }
                    }
                }
            }
        })
    })
end