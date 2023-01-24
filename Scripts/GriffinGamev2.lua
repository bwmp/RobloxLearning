local SolarisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Oli-idk/RobloxLearning/main/Scripts/UILib2.lua"))()
local player = game.Players.LocalPlayer
local VU = game:GetService("VirtualUser")
local UsedCodes = player.Data.Codes
local codesToClaim = {"30klikes", "40klikes", "50klikes", "happychinesenewyear"}
local http = game:GetService("HttpService")
local RedeemCodeRemote = game:GetService("ReplicatedStorage").Remotes.RedeemCodeRemote
local RewardsClient = require(game:GetService("ReplicatedStorage")["_replicationFolder"].RewardsClient);


local win = SolarisLib:New({
    Name = "Griffins Destiny",
    FolderToSave = "GriffinsDestiny"
})
    
local AutoPage = win:Tab("Automation")
local SettingsPage = win:Tab("Settings")
local GamepassPage = win:Tab("Gamepass")
local CratesPage = win:Tab("Crates")

-- Settings
local ClaimCodesBool = false
local AutoDigBool = false
local AutoClaimBool = false
local Crate = ""
local CrateAmount = 1
local LogCratesBool = false
-- End Settings
local AutoFarmSection = AutoPage:Section("Auto Farm")
AutoFarmSection:Button("Anti AFK", function()
    player.Idled:Connect(function()
        VU:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        VU:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end)

ClaimCodes = AutoFarmSection:Toggle("Claim Codes", false, "Claim Codes", function(t)
    if(t == true) then
        ClaimCodesBool = true
        autoClaimCodes()
    else
        ClaimCodesBool = false
    end
end)
function claimCodes()
    for _, code in pairs(codesToClaim) do
        RedeemCodeRemote:InvokeServer(code)
        wait(1)
    end
end
function autoClaimCodes()
    while ClaimCodesBool do
        UsedCodes:ClearAllChildren()
        wait(1)
        claimCodes()
    end
end

AutoDig = AutoFarmSection:Toggle("Auto Dig", false, "Auto Dig", function(t)
    if(t == true) then
        AutoDigBool = true
        autoDig()
    else
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
                player.Character:MoveTo(treasureModel.Position)
                wait(0.5)
                local proximityPrompt = treasureModel:WaitForChild("ProximityPrompt")
                proximityPrompt:InputHoldBegin()
                proximityPrompt:InputHoldEnd()
                while (#treasureModel:GetChildren() > 0) do
                    if(time > 10)then
                        time = 0;
                        player.Character:MoveTo(treasureModel.Position)
                        wait(0.5)
                        proximityPrompt:InputHoldBegin()
                        proximityPrompt:InputHoldEnd()

                    end
                    time += 0.1
                    wait(0.1)
                end
            end
        end
    end
end

AutoClaimReward = AutoFarmSection:Toggle("Auto Claim", false, "Auto Claim", function(t)
    if(t == true) then
        AutoClaimBool = true
        autoClaim()
    else
        AutoClaimBool = false
    end
end)
function autoClaimReward()
    while AutoClaimBool == true do
        if(player.PlayerGui.RewardsGui.RewardsFrame.Visible == true) then
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
        wait(0.1)
    end
end

local SettingsSection = SettingsPage:Section("Settings")

DisableTreasureCollision = SettingsSection:Toggle("Disable Treasure Collision", false, "Disable Treasure Collision", function(t)
    if(t == true) then
        game:GetService("ReplicatedStorage")["_replicationFolder"].TreasureHuntClient.TreasureModel.CanCollide = false
        for _, treasureModel in ipairs(game:GetService("Workspace").Interactions.Minigames.TreasureHunt:GetChildren()) do
            if treasureModel.Name == "TreasureModel" then
                treasureModel.CanCollide = false
            end
        end
    else
        game:GetService("ReplicatedStorage")["_replicationFolder"].TreasureHuntClient.TreasureModel.CanCollide = false
        for _, treasureModel in ipairs(game:GetService("Workspace").Interactions.Minigames.TreasureHunt:GetChildren()) do
            if treasureModel.Name == "TreasureModel" then
                treasureModel.CanCollide = true
            end
        end
    end
end)

local GamepassSection = GamepassPage:Section("Gamepass")

x6Crates = GamepassSection:Toggle("x6 Crates", false, "x6 Crates", function(t)
    player.Gamepasses.x6Open.Value = t
end)

MultipleAccessories = GamepassSection:Toggle("Multiple Accessories", false, "Multiple Accessories", function(t)
    player.Gamepasses.MultipleAccessories.Value = t
end)

MaxPetEquip = GamepassSection:Toggle("Max Pet Equip", false, "Max Pet Equip", function(t)
    player.Gamepasses.MaxPetEquip.Value = t
end)

local CratesSection = CratesPage:Section("Crates")
CrateSelector = CratesSection:Dropdown("Dropdown", 
{
    "FurCrate",
    "BasicCrate",
    "HairCrate",
    "FeatherCrate",
    "HornCrate",
    "PunkCrate",
    "NatureCrate",
    "JeweleryCrate",
    "PatternCrate",
    "ClothingCrate",
    "AquaticCrate",
    "BattleCrate",
    "DragonCrate",
    "PartyCrate",
    "MagicCrate",
    "DarkCrate",
    "LightCrate",
    "HorrorCrate",
    "HaloCrate"
}
,"","Dropdown", function(t)
    Crate = t
end)

CrateAmountSelector = sec:Slider("Amount", 1,12,1,1,"Slider", function(t)
    Amount = t
end)

LogCrates = CratesSection:Toggle("Log Crates", false, "Log Crates", function(t)
    LogCratesBool = t
end)

OpenCrates = CratesSection:Button("Open Crates", "Open Crates", function()
    local args = {
        [1] = Crate,
        [2] = CrateAmount
    }
    
    local drops = game:GetService("ReplicatedStorage").Remotes.PurchaseCrateRemote:InvokeServer(unpack(args))
    if(LogCratesBool) then
        for i, v in pairs(returnValue) do
            for i2, v2 in pairs(v.Drops) do
                LogCrateReward(v2)
            end
        end
    end
end)

function SplitByCase(string)
    local words = {}
    for word in string.gmatch(originalString, "[%a]+[A-Z]?") do
        table.insert(words, word)
    end
    return table.concat(words, " ")
end

function LogCrateReward(reward)
    local msg = ""
    local Color
    local url
    local rarity = reward.Rarity
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
        msg = "Legendary Item Found!"
        url = getgenv().legendaryURL
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
                            value = SplitByCase(reward.Item)
                        },
                        {
                            name = "Item Type",
                            value = reward.Type
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