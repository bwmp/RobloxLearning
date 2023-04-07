local SolarisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Oli-idk/RobloxLearning/main/Scripts/UILib2.lua"))()
local players = game:GetService("Players")
local player = players.LocalPlayer
local UsedCodes = player.Data.Codes
local VU = game:GetService("VirtualUser")
local http = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Storage = ReplicatedStorage.Storage;
local RedeemCode = ReplicatedStorage.Remotes.RedeemCodeRemote
local RewardsClient = require(ReplicatedStorage["_replicationFolder"].RewardsClient);
local LevelUpClient = require(ReplicatedStorage["_replicationFolder"].LevelUpClient);
local gameUtils = require(ReplicatedStorage["_replicationFolder"].GameUtils)
local Crates = require(ReplicatedStorage.Storage.Assets.Items.Crates)
local treasureHuntClient = ReplicatedStorage["_replicationFolder"].TreasureHuntClient;
local treasureHuntMinigame = game:GetService("Workspace").Interactions.Minigames.TreasureHunt;
local codesToClaim = {"30klikes", "40klikes", "50klikes", "60klikes", "AprilFools"}
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
local target = ""
local slot = "Slot1"
local itemType = "Accessories"
local CrateItems = {}
local CrateAmount = 1
local AutoDigBool = false
local AutoClaimBool = false
local LogCratesBool = false
local AutoTradeBool = false
local ClaimCodesBool = false
local AutoOpenEggsBool = false
local AutoOpenCratesBool = false
local farmingSpots = {["Treasure"] = true, ["Trinkets"] = false, ["XP"] = false}
--#endregion

--#region Functions
function SplitByCase(string: string)
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

function LogCrateReward(reward: table)
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

function logItem(Item: table)
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

function getUniqueItems(user, checkSlot, type)
    local values = {}
    local uniqueValues = {}
    local items = game:GetService("Players")[user].Data.Characters[checkSlot][type]:GetChildren()
    for i, item in ipairs(items) do
        table.insert(values, item.Value)
    end

    for i, value in ipairs(values) do
        if not uniqueValues[value] then
            table.insert(uniqueValues, value)
        end
    end
    return uniqueValues
end

function getUniqueItems2(user, checkSlot, type)
    local values = {}
    local uniqueValues = {}
    local items = game:GetService("Players")[user].Data.Characters[checkSlot][type]:GetChildren()
    for i, item in ipairs(items) do
        table.insert(values, item.Value)
    end

    for i, value in ipairs(values) do
        if not uniqueValues[value] then
            uniqueValues[value] = true
        end
    end
    return uniqueValues
end

function getMissing(targetaccs: string, youraccs: string)
    local missing = {}
    for i, v in pairs(youraccs) do
        if(targetaccs[i] == nil) then
            table.insert(missing, i)
        end
    end
    return missing
end

function getItemByName(items: table, name: string)
    for i, v in ipairs(items:GetChildren()) do
        if(v.Value == name) then
            return v
        end
    end
end

function print_table(node: table)
    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "{\n"

    while true do
        local size = 0
        for k,v in pairs(node) do
            size = size + 1
        end

        local cur_index = 1
        for k,v in pairs(node) do
            if (cache[node] == nil) or (cur_index >= cache[node]) then

                if (string.find(output_str,"}",output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str,"\n",output_str:len())) then
                    output_str = output_str .. "\n"
                end

                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output,output_str)
                output_str = ""

                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "["..tostring(k).."]"
                else
                    key = "['"..tostring(k).."']"
                end

                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = "..tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = {\n"
                    table.insert(stack,node)
                    table.insert(stack,v)
                    cache[node] = cur_index+1
                    break
                else
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = '"..tostring(v).."'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (size == 0) then
            output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
        end

        if (#stack > 0) then
            node = stack[#stack]
            stack[#stack] = nil
            depth = cache[node] == nil and depth + 1 or depth - 1
        else
            break
        end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output,output_str)
    output_str = table.concat(output)

    print(output_str)
end

function autoDig()
    while AutoDigBool do
        for _, treasureModel in ipairs(treasureHuntMinigame:GetDescendants()) do
            if(AutoDigBool == false) then
                break
            end
            if treasureModel:IsA("MeshPart") then
                if (farmingSpots[treasureModel.Name] == false) then
                    continue
                end
                local time = 0;
                local stuck = 0;
                player.Character.HumanoidRootPart.CFrame = treasureModel.CFrame + Vector3.new(0, 5, 0)
                task.wait(0.5)
                local proximityPrompt = treasureModel:WaitForChild("ProximityPrompt")
                proximityPrompt:InputHoldBegin()
                proximityPrompt:InputHoldEnd()
                while (#treasureModel:GetChildren() > 0) do
                    if(time > 10)then
                        time = 0;
                        player.Character.HumanoidRootPart.CFrame = treasureModel.CFrame
                        if(stuck > 5)then
                            stuck = 0;
                            break
                        end
                        stuck += 1
                        task.wait(1.5)
                        proximityPrompt = treasureModel:WaitForChild("ProximityPrompt")
                        proximityPrompt:InputHoldBegin()
                        proximityPrompt:InputHoldEnd()
                    end
                    time += 0.1
                    task.wait(0.1)
                end
            end
        end
        task.wait(0.1)
    end
end

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
        task.wait(0.1)
    end
end

function EggAddedOrRemoved(slot)
    if AutoOpenEggsBool == false then
        return
    end

    local args = {
        [1] = player.Data.Characters[slot].Eggs:GetChildren()[1].Name,
        [2] = "Eggs"
    }
    ReplicatedStorage.Remotes.EquipPetRemote:InvokeServer(unpack(args))
end
for i = 1, 3 do
    player.Data.Characters["Slot"..i].Eggs.ChildAdded:Connect(function() EggAddedOrRemoved("Slot"..i) end)
    player.Data.Characters["Slot"..i].Eggs.ChildRemoved:Connect(function() EggAddedOrRemoved("Slot"..i) end)
end

function claimCodes()
    for _, code in pairs(codesToClaim) do
        RedeemCode:InvokeServer(code)
    end
end
function autoClaimCodes()
    while ClaimCodesBool do
        UsedCodes:ClearAllChildren()
        while (#UsedCodes:GetChildren() > 0) do task.wait(0.1) end
        claimCodes()
    end
end

function GetPlayers()
    local players = {}
    for _, plr in ipairs(game:GetService("Players"):GetChildren()) do
        table.insert(players, plr.Name)
    end
    return players
end
function autoTrade()
    while AutoTradeBool == true do
        local items = player.Data.Characters[slot][itemType]:GetChildren()
        local args = {
            [1] = "SendRequest",
            [2] = game:GetService("Players")[target]
        }
        player.Remotes.TradeRequestRemote:FireServer(unpack(args))

        while player.PlayerGui.TradeGui.ContainerFrame.Visible == false do task.wait(0.1) end

        for i = 1, 9 do
            local args = {
                [1] = "AddTradeItem",
                [2] = {
                    ["Amount"] = 1,
                    ["Name"] = items[i].Name,
                    ["ItemType"] = itemType,
                    ["Slot"] = slot
                }
            }
            ReplicatedStorage.Remotes:FindFirstChild(player.Name .."-"..target.."TradeRemote"):InvokeServer(unpack(args))
            task.wait(0.1)
        end

        local args2 = {
            [1] = "AcceptTrade"
        }

        ReplicatedStorage.Remotes:FindFirstChild(player.Name .."-"..target.."TradeRemote"):InvokeServer(unpack(args2))

        while player.PlayerGui.TradeGui.ContainerFrame.Visible == true do task.wait(0.1) end
    end
end
function autoTradeMissing(type: string)
    while AutoTradeBool == true do
        local items = player.Data.Characters[slot][type]
        local MissingAccessories = getMissing(getUniqueItems2(target, "Slot1", type), getUniqueItems2(player.Name, slot, type))
        local args = {
            [1] = "SendRequest",
            [2] = game:GetService("Players")[target]
        }
        player.Remotes.TradeRequestRemote:FireServer(unpack(args))

        while player.PlayerGui.TradeGui.ContainerFrame.Visible == false do task.wait(0.1) end

        for i = 1, 9 do
            local args2 = {
                [1] = "AddTradeItem",
                [2] = {
                    ["Amount"] = 1,
                    ["Name"] = getItemByName(items, MissingAccessories[i]).Name,
                    ["ItemType"] = type,
                    ["Slot"] = "Slot1"
                }
            }
            ReplicatedStorage.Remotes:FindFirstChild(player.Name .."-"..target.."TradeRemote"):InvokeServer(unpack(args2))
        end

        local args = {
            [1] = "AcceptTrade"
        }

        ReplicatedStorage.Remotes:FindFirstChild(player.Name .."-"..target.."TradeRemote"):InvokeServer(unpack(args))

        while player.PlayerGui.TradeGui.ContainerFrame.Visible == true do task.wait(0.1) end
    end
end
function autoAccept()
    while AutoAcceptBool == true do
        local args = {
            [1] = "AcceptRequest"
        }
        while player.PlayerGui.TradeGui.ContainerFrame.Visible == false do
            players[target].Remotes.TradeRequestRemote:FireServer(unpack(args))
            task.wait(1)
        end
        local args2 = {
            [1] = "AcceptTrade"
        }
        while player.PlayerGui.TradeGui.ContainerFrame.Visible == true do 
            coroutine.wrap(function()
                ReplicatedStorage.Remotes:FindFirstChild(target.."-"..player.Name.."TradeRemote"):InvokeServer(unpack(args2))
            end)()
            task.wait(1)
        end
    end
end

function getCrateItems(crate)
    table.clear(CrateItems)
    table.foreach(Crates[crate]["Categories"], function(i, v)
        table.foreach(v["Items"], function(i2, v2)
            table.insert(CrateItems, v2)
        end)
    end)
end

function getNeededCrateItems(crate)
    local neededItems = {}
    local currentItems = getUniqueItems(target, slot, Crates[crate].Type)
    getCrateItems(crate)
    table.foreach(CrateItems, function(i, v)
        if(not table.find(currentItems, v)) then
            table.insert(neededItems, v)
        end
    end)
    NeededItemsLabel:Set(string.format("Needed Items: %d/%d", #neededItems, #CrateItems))
    return neededItems
end

function GetCrates()
    local crates = {}
    for _, crate in ipairs(Storage.Assets.Items.Crates:GetChildren()) do
        table.insert(crates, crate.Name)
    end
    --sort table alphabetically
    table.sort(crates)
    return crates
end

function AutoOpenCrates()
    getCrateItems(Crate)
    while AutoOpenCratesBool do
        local neededItems = getNeededCrateItems(Crate)
        if(#neededItems == 0) then
            AutoOpenCratesToggle:Set(false)
            break;
        end
        local args = {
            [1] = Crate,
            [2] = 1
        }

        local drops = ReplicatedStorage.Remotes.PurchaseCrateRemote:InvokeServer(unpack(args))
        for i, v in pairs(drops.Drops) do
            if(table.find(neededItems, v.Item)) then
                table.remove(neededItems, table.find(neededItems, v.Item))
            end
            if(LogCratesBool) then
                LogCrateReward(v)
            end
        end
        task.wait(0.5)
    end
end

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

AutoFarmSection:Toggle("Auto Dig", false, "Auto Dig", function(t)
    if(t == true) then
        AutoDigBool = true
        autoDig()
    else
        AutoDigBool = false
    end
end)

AutoFarmSection:Toggle("Auto Claim", false, "Auto Claim", function(t)
    if(t == true) then
        AutoClaimBool = true
        autoClaimReward()
    else
        AutoClaimBool = false
    end
end)

AutoFarmSection:Toggle("Auto Open Eggs", false, "Auto Open Eggs", function(t)
    AutoOpenEggsBool = t
    if(AutoOpenEggsBool == true) then
        for i = 1, 3 do
            local args = {
                [1] = player.Data.Characters["Slot"..i].Eggs:GetChildren()[1].Name,
                [2] = "Eggs"
            }
            ReplicatedStorage.Remotes.EquipPetRemote:InvokeServer(unpack(args))
        end
    end
end)

AutoFarmSection:Toggle("Claim Codes", false, "Claim Codes", function(t)
    if(t == true) then
        ClaimCodesBool = true
        autoClaimCodes()
    else
        ClaimCodesBool = false
    end
end)

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

TradeSection:Dropdown("Type", { "Accessories", "Backpack", "BodyParts", "Eggs", "Eyes", "MaterialPalettes", "Pupils", "Palettes", "Pets"}, "Accessories", "Dropdown", function(t)
    itemType = t
end)
TradeSection:Toggle("Auto Trade Missing", false, "Auto Trade", function(t)
    if(t == true) then
        AutoTradeBool = true
        autoTradeMissing(itemType)
    else
        AutoTradeBool = false
    end
end)

TradeSection:Toggle("Auto Accept", false, "Auto Accept", function(t)
    if(t == true) then
        AutoAcceptBool = true
        autoAccept()
    else
        AutoAcceptBool = false
    end
end)
--#endregion

--#region Settings
local SettingsSection = SettingsPage:Section("Settings")

SettingsSection:Button("Anti AFK", function()
    player.Idled:Connect(function()
        VU:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(1)
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

SettingsSection:Dropdown("Slot", {"Slot1", "Slot2", "Slot3"},"Slot1","Dropdown", function(t)
    slot = t
end)
local targetDropdown = SettingsSection:Dropdown("Target", {},player.Name,"Dropdown", function(t)
    target = t
end)
SettingsSection:Button("Reload Players", function()
    targetDropdown:Refresh(GetPlayers(), true)
end)
targetDropdown:Refresh(GetPlayers(), true)
SettingsSection:Toggle("Auto Trade", false, "Auto Trade", function(t)
    if(t == true) then
        AutoTradeBool = true
        autoTrade()
    else
        AutoTradeBool = false
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

NeededItemsLabel = CratesSection:Label("Needed Items: 0")

local CrateSelector = CratesSection:Dropdown("Dropdown", {},"AquaticCrate","Dropdown", function(t)
    Crate = t
    getCrateItems(t)
    getNeededCrateItems(t)
end)

CrateSelector:Refresh(GetCrates(), true)

CratesSection:Slider("Amount", 1,24,1,1,"Slider", function(t)
    CrateAmount = t
end)

CratesSection:Toggle("Log Crates", false, "Log Crates", function(t)
    LogCratesBool = t
end)

CratesSection:Button("Open Crates", function()
    local args = {
        [1] = Crate,
        [2] = CrateAmount
    }

    local drops = ReplicatedStorage.Remotes.PurchaseCrateRemote:InvokeServer(unpack(args))
    if(LogCratesBool) then
        for i, v in pairs(drops) do
            for i2, v2 in pairs(v) do
                getNeededCrateItems(Crate)
                LogCrateReward(v2)
            end
        end
    end
end)

AutoOpenCratesToggle = CratesSection:Toggle("Auto Open Until Got All Items", false, "Auto Open Until Got All Items", function(t)
    if(t == true) then
        AutoOpenCratesBool = true
        getCrateItems(Crate)
        AutoOpenCrates()
    else
        AutoOpenCratesBool = false
    end
end)


--#endregion