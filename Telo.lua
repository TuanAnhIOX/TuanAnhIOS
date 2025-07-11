local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local root

local function updateCharacter()
    local char = player.Character or player.CharacterAdded:Wait()
    root = char:WaitForChild("HumanoidRootPart", 5)
end
updateCharacter()
player.CharacterAdded:Connect(updateCharacter)

local function goUp()
    if root then
        local currentPos = root.Position
        local targetPos = currentPos + Vector3.new(0, 200, 0)
        TweenService:Create(root, TweenInfo.new(1.2), {CFrame = CFrame.new(targetPos)}):Play()
    end
end

local function dropDown()
    if root then
        root.CFrame -= Vector3.new(0, 50, 0)
    end
end

-- UI VIP
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "TeleportGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 150, 0, 50)
frame.Position = UDim2.new(1, -160, 0, 60)
frame.AnchorPoint = Vector2.new(0, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0

local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
RunService.Heartbeat:Connect(function()
	stroke.Color = Color3.fromHSV(tick() * 0.2 % 1, 1, 1)
end)

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(1, -20, 1, -20)
button.Position = UDim2.new(0, 10, 0, 10)
button.BackgroundColor3 = Color3.fromRGB(255, 90, 90)
button.Text = "Tuấn Anh IOS"
button.TextScaled = true
button.Font = Enum.Font.GothamSemibold
button.TextColor3 = Color3.new(1, 1, 1)
button.TextStrokeTransparency = 0.5
button.TextStrokeColor3 = Color3.new(0, 0, 0)
button.AutoButtonColor = false

local bCorner = Instance.new("UICorner", button)
bCorner.CornerRadius = UDim.new(0, 10)

local glowPulse = Instance.new("ImageLabel", button)
glowPulse.Size = UDim2.new(1, 0, 1, 0)
glowPulse.BackgroundTransparency = 1
glowPulse.Image = "rbxassetid://110657725541747" -- glow effect
glowPulse.ImageTransparency = 1
glowPulse.ZIndex = 0

-- Drag UI
do
	local dragging, dragInput, dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging, dragStart, startPos = true, input.Position, frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInput.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

-- Toggle Logic
local enabled = false
local function tween(object, props, time, easing)
	TweenService:Create(object, TweenInfo.new(time or 0.25, Enum.EasingStyle[easing or "Quad"], Enum.EasingDirection.Out), props):Play()
end

local function toggleTeleport(state)
	enabled = state
	button.Text = state and "⬆️ Tele ⬆️" or "⬇️ Tele ⬇️"
	tween(button, {
		BackgroundColor3 = state and Color3.fromRGB(60, 220, 120) or Color3.fromRGB(255, 90, 90)
	}, 0.3)

	glowPulse.ImageTransparency = 0.7
	glowPulse.Size = UDim2.new(1, 0, 1, 0)
	tween(glowPulse, {
		ImageTransparency = 1,
		Size = UDim2.new(1.4, 0, 1.4, 0)
	}, 0.4, "Quad")

	tween(button, {Size = UDim2.new(1, -10, 1, -10)}, 0.1, "Sine")
	task.delay(0.1, function()
		tween(button, {Size = UDim2.new(1, -20, 1, -20)}, 0.1, "Sine")
	end)

	if state then
		goUp()
	else
		dropDown()
	end
end

button.MouseButton1Click:Connect(function()
	toggleTeleport(not enabled)
end)
