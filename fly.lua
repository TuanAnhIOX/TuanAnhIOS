local Players, RunService, UIS = game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService")
local lp = Players.LocalPlayer

local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local btn = Instance.new("TextButton", gui)
btn.Size, btn.Position = UDim2.new(0, 200, 0, 50), UDim2.new(1, -210, 0, 10)
btn.Text = "Tuấn Anh IOS Fly"
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke", btn); stroke.Thickness = 2
local rainbow = {
    Color3.fromRGB(255,0,0),  Color3.fromRGB(255,127,0), Color3.fromRGB(255,255,0),
    Color3.fromRGB(0,255,0),  Color3.fromRGB(0,0,255),   Color3.fromRGB(75,0,130),
    Color3.fromRGB(148,0,211)
}

task.spawn(function()
    local i = 1
    while gui.Parent do
        stroke.Color = rainbow[i]
        if not _G.FlyActive then          -- nền đổi màu khi không bay
            btn.BackgroundColor3 = rainbow[i]
        end
        i = i % #rainbow + 1
        task.wait(0.2)
    end
end)

btn.Active = true
local dragging, dragStart, startPos
btn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
       or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, input.Position, btn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                     or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        btn.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

local flying, conn, speed, lastDir = false, nil, 50, Vector3.new(0,0,-1)
local function stopFly()
    if not flying then return end
    flying, _G.FlyActive = false, false
    if conn then conn:Disconnect(); conn = nil end
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if hrp then local bv = hrp:FindFirstChild("FlyBV"); if bv then bv:Destroy() end end
end

local function startFly()
    if flying then return end
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp  = char:WaitForChild("HumanoidRootPart")
    local hum  = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    hrp.CFrame += Vector3.new(0,5,0)
    local bv = Instance.new("BodyVelocity")
    bv.Name, bv.MaxForce, bv.Parent = "FlyBV", Vector3.new(9e4,9e4,9e4), hrp
    lastDir, flying, _G.FlyActive = hrp.CFrame.LookVector, true, true
    btn.BackgroundColor3 = Color3.fromRGB(85,255,127)            -- xanh khi bay
    conn = RunService.RenderStepped:Connect(function()
        if not char.Parent then stopFly(); return end
        local move = hum.MoveDirection
        if move.Magnitude > 0.05 then lastDir = move.Unit end
        bv.Velocity = Vector3.new(lastDir.X,0,lastDir.Z) * speed
    end)
    task.delay(15, stopFly)
end

btn.MouseButton1Click:Connect(function()
    if flying then stopFly() else startFly() end
end)