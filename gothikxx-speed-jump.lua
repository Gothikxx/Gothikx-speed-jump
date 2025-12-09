-- LocalScript → StarterPlayerScripts
-- gthx speed&jump — Test GUI (Speed + Jump + Sliders + Minimize + Always On Top)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ========================
-- SCREEN GUI MAIN
-- ========================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GthxTestGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999999
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- ========================
-- MAIN WINDOW
-- ========================
local mainWindow = Instance.new("Frame")
mainWindow.Name = "MainWindow"
mainWindow.Size = UDim2.new(0, 320, 0, 230)
mainWindow.Position = UDim2.new(0, 100, 0, 100)
mainWindow.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainWindow.BorderSizePixel = 0
mainWindow.Active = true
mainWindow.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainWindow

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 100, 255)
stroke.Thickness = 2
stroke.Parent = mainWindow

-- ========================
-- TITLE BAR
-- ========================
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
titleBar.Parent = mainWindow

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "gthx speed&jump"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, -120, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.Parent = titleBar

-- ========================
-- CLOSE BUTTON
-- ========================
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 3)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ========================
-- MINIMIZE BUTTON
-- ========================
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
minimizeBtn.Position = UDim2.new(1, -80, 0, 3)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 220)
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 24
minimizeBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minimizeBtn

-- ========================
-- FLOATING CIRCLE (MINIMIZED)
-- ========================
local floatCircle = Instance.new("ImageButton")
floatCircle.Name = "FloatCircle"
floatCircle.Size = UDim2.new(0, 60, 0, 60)
floatCircle.Position = UDim2.new(0, 100, 0, 100)
floatCircle.BackgroundColor3 = Color3.fromRGB(50, 150, 220)
floatCircle.BackgroundTransparency = 0.3
floatCircle.Visible = false
floatCircle.Parent = screenGui

local floatCorner = Instance.new("UICorner")
floatCorner.CornerRadius = UDim.new(1, 0)
floatCorner.Parent = floatCircle

local circleIcon = Instance.new("TextLabel")
circleIcon.Text = "⚡"
circleIcon.TextSize = 30
circleIcon.BackgroundTransparency = 1
circleIcon.Size = UDim2.new(1,0,1,0)
circleIcon.Parent = floatCircle

floatCircle.MouseButton1Click:Connect(function()
    mainWindow.Visible = true
    floatCircle.Visible = false
end)

-- ========================
-- MINIMIZE LOGIC
-- ========================
minimizeBtn.MouseButton1Click:Connect(function()
    mainWindow.Visible = false
    floatCircle.Position = mainWindow.Position + UDim2.new(0, mainWindow.Size.X.Offset/2 - 30, 0, -50)
    floatCircle.Visible = true
end)

-- ========================
-- DRAG ENTIRE PANEL + FLOAT CIRCLE
-- ========================
local function makeDraggable(guiObject)
    local dragging = false
    local dragInput, mousePos, objPos

    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            objPos = guiObject.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - mousePos
            guiObject.Position = UDim2.new(
                objPos.X.Scale, objPos.X.Offset + delta.X,
                objPos.Y.Scale, objPos.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(mainWindow)
makeDraggable(floatCircle)

-- ========================
-- CONTENT AREA
-- ========================
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -50)
content.Position = UDim2.new(0, 10, 0, 45)
content.BackgroundTransparency = 1
content.Parent = mainWindow

-- Default Stats
local speedValue = 50
local jumpValue = 80

-- ========================
-- SLIDER GENERATOR
-- ========================
local function createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 12)
    sliderBg.Position = UDim2.new(0, 0, 0.5, 0)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    sliderBg.Parent = frame

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
    sliderFill.Parent = sliderBg

    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 24, 0, 24)
    knob.Position = UDim2.new((default - min)/(max - min), -12, 0, -6)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.Text = ""
    knob.Parent = sliderBg

    local knobCorner = Instance.new("UICorner", knob)
    knobCorner.CornerRadius = UDim.new(1, 0)

    local fillCorner = Instance.new("UICorner", sliderBg)
    fillCorner.CornerRadius = UDim.new(0, 6)

    local fillCorner2 = Instance.new("UICorner", sliderFill)
    fillCorner2.CornerRadius = UDim.new(0, 6)

    -- Slider movement protection
    local dragging = false

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = input.Position.X
            local barX = sliderBg.AbsolutePosition.X
            local barWidth = sliderBg.AbsoluteSize.X
            local relative = math.clamp((mouseX - barX) / barWidth, 0, 1)
            local value = math.floor(min + (max - min) * relative)

            sliderFill.Size = UDim2.new(relative, 0, 1, 0)
            knob.Position = UDim2.new(relative, -12, 0, -6)
            label.Text = text .. ": " .. value
            callback(value)
        end
    end)

    return frame
end

-- ========================
-- SPEED BUTTON
-- ========================
local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(0.48, 0, 0, 45)
speedBtn.Position = UDim2.new(0.02, 0, 0, 0)
speedBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
speedBtn.Text = "Speed OFF"
speedBtn.TextColor3 = Color3.new(1,1,1)
speedBtn.Font = Enum.Font.GothamBold
speedBtn.TextSize = 18
speedBtn.Parent = content

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 10)
speedCorner.Parent = speedBtn

local speedEnabled = false
speedBtn.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = speedEnabled and speedValue or 16
    end
    speedBtn.Text = speedEnabled and "Speed ON" or "Speed OFF"
    speedBtn.BackgroundColor3 = speedEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(70, 130, 255)
end)

-- Speed slider
createSlider(content, "Speed", 16, 200, 50, function(val)
    speedValue = val
    if speedEnabled then
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = val end
    end
end).Position = UDim2.new(0, 10, 0, 55)

-- ========================
-- JUMP BUTTON
-- ========================
local jumpBtn = Instance.new("TextButton")
jumpBtn.Size = UDim2.new(0.48, 0, 0, 45)
jumpBtn.Position = UDim2.new(0.52, 0, 0, 0)
jumpBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
jumpBtn.Text = "Jump OFF"
jumpBtn.TextColor3 = Color3.new(1,1,1)
jumpBtn.Font = Enum.Font.GothamBold
jumpBtn.TextSize = 18
jumpBtn.Parent = content

local jumpCorner = Instance.new("UICorner")
jumpCorner.CornerRadius = UDim.new(0, 10)
jumpCorner.Parent = jumpBtn

local jumpEnabled = false
jumpBtn.MouseButton1Click:Connect(function()
    jumpEnabled = not jumpEnabled
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.JumpPower = jumpEnabled and jumpValue or 50
    end
    jumpBtn.Text = jumpEnabled and "Jump ON" or "Jump OFF"
    jumpBtn.BackgroundColor3 = jumpEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(255, 100, 100)
end)

-- Jump slider
createSlider(content, "Jump Height", 50, 300, 100, function(val)
    jumpValue = val
    if jumpEnabled then
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = val end
    end
end).Position = UDim2.new(0, 10, 0, 120)

print("gthx speed&jump GUI Loaded!")
