--[[
	Vyre Hub | Multiverse Script Sae
	Script launcher + Config (scale / themes)
	Minimize to compact bar
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local guiName = "VyreHubMultiverseSaw"

local parentContainer = playerGui
pcall(function()
	if typeof(gethui) == "function" then
		local h = gethui()
		if typeof(h) == "Instance" then
			parentContainer = h
		end
	end
end)

if parentContainer:FindFirstChild(guiName) then
	parentContainer[guiName]:Destroy()
end

-- ======================
-- SCRIPT LIST (put your raw URLs here later)
-- url = "" means empty for now
-- ======================
-- Keyless scripts (no key system)
local scriptsData = {
	{ name = "Fyy", url = "" },
	{ name = "Clover", url = "" },
	{ name = "Lemon", url = "" },
	{ name = "Limbo", url = "" },
	{ name = "Real Kid", url = "" },
	{ name = "Miranda", url = "" },
}

-- Key scripts (with key system) — add URLs later
local scriptsDataKey = {
	{ name = "Key Script 1", url = "" },
	{ name = "Key Script 2", url = "" },
	{ name = "Key Script 3", url = "" },
	{ name = "Key Script 4", url = "" },
}

local themes = {
	{ name = "Dark", color = Color3.fromRGB(120, 120, 140) },
	{ name = "Red", color = Color3.fromRGB(255, 60, 80) },
	{ name = "Purple", color = Color3.fromRGB(180, 70, 255) },
	{ name = "Blue", color = Color3.fromRGB(60, 140, 255) },
	{ name = "Cyan", color = Color3.fromRGB(50, 230, 255) },
	{ name = "Green", color = Color3.fromRGB(50, 255, 140) },
	{ name = "Gold", color = Color3.fromRGB(255, 200, 50) },
	{ name = "Pink", color = Color3.fromRGB(255, 90, 180) },
	{ name = "Orange", color = Color3.fromRGB(255, 140, 40) },
	{ name = "White", color = Color3.fromRGB(240, 240, 255) },
}
local currentTheme = themes[3].color

local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 1000
screenGui.Parent = parentContainer

-- Scale applies to main window + compact bar only (avoids layout stretch)
local uiScale = Instance.new("UIScale")
uiScale.Scale = 1

-- Main window
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 520, 0, 360)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Parent = screenGui
uiScale.Parent = mainFrame

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = currentTheme
mainStroke.Thickness = 2
mainStroke.Transparency = 0.15
mainStroke.Parent = mainFrame

-- Top bar
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 12)
topBarCorner.Parent = topBar

local topBarFix = Instance.new("Frame")
topBarFix.Size = UDim2.new(1, 0, 0, 12)
topBarFix.Position = UDim2.new(0, 0, 1, -12)
topBarFix.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
topBarFix.BorderSizePixel = 0
topBarFix.Parent = topBar

local logoDot = Instance.new("Frame")
logoDot.Size = UDim2.fromOffset(10, 10)
logoDot.Position = UDim2.new(0, 14, 0.5, -5)
logoDot.BackgroundColor3 = currentTheme
logoDot.BorderSizePixel = 0
logoDot.Parent = topBar

local logoDotCorner = Instance.new("UICorner")
logoDotCorner.CornerRadius = UDim.new(1, 0)
logoDotCorner.Parent = logoDot

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 32, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Vyre Hub  <font color=\"#777777\">|</font>  <font color=\"#AAAAAA\">Multiverse Script Sae</font>"
titleLabel.RichText = true
titleLabel.TextColor3 = Color3.fromRGB(245, 245, 245)
titleLabel.TextSize = 13
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(28, 28)
closeBtn.Position = UDim2.new(1, -34, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
closeBtn.TextSize = 12
closeBtn.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

local collapseBtn = Instance.new("TextButton")
collapseBtn.Size = UDim2.fromOffset(28, 28)
collapseBtn.Position = UDim2.new(1, -66, 0, 6)
collapseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
collapseBtn.Font = Enum.Font.GothamBold
collapseBtn.Text = "↓"
collapseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
collapseBtn.TextSize = 14
collapseBtn.Parent = topBar
local minBtn = collapseBtn -- compat alias if referenced

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minBtn

-- Content
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, 0, 1, -40)
contentArea.Position = UDim2.new(0, 0, 0, 40)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

local tabRail = Instance.new("Frame")
tabRail.Size = UDim2.new(0, 138, 1, 0)
tabRail.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
tabRail.BorderSizePixel = 0
tabRail.Parent = contentArea

local scriptsTabBtn = Instance.new("TextButton")
scriptsTabBtn.Size = UDim2.new(1, -16, 0, 34)
scriptsTabBtn.Position = UDim2.new(0, 8, 0, 12)
scriptsTabBtn.BackgroundColor3 = currentTheme
scriptsTabBtn.Font = Enum.Font.GothamBold
scriptsTabBtn.Text = "Scripts (Keyless)"
scriptsTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scriptsTabBtn.TextSize = 11
scriptsTabBtn.Parent = tabRail

local scriptsBtnCorner = Instance.new("UICorner")
scriptsBtnCorner.CornerRadius = UDim.new(0, 8)
scriptsBtnCorner.Parent = scriptsTabBtn

local keyTabBtn = Instance.new("TextButton")
keyTabBtn.Size = UDim2.new(1, -16, 0, 34)
keyTabBtn.Position = UDim2.new(0, 8, 0, 54)
keyTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
keyTabBtn.Font = Enum.Font.GothamSemibold
keyTabBtn.Text = "Scripts (Key)"
keyTabBtn.TextColor3 = Color3.fromRGB(170, 170, 180)
keyTabBtn.TextSize = 11
keyTabBtn.Parent = tabRail

local keyBtnCorner = Instance.new("UICorner")
keyBtnCorner.CornerRadius = UDim.new(0, 8)
keyBtnCorner.Parent = keyTabBtn

local configTabBtn = Instance.new("TextButton")
configTabBtn.Size = UDim2.new(1, -16, 0, 34)
configTabBtn.Position = UDim2.new(0, 8, 0, 96)
configTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
configTabBtn.Font = Enum.Font.GothamSemibold
configTabBtn.Text = "Config"
configTabBtn.TextColor3 = Color3.fromRGB(170, 170, 180)
configTabBtn.TextSize = 12
configTabBtn.Parent = tabRail

local configBtnCorner = Instance.new("UICorner")
configBtnCorner.CornerRadius = UDim.new(0, 8)
configBtnCorner.Parent = configTabBtn

local pagesContainer = Instance.new("Frame")
pagesContainer.Size = UDim2.new(1, -138, 1, 0)
pagesContainer.Position = UDim2.new(0, 138, 0, 0)
pagesContainer.BackgroundTransparency = 1
pagesContainer.Parent = contentArea

-- Scripts page
local scriptsPage = Instance.new("ScrollingFrame")
scriptsPage.Size = UDim2.new(1, 0, 1, 0)
scriptsPage.BackgroundTransparency = 1
scriptsPage.BorderSizePixel = 0
scriptsPage.ScrollBarThickness = 3
scriptsPage.ScrollBarImageColor3 = currentTheme
scriptsPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
scriptsPage.CanvasSize = UDim2.new(0, 0, 0, 0)
scriptsPage.Visible = true
scriptsPage.Parent = pagesContainer

local helperText = Instance.new("TextLabel")
helperText.Size = UDim2.new(1, -24, 0, 22)
helperText.Position = UDim2.new(0, 12, 0, 8)
helperText.BackgroundTransparency = 1
helperText.Font = Enum.Font.Gotham
helperText.Text = "Tap a button to run a script"
helperText.TextColor3 = Color3.fromRGB(130, 130, 145)
helperText.TextSize = 11
helperText.TextXAlignment = Enum.TextXAlignment.Left
helperText.Parent = scriptsPage

local scriptPad = Instance.new("UIPadding")
scriptPad.PaddingTop = UDim.new(0, 34)
scriptPad.PaddingLeft = UDim.new(0, 12)
scriptPad.PaddingRight = UDim.new(0, 12)
scriptPad.PaddingBottom = UDim.new(0, 12)
scriptPad.Parent = scriptsPage

local scriptGrid = Instance.new("UIGridLayout")
scriptGrid.CellSize = UDim2.fromOffset(160, 52)
scriptGrid.CellPadding = UDim2.fromOffset(10, 10)
scriptGrid.FillDirectionMaxCells = 2
scriptGrid.SortOrder = Enum.SortOrder.LayoutOrder
scriptGrid.HorizontalAlignment = Enum.HorizontalAlignment.Left
scriptGrid.VerticalAlignment = Enum.VerticalAlignment.Top
scriptGrid.Parent = scriptsPage

local scriptCards = {}

local function runScript(data)
	local url = data.url
	if type(url) ~= "string" or url == "" then
		warn("[Vyre Hub] No URL set for: " .. tostring(data.name))
		return
	end
	local ok, err = pcall(function()
		loadstring(game:HttpGet(url))()
	end)
	if not ok then
		warn("[Vyre Hub] Failed to run " .. data.name .. ": " .. tostring(err))
	end
end

for i, data in ipairs(scriptsData) do
	local card = Instance.new("Frame")
	card.Size = UDim2.fromOffset(160, 52)
	card.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
	card.BorderSizePixel = 0
	card.LayoutOrder = i
	card.Parent = scriptsPage

	local cardCorner = Instance.new("UICorner")
	cardCorner.CornerRadius = UDim.new(0, 8)
	cardCorner.Parent = card

	local cardStroke = Instance.new("UIStroke")
	cardStroke.Color = currentTheme
	cardStroke.Transparency = 0.55
	cardStroke.Thickness = 1
	cardStroke.Parent = card

	local nameLbl = Instance.new("TextLabel")
	nameLbl.Size = UDim2.new(1, -40, 1, 0)
	nameLbl.Position = UDim2.new(0, 12, 0, 0)
	nameLbl.BackgroundTransparency = 1
	nameLbl.Font = Enum.Font.GothamBold
	nameLbl.Text = data.name
	nameLbl.TextColor3 = Color3.fromRGB(235, 235, 240)
	nameLbl.TextSize = 13
	nameLbl.TextXAlignment = Enum.TextXAlignment.Left
	nameLbl.Parent = card

	local hasUrl = type(data.url) == "string" and data.url ~= ""
	local statusLbl = Instance.new("TextLabel")
	statusLbl.Size = UDim2.new(0, 52, 0, 14)
	statusLbl.Position = UDim2.new(1, -60, 0, 6)
	statusLbl.BackgroundTransparency = 1
	statusLbl.Font = Enum.Font.GothamBold
	statusLbl.Text = hasUrl and "WORKING" or "EMPTY"
	statusLbl.TextColor3 = hasUrl and Color3.fromRGB(80, 255, 140) or Color3.fromRGB(120, 120, 130)
	statusLbl.TextSize = 9
	statusLbl.TextXAlignment = Enum.TextXAlignment.Right
	statusLbl.Parent = card

	local dot = Instance.new("Frame")
	dot.Size = UDim2.fromOffset(8, 8)
	dot.Position = UDim2.new(1, -18, 1, -16)
	dot.BackgroundColor3 = hasUrl and Color3.fromRGB(50, 255, 120) or Color3.fromRGB(80, 80, 90)
	dot.BorderSizePixel = 0
	dot.Parent = card

	local dotCorner = Instance.new("UICorner")
	dotCorner.CornerRadius = UDim.new(1, 0)
	dotCorner.Parent = dot

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.fromScale(1, 1)
	btn.BackgroundTransparency = 1
	btn.Text = ""
	btn.ZIndex = 3
	btn.Parent = card

	btn.MouseButton1Click:Connect(function()
		runScript(data)
	end)

	table.insert(scriptCards, { card = card, stroke = cardStroke, status = statusLbl, dot = dot })
end

-- Scripts (Key) page
local keyPage = Instance.new("ScrollingFrame")
keyPage.Size = UDim2.new(1, 0, 1, 0)
keyPage.BackgroundTransparency = 1
keyPage.BorderSizePixel = 0
keyPage.ScrollBarThickness = 3
keyPage.ScrollBarImageColor3 = currentTheme
keyPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
keyPage.CanvasSize = UDim2.new(0, 0, 0, 0)
keyPage.Visible = false
keyPage.Parent = pagesContainer

local keyHelper = Instance.new("TextLabel")
keyHelper.Size = UDim2.new(1, -24, 0, 22)
keyHelper.Position = UDim2.new(0, 12, 0, 8)
keyHelper.BackgroundTransparency = 1
keyHelper.Font = Enum.Font.Gotham
keyHelper.Text = "Tap a button to run a key script"
keyHelper.TextColor3 = Color3.fromRGB(130, 130, 145)
keyHelper.TextSize = 11
keyHelper.TextXAlignment = Enum.TextXAlignment.Left
keyHelper.Parent = keyPage

local keyPad = Instance.new("UIPadding")
keyPad.PaddingTop = UDim.new(0, 34)
keyPad.PaddingLeft = UDim.new(0, 12)
keyPad.PaddingRight = UDim.new(0, 12)
keyPad.PaddingBottom = UDim.new(0, 12)
keyPad.Parent = keyPage

local keyGrid = Instance.new("UIGridLayout")
keyGrid.CellSize = UDim2.fromOffset(160, 52)
keyGrid.CellPadding = UDim2.fromOffset(10, 10)
keyGrid.FillDirectionMaxCells = 2
keyGrid.SortOrder = Enum.SortOrder.LayoutOrder
keyGrid.HorizontalAlignment = Enum.HorizontalAlignment.Left
keyGrid.VerticalAlignment = Enum.VerticalAlignment.Top
keyGrid.Parent = keyPage

for i, data in ipairs(scriptsDataKey) do
	local card = Instance.new("Frame")
	card.Size = UDim2.fromOffset(160, 52)
	card.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
	card.BorderSizePixel = 0
	card.LayoutOrder = i
	card.Parent = keyPage

	local cardCorner = Instance.new("UICorner")
	cardCorner.CornerRadius = UDim.new(0, 8)
	cardCorner.Parent = card

	local cardStroke = Instance.new("UIStroke")
	cardStroke.Color = currentTheme
	cardStroke.Transparency = 0.45
	cardStroke.Thickness = 1.5
	cardStroke.Parent = card

	local hasUrl = type(data.url) == "string" and data.url ~= ""
	local nameLbl = Instance.new("TextLabel")
	nameLbl.Size = UDim2.new(1, -40, 1, 0)
	nameLbl.Position = UDim2.new(0, 12, 0, 0)
	nameLbl.BackgroundTransparency = 1
	nameLbl.Font = Enum.Font.GothamBold
	nameLbl.Text = data.name
	nameLbl.TextColor3 = Color3.fromRGB(235, 235, 240)
	nameLbl.TextSize = 13
	nameLbl.TextXAlignment = Enum.TextXAlignment.Left
	nameLbl.Parent = card

	local statusLbl = Instance.new("TextLabel")
	statusLbl.Size = UDim2.new(0, 52, 0, 14)
	statusLbl.Position = UDim2.new(1, -60, 0, 6)
	statusLbl.BackgroundTransparency = 1
	statusLbl.Font = Enum.Font.GothamBold
	statusLbl.Text = hasUrl and "WORKING" or "EMPTY"
	statusLbl.TextColor3 = hasUrl and Color3.fromRGB(80, 255, 140) or Color3.fromRGB(120, 120, 130)
	statusLbl.TextSize = 9
	statusLbl.TextXAlignment = Enum.TextXAlignment.Right
	statusLbl.Parent = card

	local dot = Instance.new("Frame")
	dot.Size = UDim2.fromOffset(8, 8)
	dot.Position = UDim2.new(1, -18, 1, -16)
	dot.BackgroundColor3 = hasUrl and Color3.fromRGB(50, 255, 120) or Color3.fromRGB(80, 80, 90)
	dot.BorderSizePixel = 0
	dot.Parent = card

	local dotCorner = Instance.new("UICorner")
	dotCorner.CornerRadius = UDim.new(1, 0)
	dotCorner.Parent = dot

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.fromScale(1, 1)
	btn.BackgroundTransparency = 1
	btn.Text = ""
	btn.ZIndex = 3
	btn.Parent = card

	btn.MouseButton1Click:Connect(function()
		runScript(data)
	end)

	table.insert(scriptCards, { card = card, stroke = cardStroke, status = statusLbl, dot = dot })
end

-- Config page
local configPage = Instance.new("ScrollingFrame")
configPage.Size = UDim2.new(1, 0, 1, 0)
configPage.BackgroundTransparency = 1
configPage.BorderSizePixel = 0
configPage.ScrollBarThickness = 3
configPage.Visible = false
configPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
configPage.CanvasSize = UDim2.new(0, 0, 0, 0)
configPage.Parent = pagesContainer

local configPad = Instance.new("UIPadding")
configPad.PaddingTop = UDim.new(0, 16)
configPad.PaddingLeft = UDim.new(0, 16)
configPad.PaddingRight = UDim.new(0, 16)
configPad.PaddingBottom = UDim.new(0, 16)
configPad.Parent = configPage

local scaleLabel = Instance.new("TextLabel")
scaleLabel.Size = UDim2.new(1, -90, 0, 20)
scaleLabel.BackgroundTransparency = 1
scaleLabel.Font = Enum.Font.GothamSemibold
scaleLabel.Text = "Scale  ·  100%"
scaleLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
scaleLabel.TextSize = 12
scaleLabel.TextXAlignment = Enum.TextXAlignment.Left
scaleLabel.Parent = configPage

local resetScaleBtn = Instance.new("TextButton")
resetScaleBtn.Size = UDim2.new(0, 70, 0, 24)
resetScaleBtn.Position = UDim2.new(1, -70, 0, 0)
resetScaleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
resetScaleBtn.Font = Enum.Font.GothamBold
resetScaleBtn.Text = "RESET"
resetScaleBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
resetScaleBtn.TextSize = 11
resetScaleBtn.Parent = configPage

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 6)
resetCorner.Parent = resetScaleBtn

local scaleSliderBg = Instance.new("Frame")
scaleSliderBg.Size = UDim2.new(1, 0, 0, 10)
scaleSliderBg.Position = UDim2.new(0, 0, 0, 36)
scaleSliderBg.BackgroundColor3 = Color3.fromRGB(35, 35, 44)
scaleSliderBg.BorderSizePixel = 0
scaleSliderBg.Parent = configPage

local scaleSliderCorner = Instance.new("UICorner")
scaleSliderCorner.CornerRadius = UDim.new(1, 0)
scaleSliderCorner.Parent = scaleSliderBg

local scaleSliderFill = Instance.new("Frame")
scaleSliderFill.Size = UDim2.new(0.5, 0, 1, 0) -- 100% of 70-130 range
scaleSliderFill.BackgroundColor3 = currentTheme
scaleSliderFill.BorderSizePixel = 0
scaleSliderFill.Parent = scaleSliderBg

local scaleFillCorner = Instance.new("UICorner")
scaleFillCorner.CornerRadius = UDim.new(1, 0)
scaleFillCorner.Parent = scaleSliderFill

local scaleKnob = Instance.new("Frame")
scaleKnob.Size = UDim2.fromOffset(16, 16)
scaleKnob.Position = UDim2.new(0.5, -8, 0.5, -8)
scaleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
scaleKnob.BorderSizePixel = 0
scaleKnob.ZIndex = 2
scaleKnob.Parent = scaleSliderBg

local scaleKnobCorner = Instance.new("UICorner")
scaleKnobCorner.CornerRadius = UDim.new(1, 0)
scaleKnobCorner.Parent = scaleKnob

local scaleSliderBtn = Instance.new("TextButton")
scaleSliderBtn.Size = UDim2.new(1, 0, 1, 12)
scaleSliderBtn.Position = UDim2.new(0, 0, 0, -6)
scaleSliderBtn.BackgroundTransparency = 1
scaleSliderBtn.Text = ""
scaleSliderBtn.ZIndex = 3
scaleSliderBtn.Parent = scaleSliderBg

local themeLabel = Instance.new("TextLabel")
themeLabel.Size = UDim2.new(1, 0, 0, 20)
themeLabel.Position = UDim2.new(0, 0, 0, 64)
themeLabel.BackgroundTransparency = 1
themeLabel.Font = Enum.Font.GothamSemibold
themeLabel.Text = "Themes"
themeLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
themeLabel.TextSize = 12
themeLabel.TextXAlignment = Enum.TextXAlignment.Left
themeLabel.Parent = configPage

local themeContainer = Instance.new("Frame")
themeContainer.Size = UDim2.new(1, 0, 0, 120)
themeContainer.Position = UDim2.new(0, 0, 0, 90)
themeContainer.BackgroundTransparency = 1
themeContainer.Parent = configPage

local themeLayout = Instance.new("UIGridLayout")
themeLayout.CellSize = UDim2.fromOffset(70, 30)
themeLayout.CellPadding = UDim2.fromOffset(8, 8)
themeLayout.SortOrder = Enum.SortOrder.LayoutOrder
themeLayout.Parent = themeContainer

local compactBar, compactStroke, compactLogo

-- theme chips connected after applyTheme is fully defined (below)

-- Compact minimize bar
compactBar = Instance.new("Frame")
compactBar.Name = "CompactBar"
compactBar.Size = UDim2.new(0, 210, 0, 34)
compactBar.Position = mainFrame.Position
compactBar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
compactBar.BorderSizePixel = 0
compactBar.Visible = false
compactBar.Active = true
compactBar.Parent = screenGui

local compactScale = Instance.new("UIScale")
compactScale.Scale = 1
compactScale.Parent = compactBar

local compactCorner = Instance.new("UICorner")
compactCorner.CornerRadius = UDim.new(0, 10)
compactCorner.Parent = compactBar

compactStroke = Instance.new("UIStroke")
compactStroke.Color = currentTheme
compactStroke.Thickness = 1.5
compactStroke.Transparency = 0.25
compactStroke.Parent = compactBar

local compactLogo = Instance.new("Frame")
compactLogo.Size = UDim2.fromOffset(8, 8)
compactLogo.Position = UDim2.new(0, 12, 0.5, -4)
compactLogo.BackgroundColor3 = currentTheme
compactLogo.BorderSizePixel = 0
compactLogo.Parent = compactBar

local compactLogoCorner = Instance.new("UICorner")
compactLogoCorner.CornerRadius = UDim.new(1, 0)
compactLogoCorner.Parent = compactLogo

local compactTitle = Instance.new("TextLabel")
compactTitle.Size = UDim2.new(1, -50, 1, 0)
compactTitle.Position = UDim2.new(0, 28, 0, 0)
compactTitle.BackgroundTransparency = 1
compactTitle.Font = Enum.Font.GothamBold
compactTitle.Text = "Vyre Hub"
compactTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
compactTitle.TextSize = 12
compactTitle.TextXAlignment = Enum.TextXAlignment.Left
compactTitle.Parent = compactBar

local compactClose = Instance.new("TextButton")
compactClose.Size = UDim2.fromOffset(26, 26)
compactClose.Position = UDim2.new(1, -30, 0, 4)
compactClose.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
compactClose.Font = Enum.Font.GothamBold
compactClose.Text = "X"
compactClose.TextColor3 = Color3.fromRGB(200, 200, 200)
compactClose.TextSize = 11
compactClose.Parent = compactBar

local compactCloseCorner = Instance.new("UICorner")
compactCloseCorner.CornerRadius = UDim.new(0, 6)
compactCloseCorner.Parent = compactClose

local function applyTheme(color)
	currentTheme = color
	mainStroke.Color = color
	if compactStroke then compactStroke.Color = color end
	if compactLogo then compactLogo.BackgroundColor3 = color end
	logoDot.BackgroundColor3 = color
	scaleSliderFill.BackgroundColor3 = color
	scriptsPage.ScrollBarImageColor3 = color
	if scriptsPage.Visible then
		scriptsTabBtn.BackgroundColor3 = color
		configTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
		scriptsTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		configTabBtn.TextColor3 = Color3.fromRGB(170, 170, 180)
	else
		configTabBtn.BackgroundColor3 = color
		scriptsTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
		configTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		scriptsTabBtn.TextColor3 = Color3.fromRGB(170, 170, 180)
	end
	for _, item in ipairs(scriptCards) do
		if item.stroke then
			item.stroke.Color = color
			item.stroke.Thickness = 1.5
			item.stroke.Transparency = 0.35
		end
	end
	mainStroke.Thickness = 2
	mainStroke.Transparency = 0.1
end

for _, theme in ipairs(themes) do
	local chip = Instance.new("TextButton")
	chip.Size = UDim2.fromOffset(70, 30)
	chip.BackgroundColor3 = theme.color
	chip.Font = Enum.Font.GothamBold
	chip.Text = theme.name
	chip.TextColor3 = Color3.fromRGB(255, 255, 255)
	chip.TextSize = 11
	chip.Parent = themeContainer

	local chipCorner = Instance.new("UICorner")
	chipCorner.CornerRadius = UDim.new(0, 8)
	chipCorner.Parent = chip

	local chipStroke = Instance.new("UIStroke")
	chipStroke.Color = theme.color
	chipStroke.Thickness = 2
	chipStroke.Transparency = 0.3
	chipStroke.Parent = chip

	chip.MouseButton1Click:Connect(function()
		applyTheme(theme.color)
	end)
end

-- Tabs
local function setTabActive(activeBtn)
	local all = { scriptsTabBtn, keyTabBtn, configTabBtn }
	for _, b in ipairs(all) do
		if b == activeBtn then
			b.BackgroundColor3 = currentTheme
			b.TextColor3 = Color3.fromRGB(255, 255, 255)
			b.Font = Enum.Font.GothamBold
		else
			b.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
			b.TextColor3 = Color3.fromRGB(170, 170, 180)
			b.Font = Enum.Font.GothamSemibold
		end
	end
end

scriptsTabBtn.MouseButton1Click:Connect(function()
	setTabActive(scriptsTabBtn)
	scriptsPage.Visible = true
	keyPage.Visible = false
	configPage.Visible = false
end)

keyTabBtn.MouseButton1Click:Connect(function()
	setTabActive(keyTabBtn)
	scriptsPage.Visible = false
	keyPage.Visible = true
	configPage.Visible = false
end)

configTabBtn.MouseButton1Click:Connect(function()
	setTabActive(configTabBtn)
	scriptsPage.Visible = false
	keyPage.Visible = false
	configPage.Visible = true
end)

-- Collapse / expand (↓ collapse, ↑ expand) — no separate minimize bar
local isCollapsed = false
local FULL_SIZE = UDim2.fromOffset(520, 360)
local COLLAPSED_SIZE = UDim2.fromOffset(520, 40)

collapseBtn.MouseButton1Click:Connect(function()
	isCollapsed = not isCollapsed
	if isCollapsed then
		contentArea.Visible = false
		mainFrame.Size = COLLAPSED_SIZE
		collapseBtn.Text = "↑"
	else
		contentArea.Visible = true
		mainFrame.Size = FULL_SIZE
		collapseBtn.Text = "↓"
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

compactClose.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- Smooth drag + touch (tracks specific input so multi-touch is stable)
local function setupDraggable(handle, frameObj)
	local activeInput = nil
	local dragStart = nil
	local startPos = nil

	handle.Active = true

	handle.InputBegan:Connect(function(input)
		if activeInput then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			activeInput = input
			dragStart = input.Position
			startPos = frameObj.Position
		end
	end)

	local function endDrag(input)
		if activeInput and (input == activeInput
			or input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch) then
			-- only clear if same kind of end
			if input == activeInput
				or (activeInput.UserInputType == Enum.UserInputType.MouseButton1
					and input.UserInputType == Enum.UserInputType.MouseButton1)
				or (activeInput.UserInputType == Enum.UserInputType.Touch
					and input.UserInputType == Enum.UserInputType.Touch) then
				activeInput = nil
				dragStart = nil
				startPos = nil
			end
		end
	end

	handle.InputEnded:Connect(endDrag)
	UserInputService.InputEnded:Connect(endDrag)

	UserInputService.InputChanged:Connect(function(input)
		if not activeInput or not dragStart or not startPos then return end
		-- mouse move while mouse-dragging
		if activeInput.UserInputType == Enum.UserInputType.MouseButton1
			and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			frameObj.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		-- same touch finger moved
		elseif activeInput.UserInputType == Enum.UserInputType.Touch
			and input == activeInput then
			local delta = input.Position - dragStart
			frameObj.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

setupDraggable(topBar, mainFrame)
-- compact bar unused (↑↓ collapse instead)

-- Scale slider
local function updateScale(val)
	local clamped = math.clamp(val, 70, 130)
	local s = clamped / 100
	uiScale.Scale = s
	if compactScale then compactScale.Scale = s end
	-- keep fixed pixel size of main frame (scale handles visual size)
	if not isCollapsed then
		mainFrame.Size = FULL_SIZE
	else
		mainFrame.Size = COLLAPSED_SIZE
	end
	scaleLabel.Text = "Scale  ·  " .. math.floor(clamped) .. "%"
	local pct = (clamped - 70) / 60
	scaleSliderFill.Size = UDim2.new(pct, 0, 1, 0)
	scaleKnob.Position = UDim2.new(pct, -8, 0.5, -8)
end

local sliding = false
scaleSliderBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		sliding = true
		local pos = input.Position.X
		local absPos = scaleSliderBg.AbsolutePosition.X
		local absSize = scaleSliderBg.AbsoluteSize.X
		local pct = math.clamp((pos - absPos) / absSize, 0, 1)
		updateScale(70 + (pct * 60))
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		sliding = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local pos = input.Position.X
		local absPos = scaleSliderBg.AbsolutePosition.X
		local absSize = scaleSliderBg.AbsoluteSize.X
		local pct = math.clamp((pos - absPos) / absSize, 0, 1)
		updateScale(70 + (pct * 60))
	end
end)

resetScaleBtn.MouseButton1Click:Connect(function()
	updateScale(100)
end)

print("[Vyre Hub | Multiverse Script Sae] Loaded")
