-- GOTHIKXX ULTRA 2025 - VERSIÓN FINAL 100% FUNCIONAL
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")
local cam = workspace.CurrentCamera

-- Variables
local flying = false
local flySpeed = 100
local flingAura = false
local flingPower = 15000
local speedOn = false
local walkSpeed = 50
local jumpOn = false
local jumpPower = 100

-- GUI
local sg = Instance.new("ScreenGui")
sg.Name = "GothikXX_Ultra"
sg.ResetOnSpawn = false
sg.Parent = pgui

local main = Instance.new("ScrollingFrame")
main.Size = UDim2.new(0, 390, 0, 720)
main.Position = UDim2.new(0, 15, 0, 50)
main.BackgroundColor3 = Color3.fromRGB(12,12,20)
main.BorderSizePixel = 0
main.ScrollBarThickness = 12
main.ScrollBarImageColor3 = Color3.fromRGB(180,60,255)
main.CanvasSize = UDim2.new(0,0,0,2600)
main.Parent = sg

Instance.new("UICorner", main).CornerRadius = UDim.new(0,30)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(180,60,255)
stroke.Thickness = 5

-- Título (drag zone)
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,140)
title.BackgroundTransparency = 1
title.Text = "GOTHIKXX\nULTRA"
title.TextColor3 = Color3.fromRGB(220,80,255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 54
title.TextStrokeTransparency = 0.6

-- DRAG PERFECTO
local dragging = false
local dragStart, startPos

local function update(pos)
    local delta = pos - dragStart
    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

title.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = inp.Position
        startPos = main.Position
    end
end)

title.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(inp)
    if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        update(inp.Position)
    end
end)

-- Minimizar
local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0,60,0,60)
minBtn.Position = UDim2.new(1,-75,0,15)
minBtn.BackgroundColor3 = Color3.fromRGB(140,60,240)
minBtn.Text = "−"
minBtn.TextSize = 52
minBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,20)

local openBtn = Instance.new("TextButton", sg)
openBtn.Size = UDim2.new(0,110,0,110)
openBtn.BackgroundColor3 = Color3.fromRGB(140,60,240)
openBtn.BackgroundTransparency = 0.35
openBtn.Text = "GOTHIKXX"
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Font = Enum.Font.GothamBlack
openBtn.TextSize = 44
openBtn.Visible = false
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1,0)

minBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    openBtn.Visible = true
    openBtn.Position = main.Position + UDim2.new(0,140,0,-50)
end)
openBtn.MouseButton1Click:Connect(function()
    main.Visible = true
    openBtn.Visible = false
end)

local yPos = 160

local function addSection(name, btnText, offCol, onCol, sliderName, minV, maxV, defV, slideCB, toggleCB)
    -- Título sección
    local lbl = Instance.new("TextLabel", main)
    lbl.Size = UDim2.new(0.9,0,0,60)
    lbl.Position = UDim2.new(0.05,0,0,yPos)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Color3.fromRGB(220,100,255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 34
    yPos = yPos + 80

    -- Botón toggle
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.9,0,0,100)
    btn.Position = UDim2.new(0.05,0,0,yPos)
    btn.BackgroundColor3 = offCol
    btn.Text = btnText.." OFF"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = 44
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,28)

    local toggled = false
    btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        btn.Text = btnText..(toggled and " ON" or " OFF")
        btn.BackgroundColor3 = toggled and onCol or offCol
        toggleCB(toggled)
    end)
    yPos = yPos + 120

    -- Slider
    local container = Instance.new("Frame", main)
    container.Size = UDim2.new(0.9,0,0,130)
    container.Position = UDim2.new(0.05,0,0,yPos)
    container.BackgroundTransparency = 1

    Instance.new("TextLabel", container).Size = UDim2.new(1,0,0,50)
    local sname = Instance.new("TextLabel", container)
    sname.Text = sliderName
    sname.TextColor3 = Color3.fromRGB(180,180,255)
    sname.Font = Enum.Font.Gotham
    sname.TextSize = 28
    sname.Size = UDim2.new(1,0,0,50)

    local valueLabel = Instance.new("TextLabel", container)
    valueLabel.Text = tostring(defV)
    valueLabel.TextColor3 = Color3.new(1,1,1)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 38
    valueLabel.Position = UDim2.new(0,0,0,40)
    valueLabel.Size = UDim2.new(1,0,0,50)

    local bar = Instance.new("Frame", container)
    bar.Size = UDim2.new(1,0,0,30)
    bar.Position = UDim2.new(0,0,0,90)
    bar.BackgroundColor3 = Color3.fromRGB(40,40,60)
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0,15)

    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((defV-minV)/(maxV-minV),0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(200,80,255)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0,15)

    local knob = Instance.new("TextButton", bar)
    knob.Size = UDim2.new(0,52,0,52)
    knob.Position = UDim2.new((defV-minV)/(maxV-minV),-26,0,-11)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.Text = ""
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local sliderDragging = false
    knob.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            sliderDragging = true
        end
    end)
    knob.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            sliderDragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if sliderDragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local relative = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local value = math.floor(minV + (maxV - minV) * relative)
            fill.Size = UDim2.new(relative,0,1,0)
            knob.Position = UDim2.new(relative,-26,0,-11)
            valueLabel.Text = value
            slideCB(value)
        end
    end)

    yPos = yPos + 160
    main.CanvasSize = UDim2.new(0,0,0,yPos + 100)
end

-- SECCIONES REALES
addSection("FLY HACK", "FLY", Color3.fromRGB(230,50,80), Color3.fromRGB(0,240,0), "Fly Speed", 20, 800, 100,
    function(v) flySpeed = v end,
    function(on)
        flying = on
        if on then
            spawn(function()
                local char = player.Character or player.CharacterAdded:Wait()
                local hrp = char:WaitForChild("HumanoidRootPart")
                local hum = char:WaitForChild("Humanoid")
                hum.PlatformStand = true
                local bv = Instance.new("BodyVelocity", hrp)
                bv.MaxForce = Vector3.new(1e9,1e9,1e9)
                local bg = Instance.new("BodyGyro", hrp)
                bg.MaxTorque = Vector3.new(1e9,1e9,1e9)
                bg.P = 20000
                while flying and task.wait() do
                    bg.CFrame = cam.CFrame
                    local dir = hum.MoveDirection * flySpeed
                    local up = UserInputService:IsKeyDown(Enum.KeyCode.Space) and flySpeed or (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and -flySpeed or 0)
                    bv.Velocity = Vector3.new(dir.X, up, dir.Z)
                end
                bv:Destroy()
                bg:Destroy()
                if hum and hum.Parent then hum.PlatformStand = false end
            end)
        end
    end)

addSection("FLING AURA", "AURA", Color3.fromRGB(240,50,50), Color3.fromRGB(0,240,0), "Fling Power", 10000, 120000, 15000, function(v) flingPower = v end,
    function(on)
        flingAura = on
        if on then
            RunService.Heartbeat:Connect(function()
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local old = hrp.Velocity
                hrp.Velocity = old * flingPower + Vector3.new(0, flingPower*2.2, 0)
                RunService.RenderStepped:Wait()
                hrp.Velocity = old
            end)
        end
    end)
-- FLING ALL
local flingY = yPos + 40
local flingAll = Instance.new("TextButton", main)
flingAll.Size = UDim2.new(0.9,0,0,120)
flingAll.Position = UDim2.new(0.05,0,0,flingY)
flingAll.BackgroundColor3 = Color3.fromRGB(255,100,0)
flingAll.Text = "FLING ALL"
flingAll.TextColor3 = Color3.new(1,1,1)
flingAll.Font = Enum.Font.GothamBlack
flingAll.TextSize = 52
Instance.new("UICorner", flingAll).CornerRadius = UDim.new(0,32)
flingAll.MouseButton1Click:Connect(function()
    for _, p in Players:GetPlayers() do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            hrp.Velocity = Vector3.new(math.random(-5000,5000), 10000, math.random(-5000,5000))
            hrp.RotVelocity = Vector3.new(math.random(-30000,30000), math.random(-30000,30000), math.random(-30000,30000))
        end
    end
end)
yPos = flingY + 140

addSection("SPEED", "SPEED", Color3.fromRGB(60,140,255), Color3.fromRGB(0,240,0), "Walk Speed", 16, 700, 50,
    function(v) walkSpeed = v if speedOn and player.Character then player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v end end,
    function(on)
        speedOn = on
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character.Humanoid.WalkSpeed = on and walkSpeed or 16
        end
    end)

addSection("JUMP POWER", "JUMP", Color3.fromRGB(255,80,80), Color3.fromRGB(0,240,0), "Jump Power", 50, 1000, 100,
    function(v) jumpPower = v if jumpOn and player.Character then player.Character:FindFirstChildOfClass("Humanoid").JumpPower = v end end,
    function(on)
        jumpOn = on
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character.Humanoid.JumpPower = on and jumpPower or 50
        end
    end)

print("GOTHIKXX ULTRA 2025 CARGADO AL 100% - TODO FUNCIONA PERFECTO")
