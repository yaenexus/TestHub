--[[
	Vyre Hub | Multiverse Script Sae
	Script launcher + Config (scale / themes)
	Minimize to compact bar
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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
-- NO KEY REQUIRED (main)
local scriptsData = {
	{ name = "Miranda OP", url = "https://raw.githubusercontent.com/miirandahub/loader/refs/heads/main/stealeggies" },
	{ name = "Miranda AFK", url = "https://raw.githubusercontent.com/miirandahub/loader/refs/heads/main/afkk" },
	{ name = "Polluted Hub", url = "https://raw.githubusercontent.com/PollutedHub/Sae/main/SaePolluted" },
	{ name = "Chilli Hub", url = "https://raw.githubusercontent.com/tienkhanh1/Chilli-Hub-Script/refs/heads/main/StealAnEgg" },
	{ name = "Universal SAE", url = "https://raw.githubusercontent.com/sabscrip-arch/srver/refs/heads/main/Stealanegg" },
	{ name = "Blyxo Hub", url = "https://flowauth.net/v1/loaders/69d3463240384f3a73fbe32c178093a2.lua" },
	{ name = "Source Anti Hit", url = "https://gist.githubusercontent.com/sourceshubs/df6e17b3672213791b47a0a8c5398b6e/raw/SourcesHubAntiHitNewest" },
	{ name = "Source Instant Steal", url = "https://gist.githubusercontent.com/sourceshubs/9c70c7c483019f2de5d7119ae05ba3f8/raw/SourcesHubStealAnEgg" },
	{ name = "Sources Instant", url = "https://gist.githubusercontent.com/sourceshubs/1737c14cdba5c6fb472a995d555a50f1/raw/SourcesHubInstantStealNew" },
}

-- KEY REQUIRED (main)
local scriptsDataKey = {
	{ name = "FYY Hub", url = "https://FyyCommunity.my.id" },
	{ name = "Zeroin Hub", url = "https://zeroinhub.com/api/script" },
	{ name = "Bigfoot Bf", url = "https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua" },
	{ name = "Clover Hub", url = "https://cloverhub.app/clover.lua" },
	{ name = "Titanic Hub", url = "https://raw.githubusercontent.com/TITANIC-HUB/StealAnEgg/main/Loader.lua" },
	{ name = "Limbo Hub", url = "https://limbohub.my.id/loader.lua" },
	{ name = "Kira Hub", url = "https://raw.githubusercontent.com/shebetterlol889/shh/refs/heads/main/shh" },
	{ name = "Equinox Hub", url = "https://api.jnkie.com/api/v1/luascripts/public/338ceeba573ee21d1ce80a020b7923d8bde36038de4511162b01f325b16b9c3f/download" },
	{ name = "Ajjan Hub", url = "https://api.luarmor.net/files/v4/loaders/359e97f8618e9008afe5f496184ebb7c.lua" },
}

-- BONUS NO KEY
local bonusKeyless = {
	{ name = "Rene Baterbonia", url = "https://raw.githubusercontent.com/sabscrip-arch/srver/refs/heads/main/Stealanegg" },
	{ name = "Chocola Spawner", url = "https://raw.githubusercontent.com/chocolascript-glitch/Chocola-Pet-Spawner-steal-an-egg/refs/heads/main/script.lua" },
	{ name = "Exploit Hub", url = "https://raw.githubusercontent.com/Main-Scripts-Ready-V9/Exploiter-Loader/refs/heads/main/New.lua" },
	{ name = "Private Server", url = "https://raw.githubusercontent.com/raw-roblox/PrivateServerBypass/refs/heads/main/lua" },
}

-- BONUS KEY
local bonusKey = {
	{ name = "Infinite Robux", url = "https://pastefy.app/CkaV7ET8/raw" },
	{ name = "All Games Script", url = "https://raw.githubusercontent.com/leenZzZzZ/ScriptHUB/refs/heads/main/Script%20Hub" },
	{ name = "Source Hub V1", url = "https://pastefy.app/Lk0vDMmN/raw" },
	{ name = "Source Hub V2", url = "https://api.obscuravm.com/scripts/7924424523909516877" },
	{ name = "Source Hub V3", url = "https://api.obscuravm.com/scripts/2007463552086815334" },
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
local allThemeStrokes = {} -- every UIStroke that follows theme
local allThemeScrollbars = {}
local allThemeButtons = {} -- accent buttons that follow the selected theme
local rainbowStrokes = {} -- the four script-section outlines use a rainbow animation
local rainbowButtons = {} -- Execute buttons use the same animated rainbow effect

local function registerRainbowStroke(stroke)
	if stroke then
		table.insert(rainbowStrokes, stroke)
	end
	return stroke
end

local function registerRainbowButton(button)
	if button then
		table.insert(rainbowButtons, button)
	end
	return button
end

local function themeTextColor(color)
	local luminance = (0.2126 * color.R) + (0.7152 * color.G) + (0.0722 * color.B)
	return luminance > 0.72 and Color3.fromRGB(20, 20, 24) or Color3.fromRGB(255, 255, 255)
end

local function registerThemeButton(button)
	if button then
		table.insert(allThemeButtons, button)
		button.BackgroundColor3 = currentTheme
	end
	return button
end

local function registerStroke(stroke)
	if stroke then
		table.insert(allThemeStrokes, stroke)
		stroke.Color = currentTheme
	end
	return stroke
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 1000
screenGui.Parent = parentContainer

-- ===== Loading overlay (before UI) =====
local loadOverlay = Instance.new("Frame")
loadOverlay.Size = UDim2.fromScale(1, 1)
loadOverlay.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
loadOverlay.BorderSizePixel = 0
loadOverlay.ZIndex = 100
loadOverlay.Parent = screenGui

local loadTitle = Instance.new("TextLabel")
loadTitle.AnchorPoint = Vector2.new(0.5, 0.5)
loadTitle.Position = UDim2.new(0.5, 0, 0.42, 0)
loadTitle.Size = UDim2.new(0, 280, 0, 36)
loadTitle.BackgroundTransparency = 1
loadTitle.Font = Enum.Font.GothamBold
loadTitle.Text = "Vyre Hub"
loadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
loadTitle.TextSize = 28
loadTitle.ZIndex = 101
loadTitle.Parent = loadOverlay

local loadBarBg = Instance.new("Frame")
loadBarBg.AnchorPoint = Vector2.new(0.5, 0)
loadBarBg.Position = UDim2.new(0.5, 0, 0.5, 10)
loadBarBg.Size = UDim2.new(0, 220, 0, 8)
loadBarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
loadBarBg.BorderSizePixel = 0
loadBarBg.ZIndex = 101
loadBarBg.Parent = loadOverlay

local loadBarCorner = Instance.new("UICorner")
loadBarCorner.CornerRadius = UDim.new(1, 0)
loadBarCorner.Parent = loadBarBg

local loadBarFill = Instance.new("Frame")
loadBarFill.Size = UDim2.new(0, 0, 1, 0)
loadBarFill.BackgroundColor3 = Color3.fromRGB(180, 70, 255)
loadBarFill.BorderSizePixel = 0
loadBarFill.ZIndex = 102
loadBarFill.Parent = loadBarBg

local loadFillCorner = Instance.new("UICorner")
loadFillCorner.CornerRadius = UDim.new(1, 0)
loadFillCorner.Parent = loadBarFill

local loadPct = Instance.new("TextLabel")
loadPct.AnchorPoint = Vector2.new(0.5, 0)
loadPct.Position = UDim2.new(0.5, 0, 0.5, 28)
loadPct.Size = UDim2.new(0, 100, 0, 20)
loadPct.BackgroundTransparency = 1
loadPct.Font = Enum.Font.GothamBold
loadPct.Text = "0%"
loadPct.TextColor3 = Color3.fromRGB(180, 180, 200)
loadPct.TextSize = 13
loadPct.ZIndex = 101
loadPct.Parent = loadOverlay

-- Scale applies to main window + compact bar only (avoids layout stretch)
local uiScale = Instance.new("UIScale")
uiScale.Scale = 1

-- Main window
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.fromOffset(1000, 575)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.fromScale(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Parent = screenGui
uiScale.Parent = mainFrame
mainFrame.Visible = false

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = currentTheme
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.35
mainStroke.Parent = mainFrame
registerStroke(mainStroke)

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
titleLabel.Text = "Vyre Hub  <font color=\"#888888\">|</font>  <font color=\"#CCCCCC\">Multiverse Script Sae</font>"
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
-- avatar sits on mainFrame bottom-left (not inside config)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

local tabRail = Instance.new("Frame")
tabRail.Size = UDim2.new(0, 120, 1, 0)
tabRail.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
tabRail.BorderSizePixel = 0
tabRail.Parent = contentArea

local scriptsTabBtn = Instance.new("TextButton")
scriptsTabBtn.Size = UDim2.new(1, -16, 0, 34)
scriptsTabBtn.Position = UDim2.new(0, 8, 0, 12)
scriptsTabBtn.BackgroundColor3 = currentTheme
scriptsTabBtn.Font = Enum.Font.GothamBold
scriptsTabBtn.Text = "Scripts"
scriptsTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scriptsTabBtn.TextSize = 12
scriptsTabBtn.Parent = tabRail

local scriptsBtnCorner = Instance.new("UICorner")
scriptsBtnCorner.CornerRadius = UDim.new(0, 8)
scriptsBtnCorner.Parent = scriptsTabBtn

local keyTabBtn = nil -- removed: single Scripts tab with dual sections

local configTabBtn = Instance.new("TextButton")
configTabBtn.Size = UDim2.new(1, -16, 0, 34)
configTabBtn.Position = UDim2.new(0, 8, 0, 54)
configTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
configTabBtn.Font = Enum.Font.GothamSemibold
configTabBtn.Text = "Config"
configTabBtn.TextColor3 = Color3.fromRGB(170, 170, 180)
configTabBtn.TextSize = 12
configTabBtn.Parent = tabRail

local configBtnCorner = Instance.new("UICorner")
configBtnCorner.CornerRadius = UDim.new(0, 8)
configBtnCorner.Parent = configTabBtn

local ownerTabBtn = Instance.new("TextButton")
ownerTabBtn.Size = UDim2.new(1, -16, 0, 34)
ownerTabBtn.Position = UDim2.new(0, 8, 0, 96)
ownerTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
ownerTabBtn.Font = Enum.Font.GothamSemibold
ownerTabBtn.Text = "Owner"
ownerTabBtn.TextColor3 = Color3.fromRGB(170, 170, 180)
ownerTabBtn.TextSize = 12
ownerTabBtn.Parent = tabRail

local ownerBtnCorner = Instance.new("UICorner")
ownerBtnCorner.CornerRadius = UDim.new(0, 8)
ownerBtnCorner.Parent = ownerTabBtn

local pagesContainer = Instance.new("Frame")
pagesContainer.Size = UDim2.new(1, -120, 1, -4)
pagesContainer.Position = UDim2.new(0, 120, 0, 0)
pagesContainer.BackgroundTransparency = 1
pagesContainer.Parent = contentArea

-- Scripts page
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

-- Search bar
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -24, 0, 32)
searchBox.Position = UDim2.new(0, 12, 0, 10)
searchBox.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
searchBox.BorderSizePixel = 0
searchBox.Font = Enum.Font.GothamBold
searchBox.PlaceholderText = "Search scripts..."
searchBox.PlaceholderColor3 = Color3.fromRGB(110, 110, 125)
searchBox.Text = ""
searchBox.TextColor3 = Color3.fromRGB(245, 245, 250)
searchBox.TextSize = 13
searchBox.TextXAlignment = Enum.TextXAlignment.Left
searchBox.ClearTextOnFocus = false
searchBox.Parent = scriptsPage

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 8)
searchCorner.Parent = searchBox


local searchPad = Instance.new("UIPadding")
searchPad.PaddingLeft = UDim.new(0, 12)
searchPad.Parent = searchBox

-- Scripts page itself: no scrollbar (ScrollingEnabled off)
scriptsPage.ScrollingEnabled = true
scriptsPage.CanvasSize = UDim2.new(0, 0, 0, 0)
scriptsPage.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- Dual columns container (fills remaining height under search)
local dual = Instance.new("Frame")
dual.Name = "DualColumns"
dual.Size = UDim2.new(1, -20, 0, 200)
dual.Position = UDim2.new(0, 10, 0, 48)
dual.BackgroundTransparency = 1
dual.Parent = scriptsPage

local dualLayout = Instance.new("UIListLayout")
dualLayout.FillDirection = Enum.FillDirection.Horizontal
dualLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
dualLayout.Padding = UDim.new(0, 12)
dualLayout.SortOrder = Enum.SortOrder.LayoutOrder
dualLayout.Parent = dual

local function makeSection(title, titleColor, order)
	local col = Instance.new("Frame")
	col.Size = UDim2.new(0.5, -6, 1, 0)
	col.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
	col.BorderSizePixel = 0
	col.LayoutOrder = order
	col.Parent = dual

	local colCorner = Instance.new("UICorner")
	colCorner.CornerRadius = UDim.new(0, 10)
	colCorner.Parent = col

	local colStroke = Instance.new("UIStroke")
	colStroke.Color = currentTheme
	colStroke.Transparency = 0.35
	colStroke.Thickness = 1.5
	colStroke.Parent = col
	registerStroke(colStroke)
	registerRainbowStroke(colStroke)

	local header = Instance.new("TextLabel")
	header.Size = UDim2.new(1, -16, 0, 22)
	header.Position = UDim2.new(0, 8, 0, 8)
	header.BackgroundTransparency = 1
	header.Font = Enum.Font.GothamBold
	header.Text = title
	header.TextColor3 = titleColor
	header.TextSize = 11
	header.TextXAlignment = Enum.TextXAlignment.Left
	header.Parent = col

	-- Own scrollbar per column
	local cardsFrame = Instance.new("ScrollingFrame")
	cardsFrame.Name = "Cards"
	cardsFrame.Size = UDim2.new(1, -12, 1, -36)
	cardsFrame.Position = UDim2.new(0, 6, 0, 32)
	cardsFrame.BackgroundTransparency = 1
	cardsFrame.BorderSizePixel = 0
	cardsFrame.ScrollBarThickness = 3
	cardsFrame.ScrollBarImageColor3 = currentTheme
	cardsFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	cardsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	cardsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	cardsFrame.Parent = col

	local cardsPad = Instance.new("UIPadding")
	cardsPad.PaddingBottom = UDim.new(0, 8)
	cardsPad.PaddingRight = UDim.new(0, 4)
	cardsPad.Parent = cardsFrame

	local cardsList = Instance.new("UIListLayout")
	cardsList.SortOrder = Enum.SortOrder.LayoutOrder
	cardsList.Padding = UDim.new(0, 6)
	cardsList.Parent = cardsFrame

	return col, cardsFrame, colStroke
end

local keylessCol, keylessCards, keylessStroke = makeSection("NO KEY REQUIRED", Color3.fromRGB(80, 255, 140), 1)
local keyCol, keyCards, keyStroke = makeSection("KEY REQUIRED", Color3.fromRGB(255, 180, 70), 2)
if keylessCards then table.insert(allThemeScrollbars, keylessCards) end
if keyCards then table.insert(allThemeScrollbars, keyCards) end

local scriptCards = {}
local sectionStrokes = { keylessStroke, keyStroke }

local function createScriptCard(data, parent, order)
	local hasUrl = type(data.url) == "string" and data.url ~= ""

	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, -4, 0, 56)
	card.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
	card.BorderSizePixel = 0
	card.LayoutOrder = order
	card.Parent = parent

	local cardCorner = Instance.new("UICorner")
	cardCorner.CornerRadius = UDim.new(0, 8)
	cardCorner.Parent = card

	local cardStroke = Instance.new("UIStroke")
	cardStroke.Color = currentTheme
	cardStroke.Transparency = 0.55
	cardStroke.Thickness = 1
	cardStroke.Parent = card
	registerStroke(cardStroke)

	local nameLbl = Instance.new("TextLabel")
	-- Keep the script name above the Execute button instead of vertically centering it.
	nameLbl.Size = UDim2.new(1, -50, 0, 22)
	nameLbl.Position = UDim2.new(0, 12, 0, 0)
	nameLbl.BackgroundTransparency = 1
	nameLbl.Font = Enum.Font.GothamBold
	nameLbl.Text = data.name
	nameLbl.TextColor3 = Color3.fromRGB(235, 235, 240)
	nameLbl.TextSize = 12
	nameLbl.TextXAlignment = Enum.TextXAlignment.Left
	nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
	nameLbl.Parent = card

	local statusLbl = Instance.new("TextLabel")
	statusLbl.Size = UDim2.new(0, 58, 0, 12)
	statusLbl.Position = UDim2.new(1, -66, 0, 4)
	statusLbl.BackgroundTransparency = 1
	statusLbl.Font = Enum.Font.GothamBold
	statusLbl.Text = hasUrl and "WORKING" or "EMPTY"
	statusLbl.TextColor3 = hasUrl and Color3.fromRGB(80, 255, 140) or Color3.fromRGB(120, 120, 130)
	statusLbl.TextSize = 9
	statusLbl.TextXAlignment = Enum.TextXAlignment.Right
	statusLbl.Parent = card

	local dot = Instance.new("Frame")
	dot.Size = UDim2.fromOffset(7, 7)
	dot.Position = UDim2.new(1, -16, 0, 18)
	dot.BackgroundColor3 = hasUrl and Color3.fromRGB(50, 255, 120) or Color3.fromRGB(80, 80, 90)
	dot.BorderSizePixel = 0
	dot.Parent = card

	local dotCorner = Instance.new("UICorner")
	dotCorner.CornerRadius = UDim.new(1, 0)
	dotCorner.Parent = dot

	local execBtn = Instance.new("TextButton")
	execBtn.Size = UDim2.new(1, -16, 0, 20)
	execBtn.Position = UDim2.new(0, 8, 1, -24)
	execBtn.BackgroundColor3 = hasUrl and currentTheme or Color3.fromRGB(50, 50, 58)
	execBtn.Font = Enum.Font.GothamBold
	execBtn.Text = "Execute"
	execBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	execBtn.TextSize = 11
	execBtn.ZIndex = 4
	execBtn.AutoButtonColor = true
	execBtn.Parent = card
	if hasUrl then
		registerThemeButton(execBtn)
		registerRainbowButton(execBtn)
	end

	local execCorner = Instance.new("UICorner")
	execCorner.CornerRadius = UDim.new(0, 6)
	execCorner.Parent = execBtn

	execBtn.MouseButton1Click:Connect(function()
		runScript(data)
	end)

	local entry = {
		card = card,
		stroke = cardStroke,
		status = statusLbl,
		dot = dot,
		name = data.name,
		nameLower = string.lower(data.name),
	}
	table.insert(scriptCards, entry)
	return entry
end

for i, data in ipairs(scriptsData) do
	createScriptCard(data, keylessCards, i)
end

for i, data in ipairs(scriptsDataKey) do
	createScriptCard(data, keyCards, i)
end

-- BONUS section (second dual columns)
local bonusTitle = Instance.new("TextLabel")
bonusTitle.Size = UDim2.new(1, -20, 0, 18)
bonusTitle.Position = UDim2.new(0, 10, 0, 255)
bonusTitle.BackgroundTransparency = 1
bonusTitle.Font = Enum.Font.GothamBold
bonusTitle.Text = "BONUS"
bonusTitle.TextColor3 = Color3.fromRGB(255, 200, 80)
bonusTitle.TextSize = 12
bonusTitle.TextXAlignment = Enum.TextXAlignment.Left
bonusTitle.Parent = scriptsPage

local dualBonus = Instance.new("Frame")
dualBonus.Name = "DualBonus"
dualBonus.Size = UDim2.new(1, -20, 0, 160)
dualBonus.Position = UDim2.new(0, 10, 0, 275)
dualBonus.BackgroundTransparency = 1
dualBonus.Parent = scriptsPage

local dualBonusLayout = Instance.new("UIListLayout")
dualBonusLayout.FillDirection = Enum.FillDirection.Horizontal
dualBonusLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
dualBonusLayout.Padding = UDim.new(0, 12)
dualBonusLayout.Parent = dualBonus

-- temporarily parent makeSection to dualBonus
local function makeBonusSection(title, titleColor, order)
	local col = Instance.new("Frame")
	col.Size = UDim2.new(0.5, -6, 1, 0)
	col.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
	col.BorderSizePixel = 0
	col.LayoutOrder = order
	col.Parent = dualBonus

	local colCorner = Instance.new("UICorner")
	colCorner.CornerRadius = UDim.new(0, 10)
	colCorner.Parent = col

	local colStroke = Instance.new("UIStroke")
	colStroke.Color = currentTheme
	colStroke.Transparency = 0.35
	colStroke.Thickness = 1.5
	colStroke.Parent = col
	registerStroke(colStroke)
	registerRainbowStroke(colStroke)

	local header = Instance.new("TextLabel")
	header.Size = UDim2.new(1, -16, 0, 22)
	header.Position = UDim2.new(0, 8, 0, 8)
	header.BackgroundTransparency = 1
	header.Font = Enum.Font.GothamBold
	header.Text = title
	header.TextColor3 = titleColor
	header.TextSize = 11
	header.TextXAlignment = Enum.TextXAlignment.Left
	header.Parent = col

	local cardsFrame = Instance.new("ScrollingFrame")
	cardsFrame.Name = "Cards"
	cardsFrame.Size = UDim2.new(1, -12, 1, -36)
	cardsFrame.Position = UDim2.new(0, 6, 0, 32)
	cardsFrame.BackgroundTransparency = 1
	cardsFrame.BorderSizePixel = 0
	cardsFrame.ScrollBarThickness = 3
	cardsFrame.ScrollBarImageColor3 = currentTheme
	cardsFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	cardsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	cardsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	cardsFrame.Parent = col
	table.insert(allThemeScrollbars, cardsFrame)

	local cardsPad = Instance.new("UIPadding")
	cardsPad.PaddingBottom = UDim.new(0, 8)
	cardsPad.PaddingRight = UDim.new(0, 4)
	cardsPad.Parent = cardsFrame

	local cardsList = Instance.new("UIListLayout")
	cardsList.SortOrder = Enum.SortOrder.LayoutOrder
	cardsList.Padding = UDim.new(0, 6)
	cardsList.Parent = cardsFrame

	return col, cardsFrame, colStroke
end

local bonusKeylessCol, bonusKeylessCards = makeBonusSection("NO KEY REQUIRED", Color3.fromRGB(80, 255, 140), 1)
local bonusKeyCol, bonusKeyCards = makeBonusSection("KEY REQUIRED", Color3.fromRGB(255, 180, 70), 2)

for i, data in ipairs(bonusKeyless) do
	createScriptCard(data, bonusKeylessCards, i)
end
for i, data in ipairs(bonusKey) do
	createScriptCard(data, bonusKeyCards, i)
end

-- Search filter
local function applySearch()
	local q = string.lower(searchBox.Text or "")
	for _, item in ipairs(scriptCards) do
		if q == "" or string.find(item.nameLower, q, 1, true) then
			item.card.Visible = true
		else
			item.card.Visible = false
		end
	end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(applySearch)

-- hide old keyPage if referenced later
local keyPage = Instance.new("Frame")
keyPage.Visible = false
keyPage.Parent = pagesContainer

-- Owner page
local ownerPage = Instance.new("Frame")
ownerPage.Size = UDim2.new(1, 0, 1, 0)
ownerPage.BackgroundTransparency = 1
ownerPage.Visible = false
ownerPage.Parent = pagesContainer

local ownerInfo = Instance.new("TextLabel")
ownerInfo.Size = UDim2.new(1, -24, 0, 80)
ownerInfo.Position = UDim2.new(0, 12, 0, 16)
ownerInfo.BackgroundTransparency = 1
ownerInfo.Font = Enum.Font.GothamBold
ownerInfo.Text = "Owner\nVyre Hub | Multiverse Script Sae\nContact / credits soon"
ownerInfo.TextColor3 = Color3.fromRGB(200, 200, 210)
ownerInfo.TextSize = 13
ownerInfo.TextXAlignment = Enum.TextXAlignment.Left
ownerInfo.TextYAlignment = Enum.TextYAlignment.Top
ownerInfo.Parent = ownerPage

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

-- Config layout: clean containers for Adjustable, Game Info, Themes
local function makeConfigCard(name, size, position)
	local card = Instance.new("Frame")
	card.Name = name
	card.Size = size
	card.Position = position
	card.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
	card.BackgroundTransparency = 0.08
	card.BorderSizePixel = 0
	card.ZIndex = 1
	card.Parent = configPage

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = card

	local stroke = Instance.new("UIStroke")
	stroke.Color = currentTheme
	stroke.Thickness = 1
	stroke.Transparency = 0.45
	stroke.Parent = card
	registerStroke(stroke)

	return card
end

-- Top row: Adjustable controls + organized status text
local adjustableCard = makeConfigCard(
	"AdjustableContainer",
	UDim2.new(0.54, -6, 0, 92),
	UDim2.new(0, 0, 0, 0)
)

local adjustableTitle = Instance.new("TextLabel")
adjustableTitle.Size = UDim2.new(1, -24, 0, 18)
adjustableTitle.Position = UDim2.new(0, 12, 0, 10)
adjustableTitle.BackgroundTransparency = 1
adjustableTitle.Font = Enum.Font.GothamBold
adjustableTitle.Text = "Adjustable"
adjustableTitle.TextColor3 = Color3.fromRGB(235, 235, 245)
adjustableTitle.TextSize = 12
adjustableTitle.TextXAlignment = Enum.TextXAlignment.Left
adjustableTitle.ZIndex = 2
adjustableTitle.Parent = adjustableCard

local scaleLabel = Instance.new("TextLabel")
scaleLabel.Size = UDim2.new(1, -92, 0, 18)
scaleLabel.Position = UDim2.new(0, 12, 0, 31)
scaleLabel.BackgroundTransparency = 1
scaleLabel.Font = Enum.Font.GothamSemibold
scaleLabel.Text = "Scale  ·  100%"
scaleLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
scaleLabel.TextSize = 11
scaleLabel.TextXAlignment = Enum.TextXAlignment.Left
scaleLabel.ZIndex = 2
scaleLabel.Parent = adjustableCard

local resetScaleBtn = Instance.new("TextButton")
resetScaleBtn.Size = UDim2.fromOffset(56, 20)
resetScaleBtn.Position = UDim2.new(1, -68, 0, 29)
resetScaleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
resetScaleBtn.Font = Enum.Font.GothamBold
resetScaleBtn.Text = "RESET"
resetScaleBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
resetScaleBtn.TextSize = 9
resetScaleBtn.ZIndex = 2
resetScaleBtn.Parent = adjustableCard

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 6)
resetCorner.Parent = resetScaleBtn

local scaleSliderBg = Instance.new("Frame")
scaleSliderBg.Size = UDim2.new(1, -24, 0, 8)
scaleSliderBg.Position = UDim2.new(0, 12, 0, 60)
scaleSliderBg.BackgroundColor3 = Color3.fromRGB(35, 35, 44)
scaleSliderBg.BorderSizePixel = 0
scaleSliderBg.ZIndex = 2
scaleSliderBg.Parent = adjustableCard

local scaleSliderCorner = Instance.new("UICorner")
scaleSliderCorner.CornerRadius = UDim.new(1, 0)
scaleSliderCorner.Parent = scaleSliderBg

local scaleSliderFill = Instance.new("Frame")
scaleSliderFill.Size = UDim2.new(1, 0, 1, 0)
scaleSliderFill.BackgroundColor3 = currentTheme
scaleSliderFill.BorderSizePixel = 0
scaleSliderFill.ZIndex = 2
scaleSliderFill.Parent = scaleSliderBg

local scaleFillCorner = Instance.new("UICorner")
scaleFillCorner.CornerRadius = UDim.new(1, 0)
scaleFillCorner.Parent = scaleSliderFill

local scaleKnob = Instance.new("Frame")
scaleKnob.Size = UDim2.fromOffset(16, 16)
scaleKnob.Position = UDim2.new(1, -8, 0.5, -8)
scaleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
scaleKnob.BorderSizePixel = 0
scaleKnob.ZIndex = 4
scaleKnob.Parent = scaleSliderBg

local scaleKnobCorner = Instance.new("UICorner")
scaleKnobCorner.CornerRadius = UDim.new(1, 0)
scaleKnobCorner.Parent = scaleKnob

local scaleSliderBtn = Instance.new("TextButton")
scaleSliderBtn.Size = UDim2.new(1, 0, 1, 12)
scaleSliderBtn.Position = UDim2.new(0, 0, 0, -6)
scaleSliderBtn.BackgroundTransparency = 1
scaleSliderBtn.Text = ""
scaleSliderBtn.ZIndex = 5
scaleSliderBtn.Parent = scaleSliderBg

-- Game info text container
local infoPanel = makeConfigCard(
	"GameInfoContainer",
	UDim2.new(0.44, -2, 0, 92),
	UDim2.new(0.56, 2, 0, 0)
)

local infoHeader = Instance.new("TextLabel")
infoHeader.Size = UDim2.new(1, -24, 0, 16)
infoHeader.Position = UDim2.new(0, 12, 0, 9)
infoHeader.BackgroundTransparency = 1
infoHeader.Font = Enum.Font.GothamBold
infoHeader.Text = "Game Info"
infoHeader.TextColor3 = Color3.fromRGB(235, 235, 245)
infoHeader.TextSize = 12
infoHeader.TextXAlignment = Enum.TextXAlignment.Left
infoHeader.ZIndex = 2
infoHeader.Parent = infoPanel

local gameTitle = Instance.new("TextLabel")
gameTitle.Size = UDim2.new(0.48, -6, 0, 16)
gameTitle.Position = UDim2.new(0, 12, 0, 31)
gameTitle.BackgroundTransparency = 1
gameTitle.Font = Enum.Font.GothamBold
gameTitle.Text = "Steal An Egg"
gameTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
gameTitle.TextSize = 12
gameTitle.TextXAlignment = Enum.TextXAlignment.Left
gameTitle.ZIndex = 2
gameTitle.Parent = infoPanel

local timeLabel = Instance.new("TextLabel")
timeLabel.Size = UDim2.new(0.52, -6, 0, 16)
timeLabel.Position = UDim2.new(0.48, 0, 0, 31)
timeLabel.BackgroundTransparency = 1
timeLabel.Font = Enum.Font.Gotham
timeLabel.Text = "Time Playing: 0s"
timeLabel.TextColor3 = Color3.fromRGB(180, 180, 195)
timeLabel.TextSize = 10
timeLabel.TextXAlignment = Enum.TextXAlignment.Right
timeLabel.ZIndex = 2
timeLabel.Parent = infoPanel

local statusWorking = Instance.new("TextLabel")
statusWorking.Size = UDim2.new(0.33, -4, 0, 16)
statusWorking.Position = UDim2.new(0, 12, 0, 55)
statusWorking.BackgroundTransparency = 1
statusWorking.Font = Enum.Font.GothamBold
statusWorking.Text = "Working"
statusWorking.TextColor3 = Color3.fromRGB(80, 255, 140)
statusWorking.TextSize = 10
statusWorking.TextXAlignment = Enum.TextXAlignment.Left
statusWorking.ZIndex = 2
statusWorking.Parent = infoPanel

local statusMulti = Instance.new("TextLabel")
statusMulti.Size = UDim2.new(0.34, -4, 0, 16)
statusMulti.Position = UDim2.new(0.33, 0, 0, 55)
statusMulti.BackgroundTransparency = 1
statusMulti.Font = Enum.Font.Gotham
statusMulti.Text = "Multi Script"
statusMulti.TextColor3 = Color3.fromRGB(200, 200, 210)
statusMulti.TextSize = 10
statusMulti.TextXAlignment = Enum.TextXAlignment.Center
statusMulti.ZIndex = 2
statusMulti.Parent = infoPanel

local statusFree = Instance.new("TextLabel")
statusFree.Size = UDim2.new(0.33, -4, 0, 16)
statusFree.Position = UDim2.new(0.67, 0, 0, 55)
statusFree.BackgroundTransparency = 1
statusFree.Font = Enum.Font.Gotham
statusFree.Text = "free only"
statusFree.TextColor3 = Color3.fromRGB(160, 160, 175)
statusFree.TextSize = 10
statusFree.TextXAlignment = Enum.TextXAlignment.Right
statusFree.ZIndex = 2
statusFree.Parent = infoPanel

-- Themes container
local themeCard = makeConfigCard(
	"ThemesContainer",
	UDim2.new(1, -4, 0, 126),
	UDim2.new(0, 0, 0, 104)
)

local themeLabel = Instance.new("TextLabel")
themeLabel.Size = UDim2.new(1, -24, 0, 18)
themeLabel.Position = UDim2.new(0, 12, 0, 10)
themeLabel.BackgroundTransparency = 1
themeLabel.Font = Enum.Font.GothamBold
themeLabel.Text = "Themes"
themeLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
themeLabel.TextSize = 12
themeLabel.TextXAlignment = Enum.TextXAlignment.Left
themeLabel.ZIndex = 2
themeLabel.Parent = themeCard

local themeContainer = Instance.new("Frame")
themeContainer.Size = UDim2.new(1, -24, 0, 76)
themeContainer.Position = UDim2.new(0, 12, 0, 36)
themeContainer.BackgroundTransparency = 1
themeContainer.Parent = themeCard

local themeLayout = Instance.new("UIGridLayout")
themeLayout.CellSize = UDim2.new(0.19, -4, 0, 26)
themeLayout.CellPadding = UDim2.fromOffset(6, 6)
themeLayout.FillDirectionMaxCells = 5
themeLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
themeLayout.SortOrder = Enum.SortOrder.LayoutOrder
themeLayout.Parent = themeContainer

-- Transparent background option stays below the theme card.
local bgTransparent = false
local transparentBtn = Instance.new("TextButton")
transparentBtn.Size = UDim2.new(1, -4, 0, 32)
transparentBtn.Position = UDim2.new(0, 0, 0, 240)
transparentBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
transparentBtn.Font = Enum.Font.GothamBold
transparentBtn.Text = "Transparent Background  ·  OFF"
transparentBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
transparentBtn.TextSize = 11
transparentBtn.Parent = configPage

local transparentCorner = Instance.new("UICorner")
transparentCorner.CornerRadius = UDim.new(0, 8)
transparentCorner.Parent = transparentBtn

local transparentStroke = Instance.new("UIStroke")
transparentStroke.Color = currentTheme
transparentStroke.Transparency = 0.5
transparentStroke.Thickness = 1
transparentStroke.Parent = transparentBtn
registerStroke(transparentStroke)

local function applyBackgroundTransparency()
	if bgTransparent then
		mainFrame.BackgroundTransparency = 0.45
		topBar.BackgroundTransparency = 0.35
		tabRail.BackgroundTransparency = 0.35
		transparentBtn.Text = "Transparent Background  ·  ON"
		transparentBtn.TextColor3 = Color3.fromRGB(80, 255, 140)
	else
		mainFrame.BackgroundTransparency = 0
		topBar.BackgroundTransparency = 0
		tabRail.BackgroundTransparency = 0
		transparentBtn.Text = "Transparent Background  ·  OFF"
		transparentBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
	end
end

transparentBtn.MouseButton1Click:Connect(function()
	bgTransparent = not bgTransparent
	applyBackgroundTransparency()
end)

local applyTheme

for _, theme in ipairs(themes) do
	local chip = Instance.new("TextButton")
	chip.Size = UDim2.new(1, 0, 0, 26)
	chip.BackgroundColor3 = theme.color
	chip.Font = Enum.Font.GothamBold
	chip.Text = theme.name
	chip.TextColor3 = themeTextColor(theme.color)
	chip.TextSize = 10
	chip.AutoButtonColor = true
	chip.ZIndex = 3
	chip.Parent = themeContainer

	local chipCorner = Instance.new("UICorner")
	chipCorner.CornerRadius = UDim.new(0, 8)
	chipCorner.Parent = chip

	local chipStroke = Instance.new("UIStroke")
	chipStroke.Color = theme.color
	chipStroke.Transparency = 0.25
	chipStroke.Thickness = 1
	chipStroke.Parent = chip
	registerStroke(chipStroke)

	chip.MouseButton1Click:Connect(function()
		applyTheme(theme.color)
	end)
end

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

local function tweenColor(obj, prop, color, t)
	if not obj then return end
	pcall(function()
		TweenService:Create(obj, TweenInfo.new(t or 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			[prop] = color
		}):Play()
	end)
end

applyTheme = function(color)
	currentTheme = color
	local t = 0.4

	-- Smooth outline wrap animation on main frame
	tweenColor(mainStroke, "Color", color, t)
	pcall(function()
		TweenService:Create(mainStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Thickness = 2.5,
			Transparency = 0.05
		}):Play()
		task.delay(0.2, function()
			TweenService:Create(mainStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Thickness = 1.5,
				Transparency = 0.35
			}):Play()
		end)
	end)

	tweenColor(compactStroke, "Color", color, t)
	tweenColor(compactLogo, "BackgroundColor3", color, t)
	tweenColor(logoDot, "BackgroundColor3", color, t)
	tweenColor(scaleSliderFill, "BackgroundColor3", color, t)

	scriptsPage.ScrollBarImageColor3 = color
	if keyPage then keyPage.ScrollBarImageColor3 = color end

	-- Active tab color
	local active = scriptsTabBtn
	if configPage.Visible then active = configTabBtn end
	if ownerPage and ownerPage.Visible then active = ownerTabBtn end
	for _, b in ipairs({ scriptsTabBtn, configTabBtn, ownerTabBtn }) do
		if b == active then
			tweenColor(b, "BackgroundColor3", color, t)
			b.TextColor3 = themeTextColor(color)
			b.Font = Enum.Font.GothamBold
		else
			tweenColor(b, "BackgroundColor3", Color3.fromRGB(30, 30, 38), t)
			b.TextColor3 = Color3.fromRGB(170, 170, 180)
			b.Font = Enum.Font.GothamSemibold
		end
	end

	-- Update every accent button (Execute buttons)
	for _, btn in ipairs(allThemeButtons) do
		if btn and btn.Parent then
			tweenColor(btn, "BackgroundColor3", color, t)
		end
	end

	-- Update EVERY registered stroke (columns, cards, main, transparent)
	for _, st in ipairs(allThemeStrokes) do
		if st and st.Parent then
			tweenColor(st, "Color", color, t)
		end
	end
	for _, sb in ipairs(allThemeScrollbars) do
		if sb and sb.Parent then
			sb.ScrollBarImageColor3 = color
		end
	end
	scriptsPage.ScrollBarImageColor3 = color
end

-- Tabs
local function setTabActive(activeBtn)
	local all = { scriptsTabBtn, configTabBtn, ownerTabBtn }
	for _, b in ipairs(all) do
		if b then
			if b == activeBtn then
				b.BackgroundColor3 = currentTheme
				b.TextColor3 = themeTextColor(currentTheme)
				b.Font = Enum.Font.GothamBold
			else
				b.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
				b.TextColor3 = Color3.fromRGB(170, 170, 180)
				b.Font = Enum.Font.GothamSemibold
			end
		end
	end
end

scriptsTabBtn.MouseButton1Click:Connect(function()
	setTabActive(scriptsTabBtn)
	scriptsPage.Visible = true
	configPage.Visible = false
	ownerPage.Visible = false
end)

configTabBtn.MouseButton1Click:Connect(function()
	setTabActive(configTabBtn)
	scriptsPage.Visible = false
	configPage.Visible = true
	ownerPage.Visible = false
end)

ownerTabBtn.MouseButton1Click:Connect(function()
	setTabActive(ownerTabBtn)
	scriptsPage.Visible = false
	configPage.Visible = false
	ownerPage.Visible = true
end)

local applyResponsiveScale
local clampMainToViewport

-- Collapse / expand (↓ collapse, ↑ expand) — no separate minimize bar
local isCollapsed = false
local FULL_SIZE = UDim2.fromOffset(540, 360)
local COLLAPSED_SIZE = UDim2.fromOffset(540, 40)

collapseBtn.MouseButton1Click:Connect(function()
	isCollapsed = not isCollapsed
	if isCollapsed then
		contentArea.Visible = false
		mainFrame.Size = COLLAPSED_SIZE
		collapseBtn.Text = "↑"
		mainFrame.Position = UDim2.fromScale(0.5, 0.5)
		applyResponsiveScale()
	else
		contentArea.Visible = true
		mainFrame.Size = FULL_SIZE
		collapseBtn.Text = "↓"
		mainFrame.Position = UDim2.fromScale(0.5, 0.5)
		applyResponsiveScale()
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
			if frameObj == mainFrame then
				clampMainToViewport()
			end
		-- same touch finger moved
		elseif activeInput.UserInputType == Enum.UserInputType.Touch
			and input == activeInput then
			local delta = input.Position - dragStart
			frameObj.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
			if frameObj == mainFrame then
				clampMainToViewport()
			end
		end
	end)
end

setupDraggable(topBar, mainFrame)
-- compact bar unused (↑↓ collapse instead)

-- ======================
-- RESPONSIVE SIZE / POSITION
-- 100% reference size: 1000 x 575 (matching the second screenshot).
-- On smaller viewports, the effective visual scale is reduced only as much
-- as needed to keep the complete window visible. The requested percentage
-- shown in Config remains unchanged.
-- ======================
local requestedScale = 1

local function getViewportSize()
	local size = screenGui.AbsoluteSize
	if size.X <= 0 or size.Y <= 0 then
		return Vector2.new(1920, 1080)
	end
	return Vector2.new(size.X, size.Y)
end

function applyResponsiveScale()
	local viewport = getViewportSize()
	local baseSize = isCollapsed and Vector2.new(1000, 40) or Vector2.new(1000, 575)
	local fitScale = math.min(1, viewport.X / baseSize.X, viewport.Y / baseSize.Y)
	local effectiveScale = math.min(requestedScale, fitScale)

	uiScale.Scale = effectiveScale
	if compactScale then
		compactScale.Scale = math.min(requestedScale, math.min(1, viewport.X / 1000, viewport.Y / 40))
	end

	mainFrame.Size = isCollapsed and COLLAPSED_SIZE or FULL_SIZE
	mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	mainFrame.Position = UDim2.fromScale(0.5, 0.5)
end

function clampMainToViewport()
	if not mainFrame or not mainFrame.Parent then return end
	local viewport = getViewportSize()
	local frameSize = mainFrame.AbsoluteSize
	local maxX = math.max(0, (viewport.X - frameSize.X) / 2)
	local maxY = math.max(0, (viewport.Y - frameSize.Y) / 2)
	local offsetX = math.clamp(mainFrame.Position.X.Offset, -maxX, maxX)
	local offsetY = math.clamp(mainFrame.Position.Y.Offset, -maxY, maxY)
	mainFrame.Position = UDim2.new(0.5, offsetX, 0.5, offsetY)
end

local function updateScale(val)
	local clamped = math.clamp(val, 50, 100)
	requestedScale = clamped / 100
	mainFrame.Size = isCollapsed and COLLAPSED_SIZE or FULL_SIZE
	scaleLabel.Text = "Scale  ·  " .. math.floor(clamped) .. "%"
	local pct = (clamped - 50) / 50
	scaleSliderFill.Size = UDim2.new(pct, 0, 1, 0)
	scaleKnob.Position = UDim2.new(pct, -8, 0.5, -8)
	applyResponsiveScale()
end

screenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	applyResponsiveScale()
	clampMainToViewport()
end)

local sliding = false
scaleSliderBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		sliding = true
		local pos = input.Position.X
		local absPos = scaleSliderBg.AbsolutePosition.X
		local absSize = scaleSliderBg.AbsoluteSize.X
		local pct = math.clamp((pos - absPos) / absSize, 0, 1)
		updateScale(50 + (pct * 50))
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
		updateScale(50 + (pct * 50))
	end
end)

resetScaleBtn.MouseButton1Click:Connect(function()
	updateScale(100)
	mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	mainFrame.Position = UDim2.fromScale(0.5, 0.5)
	applyResponsiveScale()
	clampMainToViewport()
end)

-- Live Time Playing counter
local playSeconds = 0
task.spawn(function()
	while screenGui.Parent do
		task.wait(1)
		playSeconds += 1
		if timeLabel and timeLabel.Parent then
			timeLabel.Text = "Time Playing: " .. tostring(playSeconds) .. "s"
		end
	end
end)



-- Avatar + name: fixed inside the left sidebar footer so it never gets clipped
-- when the main UI is moved upward/downward.
local sideAvatar = Instance.new("ImageLabel")
sideAvatar.Size = UDim2.fromOffset(28, 28)
sideAvatar.Position = UDim2.new(0, 8, 1, -36)
sideAvatar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
sideAvatar.BorderSizePixel = 0
sideAvatar.ZIndex = 5
sideAvatar.Parent = tabRail

local sideAvatarCorner = Instance.new("UICorner")
sideAvatarCorner.CornerRadius = UDim.new(1, 0)
sideAvatarCorner.Parent = sideAvatar

local sideName = Instance.new("TextLabel")
sideName.Size = UDim2.new(0, 70, 0, 28)
sideName.Position = UDim2.new(0, 42, 1, -36)
sideName.BackgroundTransparency = 1
sideName.Font = Enum.Font.GothamBold
sideName.Text = player.DisplayName or player.Name
sideName.TextColor3 = Color3.fromRGB(230, 230, 240)
sideName.TextSize = 12
sideName.TextXAlignment = Enum.TextXAlignment.Left
sideName.TextTruncate = Enum.TextTruncate.AtEnd
sideName.ZIndex = 5
sideName.Parent = tabRail

task.spawn(function()
	local ok, content = pcall(function()
		return Players:GetUserThumbnailAsync(
			player.UserId,
			Enum.ThumbnailType.HeadShot,
			Enum.ThumbnailSize.Size48x48
		)
	end)
	if ok and content then
		sideAvatar.Image = content
	end
end)

-- Rainbow outlines for the four script columns. This is intentionally
-- separate from the selected theme so the column borders stay rainbow.
local rainbowTime = 0
RunService.RenderStepped:Connect(function(dt)
	if not screenGui.Parent then return end
	rainbowTime = (rainbowTime + dt * 0.18) % 1
	for i, stroke in ipairs(rainbowStrokes) do
		if stroke and stroke.Parent then
			local hue = (rainbowTime + ((i - 1) / math.max(1, #rainbowStrokes))) % 1
			stroke.Color = Color3.fromHSV(hue, 0.9, 1)
		end
	end

	-- Animated rainbow Execute buttons. Each button gets a slightly shifted hue
	-- so the effect flows continuously instead of flashing between colors.
	for i, button in ipairs(rainbowButtons) do
		if button and button.Parent then
			local hue = (rainbowTime + ((i - 1) / math.max(1, #rainbowButtons)) * 0.35) % 1
			button.BackgroundColor3 = Color3.fromHSV(hue, 0.9, 1)
			button.TextColor3 = Color3.fromRGB(255, 255, 255)
		end
	end
end)

print("[Vyre Hub | Multiverse Script Sae] Loaded")


-- Final loading pass: reveal only after the whole UI exists.
task.spawn(function()
	for i = 0, 100 do
		if not loadOverlay or not loadOverlay.Parent then break end
		loadBarFill.Size = UDim2.new(i / 100, 0, 1, 0)
		loadPct.Text = tostring(i) .. "%"
		task.wait(0.012)
	end
	task.wait(0.15)
	if mainFrame and mainFrame.Parent then
		requestedScale = 1
		mainFrame.Size = FULL_SIZE
		mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		mainFrame.Position = UDim2.fromScale(0.5, 0.5)
		applyResponsiveScale()
		clampMainToViewport()
		mainFrame.Visible = true
	end
	if loadOverlay and loadOverlay.Parent then
		loadOverlay:Destroy()
	end
end)
