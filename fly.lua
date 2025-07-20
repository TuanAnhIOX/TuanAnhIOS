local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name = "TuanAnhFlyUI"
gui.ResetOnSpawn = false

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 120, 0, 35)
btn.Position = UDim2.new(1, -210, 0, 10)
btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
btn.Text = "Tuấn Anh IOS Fly"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.TextScaled = true
btn.Font = Enum.Font.GothamBold
btn.Parent = gui
btn.Active = true

Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", btn)
stroke.Thickness = 3
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local rainbow = {
    Color3.fromRGB(255, 0, 0),    -- đỏ
    Color3.fromRGB(255, 127, 0),  -- cam
    Color3.fromRGB(255, 255, 0),  -- vàng
    Color3.fromRGB(0, 255, 0),    -- lục
    Color3.fromRGB(0, 0, 255),    -- lam
    Color3.fromRGB(75, 0, 130),   -- chàm
    Color3.fromRGB(148, 0, 211)   -- tím
}

task.spawn(function()
    local i = 1
    while gui.Parent do
        local color = rainbow[i]
        stroke.Color = color
        btn.TextColor3 = color
        i = (i % #rainbow) + 1
        task.wait(0.5)
    end
end)

local flying, conn, speed = false, nil, 50

local function stopFly()
    if not flying then return end
    flying, _G.FlyActive = false, false
    if conn then conn:Disconnect(); conn = nil end
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local bv = hrp:FindFirstChild("FlyBV")
        if bv then bv:Destroy() end
    end
end

local function startFly()
    if flying then return end
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end

    hrp.CFrame += Vector3.new(0, 5, 0)
    local bv = Instance.new("BodyVelocity")
    bv.Name = "FlyBV"
    bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp

    flying, _G.FlyActive = true, true

    conn = RunService.RenderStepped:Connect(function()
        if not char or not char.Parent then stopFly() return end
        if not hrp or not hrp.Parent then stopFly() return end

        local direction = camera.CFrame.LookVector
        bv.Velocity = Vector3.new(direction.X, 0, direction.Z).Unit * speed
        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + direction)
    end)
end

btn.MouseButton1Click:Connect(function()
    if flying then stopFly() else startFly() end
end)
