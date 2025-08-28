-- QuickUse Drugs Mod - Basic moodle detection
-- Project Zomboid Build 42 compatible
-- Author: fireblanket
--
-- Moodle Scale: 0-4 (0=0%, 1=25%, 2=50%, 3=75%, 4=100%)

-- Required modules
require "QUDrugsOptions"

-- Note: Using existing ISTakePillAction instead of custom action class

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

-- Generic function to search for any type of medication using recursive container search
local function searchForMedicationRecursive(inventory, checkFunction, medicationName)
    if not inventory then return nil, nil end
    
    for i = 0, inventory:getItems():size() - 1 do
        local item = inventory:getItems():get(i)
        
        if item and checkFunction(item) then
            return item, inventory
        end
        
        -- Check containers recursively (searches ALL equipped bags automatically)
        if item:IsInventoryContainer() then
            local subInventory = item:getInventory()
            if subInventory then
                local found, foundIn = searchForMedicationRecursive(subInventory, checkFunction, medicationName)
                if found then
                    return found, foundIn
                end
            end
        end
    end
    return nil, nil
end

-- Generic function to search for any type of medication
local function searchForMedication(player, medicationType, checkFunction, medicationName)
    if not player then return {} end
    
    print("QUDrugs: Searching for " .. medicationName .. "...")
    
    local foundItems = {}
    
    -- Search player's main inventory
    local playerInventory = player:getInventory()
    local inventoryItems = playerInventory:getItems()
    local inventorySize = inventoryItems:size()
    
    for i = 0, inventorySize - 1 do
        local item = inventoryItems:get(i)
        if item and checkFunction(item) then
            table.insert(foundItems, item)
            print("QUDrugs: Found " .. medicationName .. ": " .. item:getDisplayName())
        end
    end
    
    -- Search through equipped bags (simplified, no recursion)
    local bag = player:getClothingItem_Back()
    if bag and bag:IsInventoryContainer() then
        local bagInventory = bag:getInventory()
        if bagInventory then
            local bagItems = bagInventory:getItems()
            for i = 0, bagItems:size() - 1 do
                local item = bagItems:get(i)
                if item and checkFunction(item) then
                    table.insert(foundItems, item)
                    print("QUDrugs: Found " .. medicationName .. " in bag: " .. item:getDisplayName())
                end
            end
        end
    end
    
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

-- Generic function to handle medication treatment for any drug type
local function treatWithMedication(medicationType, checkFunction, medicationName, playerMessage)
    local player = getPlayer()
    if not player then
        print("QUDrugs: Error - No player found in " .. medicationType .. " treatment!")
        return
    end

    -- Check if player is already doing an action
    if ISTimedActionQueue.isPlayerDoingAction(player) then
        player:Say("I'm busy right now, can't take medication.")
        return
    end

    -- Search for the specified medication type using recursive search
    local medication, originalContainer = searchForMedicationRecursive(player:getInventory(), checkFunction, medicationName)

    -- If we found medication, consume one
    if medication then
        local needsReturn = (originalContainer ~= player:getInventory())
        
        if needsReturn then
            -- Move to main inventory first (like DrinkMain.lua does)
            print("QUDrugs: Moving " .. medicationName .. " to main inventory for consumption")
            ISTimedActionQueue.add(ISInventoryTransferAction:new(player, medication, originalContainer, player:getInventory()))
        end
        
        -- Use the existing ISTakePillAction instead of our custom action
        local pillAction = ISTakePillAction:new(player, medication)
        ISTimedActionQueue.add(pillAction)

        print("QUDrugs: Queued " .. medicationName .. " consumption using ISTakePillAction")
        player:Say(playerMessage)
        
        if needsReturn then
            -- Move it back to original container after consumption
            print("QUDrugs: Moving " .. medicationName .. " back to original container")
            ISTimedActionQueue.add(ISInventoryTransferAction:new(player, medication, player:getInventory(), originalContainer))
        end

        return {medication}
    end

    return {}
end

-- Function to handle high panic levels - search for and consume beta blockers
local function highPanicLevel()
    return treatWithMedication("betaBlockers", isBetaBlocker, "beta blockers", "Taking a beta blocker...")
end

-- Function to handle high pain levels - search for and consume painkillers
local function highPainLevel()
    return treatWithMedication("painkillers", isPainkiller, "painkillers", "Taking a painkiller...")
end

-- Function to handle high unhappiness levels - search for and consume antidepressants
local function highUnhappinessLevel()
    return treatWithMedication("antidepressants", isAntidepressant, "antidepressants", "Taking an antidepressant...")
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
    print("QUDrugs: Moodles - Pain:" .. painLevel .. " Panic:" .. panicLevel .. " Unhappiness:" .. unhappinessLevel)
    
    -- Check moodle levels and call appropriate functions
    if panicLevel > 0 then
        print("QUDrugs: High panic detected, treating...")
        highPanicLevel()
    elseif painLevel > 0 then
        print("QUDrugs: High pain detected, calling highPainLevel function...")
        highPainLevel()
    elseif unhappinessLevel > 0 then
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

print("QUDrugs: All three drug types implemented - Panic (Beta Blockers), Pain (Painkillers), Unhappiness (Antidepressants)")
