--[[
	Vyre - Yae
	Anti-Hit + Adjustable Speed Hub + Auto Steal
]]

local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Safe GUI Parent
local targetParent = (gethui and gethui()) or PlayerGui

-- Remove existing
if targetParent:FindFirstChild("VyreYaeGui") then
	targetParent.VyreYaeGui:Destroy()
end

-- ======================
-- VARIABLES
-- ======================
local AntiHitEnabled = false
local SpeedOverrideEnabled = false
local TargetSpeed = 0
local IsTeleporting = false
local AntiRagdollEnabled = false
local AntiTrapEnabled = false
local CurrentScale = 1.0
local BgMode = 3 -- 1 = Plain Black, 2 = Transparent, 3 = Vyre Background

-- Auto Steal (from Chocola)
_G.StealProgress = 0
_G.AutoSteal = {
	StealDuration = 0.1,
	HalfHoldMax = 2.6,
	HalfEntryDelay = 0.3,
	Data = {},
	HalfHoldMin = 1.3,
	AutoStealEnabled = false,
	Mode = 'half',
	StealRadius = 80,
	HalfFireRange = 10
}

local AutoStealEnabled = false

local SpeedOptions = {0, 50, 100, 150, 200, 250, 350}
local SpeedIndex = 1

local ScaleOptions = {0.8, 1.0, 1.2, 1.4}
local ScaleIndex = 2

local TeleportPoints = {
	Vector3.new(500.62, 241.28, -366.64),
	Vector3.new(504.45, 155.80, -366.35),
	Vector3.new(508.30, 70.28, -366.03),
	Vector3.new(513.86, 70.28, -366.25),
	Vector3.new(519.43, 70.28, -366.47),
	Vector3.new(524.32, 70.28, -366.59),
	Vector3.new(529.22, 70.28, -366.71),
	Vector3.new(538.01, 70.28, -365.55),
	Vector3.new(546.80, 70.28, -364.40)
}

-- ======================
-- GUI CREATION
-- ======================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VyreYaeGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.DisplayOrder = 1000
screenGui.Parent = targetParent

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 260, 0, 215)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -107)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
mainFrame.BackgroundTransparency = 0.25
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local uiScale = Instance.new("UIScale")
uiScale.Scale = 1.0
uiScale.Parent = mainFrame

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(138, 43, 226)
uiStroke.Thickness = 1.5
uiStroke.Parent = mainFrame

-- Background Image Layer
local bgImage = Instance.new("Frame")
bgImage.Name = "BgLayer"
bgImage.Size = UDim2.fromScale(1, 1)
bgImage.BackgroundColor3 = Color3.fromRGB(45, 25, 80)
bgImage.BackgroundTransparency = 0.55
bgImage.BorderSizePixel = 0
bgImage.ZIndex = 0
bgImage.Parent = mainFrame

local bgCorner = Instance.new("UICorner")
bgCorner.CornerRadius = UDim.new(0, 12)
bgCorner.Parent = bgImage

-- Logo
local logo = Instance.new("Frame")
logo.Size = UDim2.fromOffset(30, 30)
logo.Position = UDim2.new(0, 10, 0, 8)
logo.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
logo.BorderSizePixel = 0
logo.ZIndex = 2
logo.Parent = mainFrame

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 8)
logoCorner.Parent = logo

local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.fromScale(1, 1)
logoText.BackgroundTransparency = 1
logoText.Text = "V"
logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
logoText.TextSize = 16
logoText.Font = Enum.Font.GothamBold
logoText.ZIndex = 3
logoText.Parent = logo

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 0, 30)
titleLabel.Position = UDim2.new(0, 46, 0, 6)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Vyre - Yae"
titleLabel.TextColor3 = Color3.fromRGB(220, 180, 255)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 2
titleLabel.Parent = mainFrame

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(24, 24)
closeBtn.Position = UDim2.new(1, -32, 0, 9)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.ZIndex = 2
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- Tabs
local tabMainBtn = Instance.new("TextButton")
tabMainBtn.Size = UDim2.new(0.5, -12, 0, 24)
tabMainBtn.Position = UDim2.new(0, 10, 0, 42)
tabMainBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
tabMainBtn.Text = "Main"
tabMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tabMainBtn.TextSize = 12
tabMainBtn.Font = Enum.Font.GothamBold
tabMainBtn.ZIndex = 2
tabMainBtn.Parent = mainFrame

local tabMainCorner = Instance.new("UICorner")
tabMainCorner.CornerRadius = UDim.new(0, 6)
tabMainCorner.Parent = tabMainBtn

local tabMiscBtn = Instance.new("TextButton")
tabMiscBtn.Size = UDim2.new(0.5, -12, 0, 24)
tabMiscBtn.Position = UDim2.new(0.5, 2, 0, 42)
tabMiscBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
tabMiscBtn.Text = "Misc"
tabMiscBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
tabMiscBtn.TextSize = 12
tabMiscBtn.Font = Enum.Font.GothamSemibold
tabMiscBtn.ZIndex = 2
tabMiscBtn.Parent = mainFrame

local tabMiscCorner = Instance.new("UICorner")
tabMiscCorner.CornerRadius = UDim.new(0, 6)
tabMiscCorner.Parent = tabMiscBtn

-- Tab Containers (Scrolling so UI size stays the same)
local mainTabContainer = Instance.new("ScrollingFrame")
mainTabContainer.Size = UDim2.new(1, 0, 1, -90)
mainTabContainer.Position = UDim2.new(0, 0, 0, 72)
mainTabContainer.BackgroundTransparency = 1
mainTabContainer.Visible = true
mainTabContainer.ZIndex = 2
mainTabContainer.BorderSizePixel = 0
mainTabContainer.ScrollBarThickness = 4
mainTabContainer.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
mainTabContainer.CanvasSize = UDim2.new(0, 0, 0, 210)
mainTabContainer.ScrollingDirection = Enum.ScrollingDirection.Y
mainTabContainer.Parent = mainFrame

local miscTabContainer = Instance.new("Frame")
miscTabContainer.Size = UDim2.new(1, 0, 1, -90)
miscTabContainer.Position = UDim2.new(0, 0, 0, 72)
miscTabContainer.BackgroundTransparency = 1
miscTabContainer.Visible = false
miscTabContainer.ZIndex = 2
miscTabContainer.Parent = mainFrame

-- Tab Switching
tabMainBtn.MouseButton1Click:Connect(function()
	mainTabContainer.Visible = true
	miscTabContainer.Visible = false
	tabMainBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
	tabMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	tabMainBtn.Font = Enum.Font.GothamBold
	tabMiscBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
	tabMiscBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
	tabMiscBtn.Font = Enum.Font.GothamSemibold
end)

tabMiscBtn.MouseButton1Click:Connect(function()
	mainTabContainer.Visible = false
	miscTabContainer.Visible = true
	tabMiscBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
	tabMiscBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	tabMiscBtn.Font = Enum.Font.GothamBold
	tabMainBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
	tabMainBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
	tabMainBtn.Font = Enum.Font.GothamSemibold
end)

-- ======================
-- MAIN TAB BUTTONS
-- ======================

-- Auto Steal Button (from Chocola) - placed ABOVE Anti-Hit
local autoStealBtn = Instance.new("TextButton")
autoStealBtn.Name = "AutoStealBtn"
autoStealBtn.Size = UDim2.new(1, -20, 0, 34)
autoStealBtn.Position = UDim2.new(0, 10, 0, 4)
autoStealBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
autoStealBtn.BackgroundTransparency = 0.15
autoStealBtn.Text = "Auto Steal: OFF"
autoStealBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoStealBtn.TextSize = 13
autoStealBtn.Font = Enum.Font.GothamSemibold
autoStealBtn.ZIndex = 2
autoStealBtn.Parent = mainTabContainer

local autoStealCorner = Instance.new("UICorner")
autoStealCorner.CornerRadius = UDim.new(0, 8)
autoStealCorner.Parent = autoStealBtn

local autoStealStatus = Instance.new("Frame")
autoStealStatus.Size = UDim2.fromOffset(9, 9)
autoStealStatus.Position = UDim2.new(1, -20, 0.5, -4)
autoStealStatus.BackgroundColor3 = Color3.fromRGB(70, 70, 85)
autoStealStatus.BorderSizePixel = 0
autoStealStatus.ZIndex = 3
autoStealStatus.Parent = autoStealBtn

local autoStealStatusCorner = Instance.new("UICorner")
autoStealStatusCorner.CornerRadius = UDim.new(1, 0)
autoStealStatusCorner.Parent = autoStealStatus

-- Anti-Hit Button
local antiHitBtn = Instance.new("TextButton")
antiHitBtn.Name = "AntiHitBtn"
antiHitBtn.Size = UDim2.new(1, -20, 0, 34)
antiHitBtn.Position = UDim2.new(0, 10, 0, 44)
antiHitBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
antiHitBtn.BackgroundTransparency = 0.15
antiHitBtn.Text = "Anti-Hit: OFF"
antiHitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
antiHitBtn.TextSize = 13
antiHitBtn.Font = Enum.Font.GothamSemibold
antiHitBtn.ZIndex = 2
antiHitBtn.Parent = mainTabContainer

local antiCorner = Instance.new("UICorner")
antiCorner.CornerRadius = UDim.new(0, 8)
antiCorner.Parent = antiHitBtn

local antiStatus = Instance.new("Frame")
antiStatus.Size = UDim2.fromOffset(9, 9)
antiStatus.Position = UDim2.new(1, -20, 0.5, -4)
antiStatus.BackgroundColor3 = Color3.fromRGB(70, 70, 85)
antiStatus.BorderSizePixel = 0
antiStatus.ZIndex = 3
antiStatus.Parent = antiHitBtn

local antiStatusCorner = Instance.new("UICorner")
antiStatusCorner.CornerRadius = UDim.new(1, 0)
antiStatusCorner.Parent = antiStatus

-- Speed Button (Adjustable)
local speedBtn = Instance.new("TextButton")
speedBtn.Name = "SpeedBtn"
speedBtn.Size = UDim2.new(1, -20, 0, 34)
speedBtn.Position = UDim2.new(0, 10, 0, 84)
speedBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
speedBtn.BackgroundTransparency = 0.15
speedBtn.Text = "Speed: 0 (OFF)"
speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBtn.TextSize = 13
speedBtn.Font = Enum.Font.GothamSemibold
speedBtn.ZIndex = 2
speedBtn.Parent = mainTabContainer

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedBtn

local speedStatus = Instance.new("Frame")
speedStatus.Size = UDim2.fromOffset(9, 9)
speedStatus.Position = UDim2.new(1, -20, 0.5, -4)
speedStatus.BackgroundColor3 = Color3.fromRGB(70, 70, 85)
speedStatus.BorderSizePixel = 0
speedStatus.ZIndex = 3
speedStatus.Parent = speedBtn

local speedStatusCorner = Instance.new("UICorner")
speedStatusCorner.CornerRadius = UDim.new(1, 0)
speedStatusCorner.Parent = speedStatus

-- Anti Ragdoll Button
local antiRagdollBtn = Instance.new("TextButton")
antiRagdollBtn.Name = "AntiRagdollBtn"
antiRagdollBtn.Size = UDim2.new(1, -20, 0, 34)
antiRagdollBtn.Position = UDim2.new(0, 10, 0, 124)
antiRagdollBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
antiRagdollBtn.BackgroundTransparency = 0.15
antiRagdollBtn.Text = "Anti Ragdoll: OFF"
antiRagdollBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
antiRagdollBtn.TextSize = 13
antiRagdollBtn.Font = Enum.Font.GothamSemibold
antiRagdollBtn.ZIndex = 2
antiRagdollBtn.Parent = mainTabContainer

local antiRagdollCorner = Instance.new("UICorner")
antiRagdollCorner.CornerRadius = UDim.new(0, 8)
antiRagdollCorner.Parent = antiRagdollBtn

local antiRagdollStatus = Instance.new("Frame")
antiRagdollStatus.Size = UDim2.fromOffset(9, 9)
antiRagdollStatus.Position = UDim2.new(1, -20, 0.5, -4)
antiRagdollStatus.BackgroundColor3 = Color3.fromRGB(70, 70, 85)
antiRagdollStatus.BorderSizePixel = 0
antiRagdollStatus.ZIndex = 3
antiRagdollStatus.Parent = antiRagdollBtn

local antiRagdollStatusCorner = Instance.new("UICorner")
antiRagdollStatusCorner.CornerRadius = UDim.new(1, 0)
antiRagdollStatusCorner.Parent = antiRagdollStatus

-- Anti Trap Button
local antiTrapBtn = Instance.new("TextButton")
antiTrapBtn.Name = "AntiTrapBtn"
antiTrapBtn.Size = UDim2.new(1, -20, 0, 34)
antiTrapBtn.Position = UDim2.new(0, 10, 0, 164)
antiTrapBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
antiTrapBtn.BackgroundTransparency = 0.15
antiTrapBtn.Text = "Anti Trap: OFF"
antiTrapBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
antiTrapBtn.TextSize = 13
antiTrapBtn.Font = Enum.Font.GothamSemibold
antiTrapBtn.ZIndex = 2
antiTrapBtn.Parent = mainTabContainer

local antiTrapCorner = Instance.new("UICorner")
antiTrapCorner.CornerRadius = UDim.new(0, 8)
antiTrapCorner.Parent = antiTrapBtn

local antiTrapStatus = Instance.new("Frame")
antiTrapStatus.Size = UDim2.fromOffset(9, 9)
antiTrapStatus.Position = UDim2.new(1, -20, 0.5, -4)
antiTrapStatus.BackgroundColor3 = Color3.fromRGB(70, 70, 85)
antiTrapStatus.BorderSizePixel = 0
antiTrapStatus.ZIndex = 3
antiTrapStatus.Parent = antiTrapBtn

local antiTrapStatusCorner = Instance.new("UICorner")
antiTrapStatusCorner.CornerRadius = UDim.new(1, 0)
antiTrapStatusCorner.Parent = antiTrapStatus

-- ======================
-- MISC TAB BUTTONS
-- ======================

local bgBtn = Instance.new("TextButton")
bgBtn.Name = "BgBtn"
bgBtn.Size = UDim2.new(1, -20, 0, 34)
bgBtn.Position = UDim2.new(0, 10, 0, 4)
bgBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
bgBtn.BackgroundTransparency = 0.15
bgBtn.Text = "Background: Vyre"
bgBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
bgBtn.TextSize = 13
bgBtn.Font = Enum.Font.GothamSemibold
bgBtn.ZIndex = 2
bgBtn.Parent = miscTabContainer

local bgCorner = Instance.new("UICorner")
bgCorner.CornerRadius = UDim.new(0, 8)
bgCorner.Parent = bgBtn

local scaleBtn = Instance.new("TextButton")
scaleBtn.Name = "ScaleBtn"
scaleBtn.Size = UDim2.new(1, -20, 0, 34)
scaleBtn.Position = UDim2.new(0, 10, 0, 44)
scaleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
scaleBtn.BackgroundTransparency = 0.15
scaleBtn.Text = "GUI Scale: 1.0x"
scaleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scaleBtn.TextSize = 13
scaleBtn.Font = Enum.Font.GothamSemibold
scaleBtn.ZIndex = 2
scaleBtn.Parent = miscTabContainer

local scaleCorner = Instance.new("UICorner")
scaleCorner.CornerRadius = UDim.new(0, 8)
scaleCorner.Parent = scaleBtn

-- Footer
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 18)
footer.Position = UDim2.new(0, 0, 1, -22)
footer.BackgroundTransparency = 1
footer.Text = "Vyre Script"
footer.TextColor3 = Color3.fromRGB(140, 120, 170)
footer.TextSize = 11
footer.Font = Enum.Font.Gotham
footer.ZIndex = 2
footer.Parent = mainFrame

-- ======================
-- TELEPORT OVERLAY
-- ======================
local teleportOverlay = Instance.new("Frame")
teleportOverlay.Name = "TeleportOverlay"
teleportOverlay.Size = UDim2.fromScale(1, 1)
teleportOverlay.BackgroundColor3 = Color3.fromRGB(8, 7, 14)
teleportOverlay.BackgroundTransparency = 1
teleportOverlay.Visible = false
teleportOverlay.ZIndex = 50
teleportOverlay.Parent = screenGui

local overlayLogo = Instance.new("Frame")
overlayLogo.AnchorPoint = Vector2.new(0.5, 0.5)
overlayLogo.Position = UDim2.new(0.5, 0, 0.42, 0)
overlayLogo.Size = UDim2.fromOffset(80, 80)
overlayLogo.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
overlayLogo.BorderSizePixel = 0
overlayLogo.ZIndex = 51
overlayLogo.Parent = teleportOverlay

local overlayLogoCorner = Instance.new("UICorner")
overlayLogoCorner.CornerRadius = UDim.new(0, 16)
overlayLogoCorner.Parent = overlayLogo

local overlayLogoText = Instance.new("TextLabel")
overlayLogoText.Size = UDim2.fromScale(1, 1)
overlayLogoText.BackgroundTransparency = 1
overlayLogoText.Text = "V"
overlayLogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
overlayLogoText.TextSize = 32
overlayLogoText.Font = Enum.Font.GothamBold
overlayLogoText.ZIndex = 52
overlayLogoText.Parent = overlayLogo

local loadingText = Instance.new("TextLabel")
loadingText.AnchorPoint = Vector2.new(0.5, 0)
loadingText.Position = UDim2.new(0.5, 0, 0.52, 12)
loadingText.Size = UDim2.fromOffset(300, 28)
loadingText.BackgroundTransparency = 1
loadingText.Text = "anti hit almost loaded"
loadingText.TextColor3 = Color3.fromRGB(200, 160, 240)
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 15
loadingText.ZIndex = 51
loadingText.Parent = teleportOverlay

local loadingBarBg = Instance.new("Frame")
loadingBarBg.AnchorPoint = Vector2.new(0.5, 0)
loadingBarBg.Position = UDim2.new(0.5, 0, 0.58, 10)
loadingBarBg.Size = UDim2.fromOffset(200, 5)
loadingBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
loadingBarBg.BorderSizePixel = 0
loadingBarBg.ZIndex = 51
loadingBarBg.Parent = teleportOverlay

local barBgCorner = Instance.new("UICorner")
barBgCorner.CornerRadius = UDim.new(1, 0)
barBgCorner.Parent = loadingBarBg

local loadingBarFill = Instance.new("Frame")
loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
loadingBarFill.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
loadingBarFill.BorderSizePixel = 0
loadingBarFill.ZIndex = 52
loadingBarFill.Parent = loadingBarBg

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(1, 0)
barFillCorner.Parent = loadingBarFill

-- ======================
-- LOGIC
-- ======================

-- Speed Enforcement
RunService.Heartbeat:Connect(function()
	if SpeedOverrideEnabled then
		local character = LocalPlayer.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.WalkSpeed ~= TargetSpeed then
				humanoid.WalkSpeed = TargetSpeed
			end
		end
	end
end)

-- Auto Steal Toggle (from Chocola)
autoStealBtn.MouseButton1Click:Connect(function()
	AutoStealEnabled = not AutoStealEnabled
	_G.AutoSteal.AutoStealEnabled = AutoStealEnabled

	if AutoStealEnabled then
		autoStealBtn.Text = "Auto Steal: ON"
		autoStealBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
		autoStealStatus.BackgroundColor3 = Color3.fromRGB(110, 255, 150)
	else
		autoStealBtn.Text = "Auto Steal: OFF"
		autoStealBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
		autoStealStatus.BackgroundColor3 = Color3.fromRGB(70, 70, 85)
		_G.StealProgress = 0
	end
end)

-- Anti-Hit Button
antiHitBtn.MouseButton1Click:Connect(function()
	AntiHitEnabled = not AntiHitEnabled
	if AntiHitEnabled then
		antiHitBtn.Text = "Anti-Hit: ON"
		antiHitBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
		antiStatus.BackgroundColor3 = Color3.fromRGB(110, 255, 150)
	else
		antiHitBtn.Text = "Anti-Hit: OFF"
		antiHitBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
		antiStatus.BackgroundColor3 = Color3.fromRGB(70, 70, 85)
	end
end)

-- Speed Button (Cycle)
speedBtn.MouseButton1Click:Connect(function()
	SpeedIndex = SpeedIndex + 1
	if SpeedIndex > #SpeedOptions then
		SpeedIndex = 1
	end

	TargetSpeed = SpeedOptions[SpeedIndex]
	SpeedOverrideEnabled = TargetSpeed > 0

	if SpeedOverrideEnabled then
		speedBtn.Text = "Speed: " .. TargetSpeed
		speedBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
		speedStatus.BackgroundColor3 = Color3.fromRGB(110, 255, 150)
	else
		speedBtn.Text = "Speed: 0 (OFF)"
		speedBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
		speedStatus.BackgroundColor3 = Color3.fromRGB(70, 70, 85)

		local character = LocalPlayer.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.WalkSpeed = 16
			end
		end
	end
end)

-- Background Cycle
bgBtn.MouseButton1Click:Connect(function()
	BgMode = BgMode + 1
	if BgMode > 3 then BgMode = 1 end

	if BgMode == 1 then
		bgBtn.Text = "Background: Plain Black"
		bgImage.Visible = false
		mainFrame.BackgroundTransparency = 0.1
	elseif BgMode == 2 then
		bgBtn.Text = "Background: Transparent"
		bgImage.Visible = false
		mainFrame.