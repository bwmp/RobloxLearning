local SolarisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Oli-idk/RobloxLearning/main/Scripts/UILib2.lua"))()
local player = game.Players.LocalPlayer
local players = game:GetService("Players")
local VU = game:GetService("VirtualUser")
local http = game:GetService("HttpService")
local RewardsClient = require(game:GetService("ReplicatedStorage")["_replicationFolder"].RewardsClient);
local LevelUpClient = require(game:GetService("ReplicatedStorage")["_replicationFolder"].LevelUpClient);
local treasureHuntClient = game:GetService("ReplicatedStorage")["_replicationFolder"].TreasureHuntClient;
local treasureHuntMinigame = game:GetService("Workspace").Interactions.Minigames.TreasureHunt;
local win = SolarisLib:New({
    Name = "Griffins Destiny",
    FolderToSave = "GriffinsDestiny"
})

local AutoPage = win:Tab("Automation")
local SettingsPage = win:Tab("Settings")
local GamepassPage = win:Tab("Gamepass")
local CratesPage = win:Tab("Crates")

--#region Settings
local Crate = ""
local delay1 = 5
local delay2 = 7
local target = ""
local farmingSpots = {["Treasure"] = true, ["Trinkets"] = false, ["XP"] = false}
local slot = "Slot1"
local itmsNeeded = {}
local CrateAmount = 1
local AutoDigBool = false
local AutoClaimBool = false
local LogCratesBool = false
local AutoTradeBool = false
local AutoOpenEggsBool = false
local AutoAcceptTradeBool = false
local OpenUntilGotItemsBool = false
--#endregion

--#region Farming
local FarmingSpotsSection = AutoPage:Section("Farming Spots")
FarmingSpotsSection:Toggle("Treasure", true, "Treasure", function(t)
    farmingSpots["Treasure"] = t
end)

FarmingSpotsSection:Toggle("Trinkets", false, "Trinkets", function(t)
    farmingSpots["Trinkets"] = t
end)

FarmingSpotsSection:Toggle("XP", false, "XP", function(t)
    farmingSpots["XP"] = t
end)

local AutoFarmSection = AutoPage:Section("Auto Farm")

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
        for _, treasureModel in ipairs(treasureHuntMinigame:GetDescendants()) do
            if(AutoDigBool == false) then
                break
            end
            if treasureModel:IsA("MeshPart") then
                print("Digging")
                if (farmingSpots[treasureModel.Name] == false) then
                    continue
                end
                local time = 0;
                local stuck = 0;
                player.Character.HumanoidRootPart.CFrame = treasureModel.CFrame + Vector3.new(0, 5, 0)
                wait(0.5)
                local proximityPrompt = treasureModel:WaitForChild("ProximityPrompt")
                fireproximityprompt(proximityPrompt)
                while (#treasureModel:GetChildren() > 0) do
                    if(time > 10)then
                        time = 0;
                        player.Character.HumanoidRootPart.CFrame = treasureModel.CFrame
                        if(stuck > 5)then
                            stuck = 0;
                            break
                        end
                        stuck += 1
                        wait(1.5)
                        fireproximityprompt(proximityPrompt)
                    end
                    time += 0.1
                    wait(0.1)
                end
            end
        end
        wait(0.1)
    end
end

AutoClaimReward = AutoFarmSection:Toggle("Auto Claim", false, "Auto Claim", function(t)
    if(t == true) then
        AutoClaimBool = true
        autoClaimReward()
    else
        AutoClaimBool = false
    end
end)
function autoClaimReward()
    while AutoClaimBool == true do
        if(player.PlayerGui.LevelUpGui.UnlocksFrame.Visible == true) then
            LevelUpClient.Stop()
        end
        if(player.PlayerGui.RewardsGui.RewardsFrame.Visible == true) then
            -- for _, child in ipairs(player.PlayerGui.RewardsGui.RewardsFrame.SingleFrame:GetChildren()) do
            --     if(child.name == "UIListLayout") then
            --         continue
            --     else
            --         if(child.Visible) then
            --             if(child.Name == "Item") then
            --                 logItem(child)
            --             end
            --         end
            --     end
            -- end
            RewardsClient.Stop()
        end
        wait(0.1)
    end
end
AutoFarmSection:Toggle("Auto Open Eggs", false, "Auto Open Eggs", function(t)
    AutoOpenEggsBool = t
    if(AutoOpenEggsBool == true) then
        for i = 1, 3 do
            local args = {
                [1] = player.Data.Characters["Slot"..i].Eggs:GetChildren()[1].Name,
                [2] = "Eggs"
            }
            game:GetService("ReplicatedStorage").Remotes.EquipPetRemote:InvokeServer(unpack(args))
        end
    end
end)
function EggAddedOrRemoved(slot)
    if AutoOpenEggsBool == false then
        return
    end

    local args = {
        [1] = player.Data.Characters[slot].Eggs:GetChildren()[1].Name,
        [2] = "Eggs"
    }
    print("Equipped Egg: "..args[1])
    game:GetService("ReplicatedStorage").Remotes.EquipPetRemote:InvokeServer(unpack(args))
end
for i = 1, 3 do
    player.Data.Characters["Slot"..i].Eggs.ChildAdded:Connect(function() EggAddedOrRemoved("Slot"..i) end)
    player.Data.Characters["Slot"..i].Eggs.ChildRemoved:Connect(function() EggAddedOrRemoved("Slot"..i) end)
end

-- AutoFarmSection:Button("Chocolates1", function()
--     for _, chocolate in ipairs(game:GetService("Workspace").Interactions.Event.Chocolates1:GetChildren()) do
--         player.Character:MoveTo(chocolate.Position)
--         wait(0.2)
--         local proximityPrompt = chocolate:WaitForChild("ProximityPrompt")
--         fireproximityprompt(proximityPrompt)
--     end
-- end)
-- AutoFarmSection:Button("Chocolates2", function()
--     for _, chocolate in ipairs(game:GetService("Workspace").Interactions.Event.Chocolates2:GetChildren()) do
--         player.Character:MoveTo(chocolate.Position)
--         wait(0.2)
--         local proximityPrompt = chocolate:WaitForChild("ProximityPrompt")
--         fireproximityprompt(proximityPrompt)
--     end
-- end)
-- AutoFarmSection:Button("Chocolates3", function()
--     for _, chocolate in ipairs(game:GetService("Workspace").Interactions.Event.Chocolates3:GetChildren()) do
--         player.Character:MoveTo(chocolate.Position)
--         wait(0.2)
--         local proximityPrompt = chocolate:WaitForChild("ProximityPrompt")
--         fireproximityprompt(proximityPrompt)
--     end
-- end)

--#endregion

--#region Trading
local TradeSection = AutoPage:Section("Trade")
TradeSection:Dropdown("Slot", {"Slot1", "Slot2", "Slot3"},"Slot1","Dropdown", function(t)
    slot = t
end)
local targetDropdown = TradeSection:Dropdown("Target", {},"None","Dropdown", function(t)
    target = t
end)
TradeSection:Button("Reload Players", function()
    targetDropdown:Refresh(GetPlayers(), true)
end)
function GetPlayers()
    local players = {}
    for _, plr in ipairs(game:GetService("Players"):GetChildren()) do
        table.insert(players, plr.Name)
    end
    return players
end
targetDropdown:Refresh(GetPlayers(), true)
TradeSection:Toggle("Auto Trade", false, "Auto Trade", function(t)
    if(t == true) then
        AutoTradeBool = true
        autoTrade()
    else
        AutoTradeBool = false
    end
end)
function autoTrade()
    while AutoTradeBool == true do
        local Accessories = player.Data.Characters[slot].Accessories:GetChildren()
        local args = {
            [1] = "SendRequest",
            [2] = game:GetService("Players")[target]
        }
        player.Remotes.TradeRequestRemote:FireServer(unpack(args))
    
        while player.PlayerGui.TradeGui.ContainerFrame.Visible == false do wait(0.1) end
    
        for i = 1, 9 do
            local args = {
                [1] = "AddTradeItem",
                [2] = {
                    ["Amount"] = 1,
                    ["Name"] = Accessories[i].Name,
                    ["ItemType"] = "Accessories",
                    ["Slot"] = "Slot1"
                }
            }
            game:GetService("ReplicatedStorage").Remotes:FindFirstChild(player.Name .."-"..target.."TradeRemote"):InvokeServer(unpack(args))
        end
    
        local args = {
            [1] = "AcceptTrade"
        }
    
        game:GetService("ReplicatedStorage").Remotes:FindFirstChild(player.Name .."-"..target.."TradeRemote"):InvokeServer(unpack(args))
    
        while player.PlayerGui.TradeGui.ContainerFrame.Visible == true do wait(0.1) end
    end
end

TradeSection:Toggle("Auto Accept", false, "Auto Accept", function(t)
    if(t == true) then
        AutoAcceptBool = true
        autoAccept()
    else
        AutoAcceptBool = false
    end
end)

function autoAccept()
    while AutoAcceptBool == true do
        local args = {
            [1] = "AcceptRequest"
        }
        players[target].Remotes.TradeRequestRemote:FireServer(unpack(args))
        print("Sent accept request to " .. target)
        wait(delay1)
        local args2 = {
            [1] = "AcceptTrade"
        }
        coroutine.wrap(function()
            game:GetService("ReplicatedStorage").Remotes:FindFirstChild(target.."-"..player.Name.."TradeRemote"):InvokeServer(unpack(args2))
        end)()
        print("Accepted trade with " .. target)
        wait(delay2)
        print("looping")
    end
end
TradeSection:Slider("delay1", 0,10,7,0.5,"Slider", function(t)
    delay1 = t
end)
TradeSection:Slider("delay2", 0,10,7,0.5,"Slider", function(t)
    delay1 = t
end)
--#endregion

--#region Settings
local SettingsSection = SettingsPage:Section("Settings")

antiAFK = SettingsSection:Button("Anti AFK", function()
    player.Idled:Connect(function()
        VU:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        VU:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end)

SettingsSection:Toggle("Disable Treasure Collision", false, "Disable Treasure Collision", function(t)
    if(t == true) then
        treasureHuntClient.Treasure.CanCollide = false
        treasureHuntClient.XP.CanCollide = false
        treasureHuntClient.Trinkets.CanCollide = false
        for i,v in pairs(treasureHuntMinigame:GetDescendants()) do
            if v:IsA("MeshPart") then
                v.CanCollide = false
            end
        end
    else
        treasureHuntClient.Treasure.CanCollide = false
        for i,v in pairs(treasureHuntMinigame:GetDescendants()) do
            if v:IsA("MeshPart") then
                v.CanCollide = false
            end
        end
    end
end)
--#endregion

--#region Gamepass
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
--#endregion

--#region Crates
local CratesSection = CratesPage:Section("Crates")
CrateSelector = CratesSection:Dropdown("Dropdown",
{
    "FurCrate",
    "HairCrate",
    "BasicCrate",
    "HornCrate",
    "FeatherCrate",
    "PunkCrate",
    "JeweleryCrate",
    "NatureCrate",
    "ClothingCrate",
    "PatternCrate",
    "BattleCrate",
    "CuteCrate",
    "AquaticCrate",
    "DragonCrate",
    "PartyCrate",
    "MagicCrate",
    "DinosaurCrate",
    "FireCrate",
    "DarkCrate",
    "GalaxyCrate",
    "LightCrate",
    "HorrorCrate",
    "RoyalCrate",
    "HaloCrate",
    "TropicalCrate"
}
,"","Dropdown", function(t)
    Crate = t
end)

CrateAmountSelector = CratesSection:Slider("Amount", 1,12,1,1,"Slider", function(t)
    CrateAmount = t
end)

LogCrates = CratesSection:Toggle("Log Crates", false, "Log Crates", function(t)
    LogCratesBool = t
end)

ItemsNeeded = CratesSection:Textbox("Items Needed", false, function(t)
    itmsNeeded = getItems(t)
    itemsNeededLable:Set("Items Needed: " .. #itmsNeeded)
end)

function getItems(str)
    local noscapescript = string.gsub(str, "%s+", "")
    noscapescript = string.lower(noscapescript)
    return string.split(noscapescript, ",")
end

itemsNeededLable = CratesSection:Label("Items Needed: 0")

OpenUntilGotItems = CratesSection:Toggle("Open crates until you have all items needed", false, "Open crates until you have all items needed", function(t)
    if(t == true) then
        OpenUntilGotItemsBool = true
        openUntilGotItems()
    else
        OpenUntilGotItemsBool = false
    end
end)

function openUntilGotItems()
    local args = {
        [1] = Crate,
        [2] = CrateAmount
    }
    while OpenUntilGotItemsBool == true do
        local drops = game:GetService("ReplicatedStorage").Remotes.PurchaseCrateRemote:InvokeServer(unpack(args))
        if(#itmsNeeded < 0) then
            OpenUntilGotItemsBool = false
            return
        end
        for i, v in pairs(drops) do
            for i2, v2 in pairs(v) do
                if(table.find(itmsNeeded, v2.Item:lower()) == true) then
                    table.remove(itmsNeeded, table.find(itmsNeeded, v2.Item:lower()))
                    itemsNeededLable:Set("Items Needed: " .. #itmsNeeded)
                end
                if(LogCratesBool) then
                    LogCrateReward(v2)
                end
            end
        end
        wait(1)
    end
end

OpenCrates = CratesSection:Button("Open Crates", function()
    local args = {
        [1] = Crate,
        [2] = CrateAmount
    }

    local drops = game:GetService("ReplicatedStorage").Remotes.PurchaseCrateRemote:InvokeServer(unpack(args))
    if(LogCratesBool) then
        for i, v in pairs(drops) do
            for i2, v2 in pairs(v) do
                LogCrateReward(v2)
            end
        end
    end
end)

--#endregion

function SplitByCase(string)
    local words = {}
    local word = ""
    for i = 1, #string do
        local char = string:sub(i, i)
        if char == char:upper() then
            if word ~= "" then
                table.insert(words, word)
            end
            word = char
        else
            word = word .. char
        end
    end
    if word ~= "" then
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
        msg = "Common Item Opened!"
        url = getgenv().commonURL
    elseif(rarity == "Uncommon") then
        Color = 0x00FF00
        msg = "Uncommon Item Opened!"
        url = getgenv().uncommonURL
    elseif(rarity == "Rare") then
        Color = 0x0000FF
        msg = "Rare Item Opened!"
        url = getgenv().rareURL
    elseif(rarity == "Epic") then
        Color = 0xFF00FF
        msg = "Epic Item Opened!"
        url = getgenv().epicURL
    elseif(rarity == "Legendary") then
        Color = 0xFF0000
        msg = "Legendary Item Opened!"
        url = getgenv().legendaryURL
    end
    local response = syn.request({
        Url = url,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = http:JSONEncode({
            content = msg,
            embeds = {
                {
                    title = "New Crate Reward!",
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