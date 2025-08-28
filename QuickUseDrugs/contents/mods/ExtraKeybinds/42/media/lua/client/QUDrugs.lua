-- QuickUse Drugs Mod - Basic moodle detection
-- Project Zomboid Build 42 compatible
-- Author: fireblanket
--
-- Moodle Scale: 0-4 (0=0%, 1=25%, 2=50%, 3=75%, 4=100%)

-- Required modules
require "QUDrugsOptions"

-- Helper function to check if an item is a beta blocker
local function isBetaBlocker(item)
    if not item then return false end
    
    -- Check if item is the actual PillsBeta item type
    if item:getType() == "Base.PillsBeta" then
        return true
    end
    
    -- Also check display name as backup
    local itemName = item:getDisplayName():lower()
    if itemName:find("beta") and itemName:find("blocker") then
        return true
    end
    
    return false
end

-- Helper function to check if an item is a painkiller
local function isPainkiller(item)
    if not item then return false end
    
    -- Check if item is the actual Pills item type (painkillers)
    if item:getType() == "Base.Pills" then
        return true
    end
    
    -- Also check display name as backup
    local itemName = item:getDisplayName():lower()
    if itemName:find("pain") or itemName:find("painkiller") then
        return true
    end
    
    return false
end

-- Helper function to check if an item is an antidepressant
local function isAntidepressant(item)
    if not item then return false end
    
    -- Check if item is the actual PillsAntiDep item type
    if item:getType() == "Base.PillsAntiDep" then
        return true
    end
    
    -- Also check display name as backup
    local itemName = item:getDisplayName():lower()
    if itemName:find("antidepressant") or itemName:find("anti") and itemName:find("dep") then
        return true
    end
    
    return false
end

-- Generic function to search for any type of medication
local function searchForMedication(player, medicationType, checkFunction, medicationName)
    if not player then return {} end
    
    print("QUDrugs: Searching for " .. medicationName .. "...")
    print("QUDrugs: Debug - checkFunction type: " .. type(checkFunction))
    
    local foundItems = {}
    
    -- Search player's main inventory
    print("QUDrugs: Debug - Starting main inventory search...")
    local playerInventory = player:getInventory()
    if not playerInventory then
        print("QUDrugs: Debug - No player inventory found!")
        return foundItems
    end
    
    local inventoryItems = playerInventory:getItems()
    if not inventoryItems then
        print("QUDrugs: Debug - No inventory items found!")
        return foundItems
    end
    
    local inventorySize = inventoryItems:size()
    print("QUDrugs: Debug - Inventory size: " .. inventorySize)
    
    for i = 0, inventorySize - 1 do
        local item = inventoryItems:get(i)
        if item then
            print("QUDrugs: Debug - Checking item: " .. item:getDisplayName())
            if checkFunction(item) then
                table.insert(foundItems, item)
                print("QUDrugs: Found " .. medicationName .. ": " .. item:getDisplayName())
            end
        end
    end
    
    -- Search through equipped bags (simplified, no recursion)
    print("QUDrugs: Debug - Starting bag search...")
    
    print("QUDrugs: Debug - About to get back bag...")
    local bag = player:getClothingItem_Back()
    print("QUDrugs: Debug - Back bag: " .. tostring(bag))
    
    if bag then
        print("QUDrugs: Debug - Bag name: " .. bag:getDisplayName())
        print("QUDrugs: Debug - About to get bag container...")
        local bagContainer = bag:getContainer()
        print("QUDrugs: Debug - Bag container: " .. tostring(bagContainer))
        
        if bagContainer then
            print("QUDrugs: Debug - Searching bag container...")
            local bagItems = bagContainer:getItems()
            if bagItems then
                for i = 0, bagItems:size() - 1 do
                    local item = bagItems:get(i)
                    if item and checkFunction(item) then
                        table.insert(foundItems, item)
                        print("QUDrugs: Found " .. medicationName .. " in bag: " .. item:getDisplayName())
                    end
                end
            end
        end
    end
    
    print("QUDrugs: Debug - Bag search completed")
    
    -- Report findings
    if #foundItems > 0 then
        print("QUDrugs: Found " .. #foundItems .. " " .. medicationName .. "(s)")
        player:Say("Found some " .. medicationName .. ".")
    else
        print("QUDrugs: No " .. medicationName .. " found")
        player:Say("I need " .. medicationName .. " but can't find any.")
    end
    
    return foundItems
end

-- Function to handle high panic levels - search for beta blockers
local function highPanicLevel()
    local player = getPlayer()
    if not player then 
        print("QUDrugs: Error - No player found in highPanicLevel!")
        return 
    end
    
    return searchForMedication(player, "betaBlockers", isBetaBlocker, "beta blockers")
end

-- Function to handle high pain levels - search for painkillers
local function highPainLevel()
    local player = getPlayer()
    if not player then 
        print("QUDrugs: Error - No player found in highPainLevel!")
        return 
    end
    
    return searchForMedication(player, "painkillers", isPainkiller, "painkillers")
end

-- Function to handle high unhappiness levels - search for antidepressants
local function highUnhappinessLevel()
    local player = getPlayer()
    if not player then 
        print("QUDrugs: Error - No player found in highUnhappinessLevel!")
        return 
    end
    
    return searchForMedication(player, "antidepressants", isAntidepressant, "antidepressants")
end

-- Main function that gets called when keybind is pressed
local function onQuickUseDrugsPressed()
    local player = getPlayer()
    if not player then 
        print("QUDrugs: Error - No player found!")
        return 
    end
    
    -- Safely get moodle levels with error handling
    local painLevel = 0
    local panicLevel = 0
    local unhappinessLevel = 0
    
    local moodles = player:getMoodles()
    if moodles then
        -- Try to get moodle levels, with fallback to 0 if any fail
        local success, result = pcall(function() return moodles:getMoodleLevel(MoodleType.Pain) end)
        painLevel = success and result or 0
        
        success, result = pcall(function() return moodles:getMoodleLevel(MoodleType.Panic) end)
        panicLevel = success and result or 0
        
        success, result = pcall(function() return moodles:getMoodleLevel(MoodleType.Unhappy) end)
        unhappinessLevel = success and result or 0
    end
    
    -- Print current moodle levels
    print("=== QUDrugs: Current Moodle Levels ===")
    print("Pain: " .. painLevel .. ", Panic: " .. panicLevel .. ", Unhappiness: " .. unhappinessLevel)
    print("=====================================")
    
    -- Check moodle levels and call appropriate functions
    if panicLevel > 2 then
        print("QUDrugs: High panic detected, calling highPanicLevel function...")
        highPanicLevel()
    elseif painLevel > 2 then
        print("QUDrugs: High pain detected, calling highPainLevel function...")
        highPainLevel()
    elseif unhappinessLevel > 2 then
        print("QUDrugs: High unhappiness detected, calling highUnhappinessLevel function...")
        highUnhappinessLevel()
    else
        print("QUDrugs: No high moodle levels detected")
        player:Say("I think I'm ok now.")
    end
end

-- Set up keybinding when mod loads
Events.OnGameStart.Add(function()
    local keybind = QUDrugsSettings.getQuickUseDrugsKeybind()
    if keybind and keybind > 0 then
        print("QUDrugs: QuickUse Drugs keybind set to key code: " .. keybind)
    else
        print("QUDrugs: QuickUse Drugs keybind not set - configure in mod options")
    end
end)

-- Handle key presses
Events.OnKeyPressed.Add(function(key)
    local keybind = QUDrugsSettings.getQuickUseDrugsKeybind()
    if keybind and keybind > 0 and key == keybind then
        print("QUDrugs: Key pressed! Calling onQuickUseDrugsPressed function...")
        onQuickUseDrugsPressed()
    end
end)

print("QUDrugs: Clean moodle detection loaded")
