--[[
	VYRE HUB | Steal a Egg
	Fixed: Anti Hit, Anti Trap, Anti Ragdoll + WalkSpeed
	Based on variant-2 UI
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("[Vyre Hub] starting...")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local targetParent = playerGui
pcall(function()
	if typeof(gethui) == "function" then
		local h = gethui()
		if typeof(h) == "Instance" then
			targetParent = h
		end
	end
end)

-- Cleanup old
for _, name in ipairs({"VyreHub", "VyreYaeGui"}) do
	local old = targetParent:FindFirstChild(name)
	if old then old:Destroy() end
	old = playerGui:FindFirstChild(name)
	if old then old:Destroy() end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VyreHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 1000
screenGui.Parent = targetParent

local MAIN_COLOR = Color3.fromRGB(15, 15, 18)
local SECONDARY_COLOR = Color3.fromRGB(22, 22, 28)
local ACCENT_COLOR = Color3.fromRGB(138, 43, 226)
local ACCENT_GLOW = Color3.fromRGB(186, 85, 211)
local TEXT_COLOR = Color3.fromRGB(240, 240, 245)
local TEXT_DIM = Color3.fromRGB(140, 140, 155)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = MAIN_COLOR
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = screenGui
print("[Vyre Hub] GUI parented to " .. tostring(targetParent))

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = ACCENT_COLOR
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.3
MainStroke.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 280, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "VYRE HUB <font color=\"rgb(138,43,226)\">|</font> <font color=\"rgb(140,140,155)\">Steal a Egg</font>"
TitleLabel.RichText = true
TitleLabel.TextColor3 = TEXT_COLOR
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = SECONDARY_COLOR
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = TEXT_DIM
CloseBtn.TextSize = 12
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -70, 0, 5)
MinimizeBtn.BackgroundColor3 = SECONDARY_COLOR
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = TEXT_DIM
MinimizeBtn.TextSize = 14
MinimizeBtn.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinimizeBtn

local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _, child in ipairs(MainFrame:GetChildren()) do
		if child ~= TopBar and child ~= MainCorner and child ~= MainStroke then
			child.Visible = not minimized
		end
	end
	TweenService:Create(MainFrame, TweenInfo.new(0.2), {
		Size = minimized and UDim2.new(0, 520, 0, 40) or UDim2.new(0, 520, 0, 340)
	}):Play()
end)

local NavPanel = Instance.new("Frame")
NavPanel.Size = UDim2.new(0, 130, 1, -45)
NavPanel.Position = UDim2.new(0, 5, 0, 40)
NavPanel.BackgroundTransparency = 1
NavPanel.Parent = MainFrame

local NavLayout = Instance.new("UIListLayout")
NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
NavLayout.Padding = UDim.new(0, 5)
NavLayout.Parent = NavPanel

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -145, 1, -45)
ContentArea.Position = UDim2.new(0, 140, 0, 40)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local pages = {}
local navButtons = {}

local function createPage(name)
	local page = Instance.new("ScrollingFrame")
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = ACCENT_COLOR
	page.Visible = false
	page.Parent = ContentArea

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 10)
	layout.Parent = page

	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, 4)
	pad.PaddingBottom = UDim.new(0, 8)
	pad.Parent = page

	pages[name] = page
	return page
end

local function switchPage(name)
	for pName, page in pairs(pages) do
		page.Visible = (pName == name)
	end
	for bName, btn in pairs(navButtons) do
		if bName == name then
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = ACCENT_COLOR, TextColor3 = TEXT_COLOR}):Play()
		else
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = SECONDARY_COLOR, TextColor3 = TEXT_DIM}):Play()
		end
	end
end

local navNames = {"Main", "Player", "Visuals", "Settings"}
for i, name in ipairs(navNames) do
	createPage(name)

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 32)
	btn.BackgroundColor3 = (i == 1) and ACCENT_COLOR or SECONDARY_COLOR
	btn.Font = Enum.Font.GothamSemibold
	btn.Text = name
	btn.TextColor3 = (i == 1) and TEXT_COLOR or TEXT_DIM
	btn.TextSize = 13
	btn.Parent = NavPanel

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn

	btn.MouseButton1Click:Connect(function()
		switchPage(name)
	end)

	navButtons[name] = btn
end

switchPage("Main")

local function createToggle(parent, text, callback)
	local toggleFrame = Instance.new("Frame")
	toggleFrame.Size = UDim2.new(1, -10, 0, 36)
	toggleFrame.BackgroundColor3 = SECONDARY_COLOR
	toggleFrame.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = toggleFrame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -50, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamMedium
	label.Text = text
	label.TextColor3 = TEXT_COLOR
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = toggleFrame

	local switch = Instance.new("Frame")
	switch.Size = UDim2.new(0, 36, 0, 20)
	switch.Position = UDim2.new(1, -44, 0.5, -10)
	switch.BackgroundColor3 = MAIN_COLOR
	switch.Parent = toggleFrame

	local switchCorner = Instance.new("UICorner")
	switchCorner.CornerRadius = UDim.new(1, 0)
	switchCorner.Parent = switch

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.Position = UDim2.new(0, 3, 0.5, -7)
	knob.BackgroundColor3 = TEXT_DIM
	knob.Parent = switch

	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob

	local enabled = false

	local function update(ans)
		enabled = ans
		local goalSwitchColor = enabled and ACCENT_COLOR or MAIN_COLOR
		local goalKnobColor = enabled and TEXT_COLOR or TEXT_DIM
		local goalPos = enabled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)

		TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = goalSwitchColor}):Play()
		TweenService:Create(knob, TweenInfo.new(0.2), {BackgroundColor3 = goalKnobColor, Position = goalPos}):Play()

		if callback then
			callback(enabled)
		end
	end

	toggleFrame.Active = true

	local hitBtn = Instance.new("TextButton")
	hitBtn.Size = UDim2.fromScale(1, 1)
	hitBtn.BackgroundTransparency = 1
	hitBtn.Text = ""
	hitBtn.ZIndex = 5
	hitBtn.Parent = toggleFrame

	hitBtn.MouseButton1Click:Connect(function()
		update(not enabled)
	end)

	return toggleFrame
end

local function createSlider(parent, text, min, max, callback)
	local sliderFrame = Instance.new("Frame")
	sliderFrame.Size = UDim2.new(1, -10, 0, 50)
	sliderFrame.BackgroundColor3 = SECONDARY_COLOR
	sliderFrame.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = sliderFrame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -60, 0, 25)
	label.Position = UDim2.new(0, 12, 0, 3)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamMedium
	label.Text = text
	label.TextColor3 = TEXT_COLOR
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = sliderFrame

	local valueLabel = Instance.new("TextLabel")
	valueLabel.Size = UDim2.new(0, 50, 0, 25)
	valueLabel.Position = UDim2.new(1, -60, 0, 3)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.Text = tostring(min)
	valueLabel.TextColor3 = ACCENT_GLOW
	valueLabel.TextSize = 13
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Parent = sliderFrame

	local track = Instance.new("Frame")
	track.Size = UDim2.new(1, -24, 0, 6)
	track.Position = UDim2.new(0, 12, 0, 32)
	track.BackgroundColor3 = MAIN_COLOR
	track.Parent = sliderFrame

	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(1, 0)
	trackCorner.Parent = track

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = ACCENT_COLOR
	fill.Parent = track

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = fill

	local dragging = false

	local function updateValue(input)
		local sizeX = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		local val = math.floor(min + ((max - min) * sizeX))
		fill.Size = UDim2.new(sizeX, 0, 1, 0)
		valueLabel.Text = tostring(val)
		if callback then
			callback(val)
		end
	end

	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			updateValue(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateValue(input)
		end
	end)

	return sliderFrame
end

-- ======================
-- FEATURE STATE
-- ======================
local FeatureState = {
	AntiHit = false,      -- client heal
	AntiTrap = false,
	AntiRagdoll = false,
	WalkSpeed = 0,
}


local speedConnection = nil
local antiHitConnections = {}
local ragdollConnections = {}
local trapOriginals = {}
local trapDescConnections = {}
local trapScanConnection = nil

local function disconnectList(list)
	for _, c in ipairs(list) do
		pcall(function()
			c:Disconnect()
		end)
	end
	table.clear(list)
end

local function getCharacter()
	return player.Character
end

local function getHumanoid()
	local character = getCharacter()
	return character and character:FindFirstChildOfClass("Humanoid")
end

-- ======================
-- WALK SPEED (AssemblyLinearVelocity - working)
-- ======================
local function stopSpeed()
	if speedConnection then
		speedConnection:Disconnect()
		speedConnection = nil
	end
end

local function applySpeed()
	stopSpeed()
	if FeatureState.WalkSpeed <= 0 then
		return
	end

	speedConnection = RunService.Heartbeat:Connect(function()
		local character = getCharacter()
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if not humanoid or not root or humanoid.Health <= 0 then
			return
		end

		local moveDirection = humanoid.MoveDirection
		local horizontal = Vector3.new(moveDirection.X, 0, moveDirection.Z)
		if horizontal.Magnitude <= 0.001 then
			return
		end

		local velocity = horizontal.Unit * FeatureState.WalkSpeed
		local current = root.AssemblyLinearVelocity
		pcall(function()
			root.AssemblyLinearVelocity = Vector3.new(velocity.X, current.Y, velocity.Z)
		end)
	end)
end

local function setWalkSpeed(value)
	FeatureState.WalkSpeed = math.clamp(tonumber(value) or 0, 0, 300)
	applySpeed()
end

-- ======================
-- ANTI HIT (client heal - YaePogi style)
-- ======================
local function stopAntiHit()
	disconnectList(antiHitConnections)
end

local function restoreHealth(humanoid)
	if not FeatureState.AntiHit or not humanoid or not humanoid.Parent then
		return
	end
	if humanoid.Health > 0 and humanoid.Health < humanoid.MaxHealth then
		pcall(function()
			humanoid.Health = humanoid.MaxHealth
		end)
	end
end

local function hookAntiHit(character)
	stopAntiHit()
	if not FeatureState.AntiHit or not character then
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
	if not FeatureState.AntiHit or not humanoid then
		return
	end

	table.insert(antiHitConnections, humanoid.HealthChanged:Connect(function()
		restoreHealth(humanoid)
	end))

	table.insert(antiHitConnections, RunService.Heartbeat:Connect(function()
		restoreHealth(humanoid)
	end))

	restoreHealth(humanoid)
end

-- setAntiHit defined later (with overlay)

-- ======================
-- ANTI TRAP (PlacedTrap CanTouch = false)
-- ======================
local function restoreTraps()
	for part, original in pairs(trapOriginals) do
		if part and part.Parent then
			pcall(function()
				part.CanTouch = original
			end)
		end
	end
	table.clear(trapOriginals)
	disconnectList(trapDescConnections)
end

local function disableTrapPart(part)
	if not FeatureState.AntiTrap or not part or not part.Parent then
		return
	end
	if not part:IsA("BasePart") or trapOriginals[part] ~= nil then
		return
	end
	pcall(function()
		trapOriginals[part] = part.CanTouch
		part.CanTouch = false
	end)
end

local function processTrap(trap)
	if not FeatureState.AntiTrap or not trap or not trap.Parent then
		return
	end
	if trap:GetAttribute("Owner") == player.Name then
		return
	end

	disableTrapPart(trap)
	for _, descendant in ipairs(trap:GetDescendants()) do
		disableTrapPart(descendant)
	end

	table.insert(trapDescConnections, trap.DescendantAdded:Connect(function(d)
		if FeatureState.AntiTrap then
			disableTrapPart(d)
		end
	end))
end

local function applyAntiTrap()
	for _, trap in ipairs(CollectionService:GetTagged("PlacedTrap")) do
		processTrap(trap)
	end
end

local function setAntiTrap(enabled)
	FeatureState.AntiTrap = enabled == true

	if trapScanConnection then
		trapScanConnection:Disconnect()
		trapScanConnection = nil
	end

	if not FeatureState.AntiTrap then
		restoreTraps()
		return
	end

	applyAntiTrap()

	-- Re-scan every 0.5s for late-spawned traps
	local acc = 0
	trapScanConnection = RunService.Heartbeat:Connect(function(dt)
		acc = acc + dt
		if acc < 0.5 then
			return
		end
		acc = 0
		if FeatureState.AntiTrap then
			applyAntiTrap()
		end
	end)
end

CollectionService:GetInstanceAddedSignal("PlacedTrap"):Connect(function(trap)
	if FeatureState.AntiTrap then
		task.defer(processTrap, trap)
	end
end)

-- ======================
-- ANTI RAGDOLL (fixed - rehooks on respawn + Heartbeat)
-- ======================
local ragdollStates = {
	[Enum.HumanoidStateType.Physics] = true,
	[Enum.HumanoidStateType.Ragdoll] = true,
	[Enum.HumanoidStateType.FallingDown] = true,
}

local ragdollModule = nil
task.spawn(function()
	pcall(function()
		local shared = ReplicatedStorage:FindFirstChild("Shared")
		local modules = shared and shared:FindFirstChild("Modules")
		local mod = modules and modules:FindFirstChild("Ragdoll")
		if mod then
			ragdollModule = require(mod)
		end
	end)
end)

local function stopAntiRagdoll()
	disconnectList(ragdollConnections)
end

local function forceUnragdoll(character, humanoid)
	if not FeatureState.AntiRagdoll then
		return
	end
	humanoid = humanoid or (character and character:FindFirstChildOfClass("Humanoid"))
	if not humanoid or not humanoid.Parent then
		return
	end

	pcall(function()
		if humanoid.PlatformStand then
			humanoid.PlatformStand = false
		end
	end)

	pcall(function()
		local state = humanoid:GetState()
		if ragdollStates[state] then
			humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		end
	end)

	if character then
		for _, d in ipairs(character:GetDescendants()) do
			if d:IsA("Constraint") and string.find(d.Name, "RagdollConstraint", 1, true) then
				pcall(function()
					d:Destroy()
				end)
			end
		end
	end

	if type(ragdollModule) == "table" then
		if type(ragdollModule.ClearClientRagdoll) == "function" then
			pcall(ragdollModule.ClearClientRagdoll)
		end
		if type(ragdollModule.Unragdoll) == "function" and character then
			pcall(ragdollModule.Unragdoll, character)
		end
	end
end

local function hookAntiRagdoll(character)
	stopAntiRagdoll()
	if not FeatureState.AntiRagdoll or not character then
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
	if not FeatureState.AntiRagdoll or not humanoid then
		return
	end

	pcall(function()
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
	end)

	table.insert(ragdollConnections, humanoid.StateChanged:Connect(function(_, newState)
		if FeatureState.AntiRagdoll and ragdollStates[newState] then
			forceUnragdoll(character, humanoid)
		end
	end))

	table.insert(ragdollConnections, humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
		if FeatureState.AntiRagdoll and humanoid.PlatformStand then
			forceUnragdoll(character, humanoid)
		end
	end))

	table.insert(ragdollConnections, character.DescendantAdded:Connect(function(d)
		if FeatureState.AntiRagdoll and d:IsA("Constraint") and string.find(d.Name, "RagdollConstraint", 1, true) then
			forceUnragdoll(character, humanoid)
		end
	end))

	table.insert(ragdollConnections, player:GetAttributeChangedSignal("RagdollEndTime"):Connect(function()
		if FeatureState.AntiRagdoll then
			forceUnragdoll(character, humanoid)
		end
	end))

	-- Continuous recovery every frame
	table.insert(ragdollConnections, RunService.Heartbeat:Connect(function()
		if not FeatureState.AntiRagdoll then
			return
		end
		if not character.Parent or not humanoid.Parent then
			return
		end
		if humanoid.PlatformStand or ragdollStates[humanoid:GetState()] then
			forceUnragdoll(character, humanoid)
		end
	end))

	forceUnragdoll(character, humanoid)
end

local function setAntiRagdoll(enabled)
	FeatureState.AntiRagdoll = enabled == true
	stopAntiRagdoll()

	if FeatureState.AntiRagdoll then
		hookAntiRagdoll(getCharacter())
	else
		-- Re-enable states when off
		local humanoid = getHumanoid()
		if humanoid then
			pcall(function()
				humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
				humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
				humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
			end)
		end
	end
end

-- Respawn: re-hook all active features
player.CharacterAdded:Connect(function(character)
	task.defer(function()
		if FeatureState.AntiHit then
			hookAntiHit(character)
		end
		if FeatureState.AntiRagdoll then
			hookAntiRagdoll(character)
		end
		if FeatureState.WalkSpeed > 0 then
			applySpeed()
		end
	end)
end)

-- ======================
-- ANTI HIT SAFE CARRY (overlay + no auto-base)
-- Goal: you walk the egg to base yourself; client tries to keep you alive
-- (heal). Monsters are mostly server-sided -- heal + ragdoll help most.
-- ======================
local teleportOverlay = Instance.new("Frame")
teleportOverlay.Name = "AntiHitOverlay"
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
overlayLogo.BackgroundColor3 = ACCENT_COLOR
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
overlayLogoText.TextColor3 = TEXT_COLOR
overlayLogoText.TextSize = 32
overlayLogoText.Font = Enum.Font.GothamBold
overlayLogoText.ZIndex = 52
overlayLogoText.Parent = overlayLogo

local loadingText = Instance.new("TextLabel")
loadingText.AnchorPoint = Vector2.new(0.5, 0)
loadingText.Position = UDim2.new(0.5, 0, 0.52, 12)
loadingText.Size = UDim2.fromOffset(320, 28)
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
loadingBarFill.BackgroundColor3 = ACCENT_COLOR
loadingBarFill.BorderSizePixel = 0
loadingBarFill.ZIndex = 52
loadingBarFill.Parent = loadingBarBg

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(1, 0)
barFillCorner.Parent = loadingBarFill

local function playAntiHitOverlay()
	teleportOverlay.Visible = true
	teleportOverlay.BackgroundTransparency = 0
	loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
	loadingText.Text = "anti hit almost loaded"

	for i = 1, 8 do
		loadingBarFill.Size = UDim2.new(i / 8, 0, 1, 0)
		if i == 8 then
			loadingText.Text = "anti hit loaded!"
		end
		task.wait(0.06)
	end

	task.wait(0.2)
	local fadeOut = TweenService:Create(
		teleportOverlay,
		TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ BackgroundTransparency = 1 }
	)
	fadeOut:Play()
	fadeOut.Completed:Wait()
	teleportOverlay.Visible = false
end

-- Anti Hit = heal + overlay (NO auto teleport to base)
-- You carry the egg manually; script only tries to keep Health full
local function setAntiHit(enabled)
	FeatureState.AntiHit = enabled == true
	stopAntiHit()
	if FeatureState.AntiHit then
		task.spawn(playAntiHitOverlay)
		hookAntiHit(getCharacter())
	end
end

-- ======================
-- UI: Main page features
-- ======================

local mainPage = pages["Main"]
createToggle(mainPage, "Anti Hit (Safe Carry)", setAntiHit)
createToggle(mainPage, "Anti Trap", setAntiTrap)
createToggle(mainPage, "Anti Ragdoll", setAntiRagdoll)
createSlider(mainPage, "WalkSpeed", 0, 300, setWalkSpeed)

-- ======================
-- WINDOW DRAG
-- ======================
local draggingWindow, dragInput, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingWindow = true
		dragStart = input.Position
		startPos = MainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				draggingWindow = false
			end
		end)
	end
end)

TopBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and draggingWindow then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

print("[Vyre Hub] Loaded - Anti Hit Heal + TP / Trap / Ragdoll / WalkSpeed")
