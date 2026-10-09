--[[
	Original Roblox Studio hub UI.
	Place this LocalScript in StarterPlayerScripts or StarterGui.
	The controls manage this interface and open Roblox's own settings;
	they do not modify gameplay or rely on executor-only APIs.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local existing = playerGui:FindFirstChild("VirexStyleHub")
if existing then
	existing:Destroy()
end

local palettes = {
	Obsidian = {
		Background = Color3.fromRGB(12, 15, 22),
		Panel = Color3.fromRGB(19, 23, 33),
		Card = Color3.fromRGB(26, 31, 43),
		Accent = Color3.fromRGB(112, 97, 255),
		AccentSoft = Color3.fromRGB(47, 42, 87),
		Text = Color3.fromRGB(240, 242, 249),
		Muted = Color3.fromRGB(153, 162, 180),
		Border = Color3.fromRGB(48, 57, 75),
		Danger = Color3.fromRGB(235, 87, 99),
		Green = Color3.fromRGB(78, 202, 146),
	},
	DeepTeal = {
		Background = Color3.fromRGB(11, 18, 23),
		Panel = Color3.fromRGB(17, 27, 34),
		Card = Color3.fromRGB(23, 37, 45),
		Accent = Color3.fromRGB(48, 195, 177),
		AccentSoft = Color3.fromRGB(29, 67, 67),
		Text = Color3.fromRGB(237, 245, 245),
		Muted = Color3.fromRGB(149, 171, 175),
		Border = Color3.fromRGB(42, 65, 71),
		Danger = Color3.fromRGB(235, 87, 99),
		Green = Color3.fromRGB(78, 202, 146),
	},
}

local themeName = "Obsidian"
local themeBindings = {}
local reducedMotion = false
local notificationsEnabled = true

local function registerTheme(instance, property, role)
	table.insert(themeBindings, {
		instance = instance,
		property = property,
		role = role,
	})

	local palette = palettes[themeName]
	if palette and palette[role] then
		instance[property] = palette[role]
	end
end

local function setThemeRole(instance, property, role)
	local found = false

	for _, binding in ipairs(themeBindings) do
		if binding.instance == instance and binding.property == property then
			binding.role = role
			found = true
		end
	end

	if not found then
		registerTheme(instance, property, role)
	elseif palettes[themeName][role] then
		instance[property] = palettes[themeName][role]
	end
end

local function applyTheme(name)
	if not palettes[name] then
		return
	end

	themeName = name
	local palette = palettes[themeName]

	for _, binding in ipairs(themeBindings) do
		if binding.instance.Parent and palette[binding.role] then
			pcall(function()
				binding.instance[binding.property] = palette[binding.role]
			end)
		end
	end
end

local function make(className, parent, properties)
	local object = Instance.new(className)
	for property, value in pairs(properties or {}) do
		object[property] = value
	end
	object.Parent = parent
	return object
end

local function addCorner(parent, radius)
	make("UICorner", parent, {
		CornerRadius = UDim.new(0, radius or 10),
	})
end

local function addStroke(parent, role, thickness)
	local stroke = make("UIStroke", parent, {
		Thickness = thickness or 1,
		Transparency = 0,
	})
	registerTheme(stroke, "Color", role or "Border")
	return stroke
end

local function playTween(object, properties, duration)
	if not object or not object.Parent then
		return
	end

	local time = duration
	if time == nil then
		time = reducedMotion and 0 or 0.18
	end

	if time <= 0 then
		pcall(function()
			for property, value in pairs(properties) do
				object[property] = value
			end
		end)
		return
	end

	local ok, tween = pcall(function()
		return TweenService:Create(
			object,
			TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
			properties
		)
	end)

	if ok then
		tween:Play()
	end
end

local screenGui = make("ScreenGui", playerGui, {
	Name = "VirexStyleHub",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	DisplayOrder = 20,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

local window = make("Frame", screenGui, {
	Name = "Window",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.fromOffset(760, 510),
	BorderSizePixel = 0,
	ClipsDescendants = true,
})
registerTheme(window, "BackgroundColor3", "Background")
addCorner(window, 14)
addStroke(window, "Border", 1)

local uiScale = make("UIScale", window, {
	Scale = 1,
})

-- Fit the desktop-sized layout to the current device viewport (including phones).
-- Keep the user's preferred scale separate from the automatic fit scale.
local scaleValue = 1
local viewportConnection
local cameraConnection

local function updateResponsiveScale()
	local camera = workspace.CurrentCamera
	if not camera then
		return
	end

	local viewport = camera.ViewportSize
	local availableWidth = math.max(1, viewport.X - 20)
	local availableHeight = math.max(1, viewport.Y - 20)
	local fitScale = math.min(availableWidth / 760, availableHeight / 510, 1)
	fitScale = math.clamp(fitScale, 0.35, 1)
	uiScale.Scale = fitScale * scaleValue
end

local function watchCurrentCamera()
	if viewportConnection then
		viewportConnection:Disconnect()
		viewportConnection = nil
	end
	local camera = workspace.CurrentCamera
	if camera then
		viewportConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateResponsiveScale)
	end
	updateResponsiveScale()
end

watchCurrentCamera()
cameraConnection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(watchCurrentCamera)
screenGui.Destroying:Connect(function()
	if viewportConnection then viewportConnection:Disconnect() end
	if cameraConnection then cameraConnection:Disconnect() end
end)

local titleBar = make("Frame", window, {
	Name = "TitleBar",
	Size = UDim2.new(1, 0, 0, 50),
	BorderSizePixel = 0,
})
registerTheme(titleBar, "BackgroundColor3", "Panel")

local dragHandle = make("Frame", titleBar, {
	Name = "DragHandle",
	Size = UDim2.new(1, -148, 1, 0),
	BackgroundTransparency = 1,
	Active = true,
})

local titleLabel = make("TextLabel", dragHandle, {
	Position = UDim2.fromOffset(18, 7),
	Size = UDim2.new(0, 190, 0, 21),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	Text = "VIREX  /  HUB",
	TextSize = 15,
	TextXAlignment = Enum.TextXAlignment.Left,
})
registerTheme(titleLabel, "TextColor3", "Text")

local subtitleLabel = make("TextLabel", dragHandle, {
	Position = UDim2.fromOffset(18, 28),
	Size = UDim2.new(0, 270, 0, 15),
	BackgroundTransparency = 1,
	Font = Enum.Font.Gotham,
	Text = "A clean, local interface for your experience",
	TextSize = 10,
	TextXAlignment = Enum.TextXAlignment.Left,
})
registerTheme(subtitleLabel, "TextColor3", "Muted")

local clockLabel = make("TextLabel", titleBar, {
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -112, 0.5, 0),
	Size = UDim2.fromOffset(55, 22),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamMedium,
	Text = os.date("%H:%M"),
	TextSize = 12,
	TextXAlignment = Enum.TextXAlignment.Right,
})
registerTheme(clockLabel, "TextColor3", "Muted")

local minimizeButton = make("TextButton", titleBar, {
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -52, 0.5, 0),
	Size = UDim2.fromOffset(30, 30),
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Font = Enum.Font.GothamBold,
	Text = "—",
	TextSize = 16,
})
registerTheme(minimizeButton, "BackgroundColor3", "Card")
registerTheme(minimizeButton, "TextColor3", "Text")
addCorner(minimizeButton, 8)

local closeButton = make("TextButton", titleBar, {
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -14, 0.5, 0),
	Size = UDim2.fromOffset(30, 30),
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Font = Enum.Font.GothamBold,
	Text = "×",
	TextSize = 19,
})
registerTheme(closeButton, "BackgroundColor3", "Card")
registerTheme(closeButton, "TextColor3", "Danger")
addCorner(closeButton, 8)

local body = make("Frame", window, {
	Name = "Body",
	Position = UDim2.fromOffset(0, 50),
	Size = UDim2.new(1, 0, 1, -50),
	BackgroundTransparency = 1,
})

local sidebar = make("Frame", body, {
	Name = "Sidebar",
	Size = UDim2.new(0, 172, 1, 0),
	BorderSizePixel = 0,
})
registerTheme(sidebar, "BackgroundColor3", "Panel")

local sidebarPadding = make("UIPadding", sidebar, {
	PaddingTop = UDim.new(0, 16),
	PaddingLeft = UDim.new(0, 12),
	PaddingRight = UDim.new(0, 12),
	PaddingBottom = UDim.new(0, 12),
})

local navLayout = make("UIListLayout", sidebar, {
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 7),
})

local navHeading = make("TextLabel", sidebar, {
	Size = UDim2.new(1, 0, 0, 23),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	Text = "NAVIGATION",
	TextSize = 10,
	TextXAlignment = Enum.TextXAlignment.Left,
	LayoutOrder = 0,
})
registerTheme(navHeading, "TextColor3", "Muted")

local navButtons = {}
local pages = {}
local pageDescriptions = {}
local currentTab = nil

local contentArea = make("Frame", body, {
	Name = "ContentArea",
	Position = UDim2.new(0, 172, 0, 0),
	Size = UDim2.new(1, -172, 1, 0),
	BackgroundTransparency = 1,
})

local pageTitle = make("TextLabel", contentArea, {
	Position = UDim2.fromOffset(22, 17),
	Size = UDim2.new(1, -44, 0, 27),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	Text = "Overview",
	TextSize = 21,
	TextXAlignment = Enum.TextXAlignment.Left,
})
registerTheme(pageTitle, "TextColor3", "Text")

local pageSubtitle = make("TextLabel", contentArea, {
	Position = UDim2.fromOffset(22, 45),
	Size = UDim2.new(1, -44, 0, 20),
	BackgroundTransparency = 1,
	Font = Enum.Font.Gotham,
	Text = "Your current session at a glance.",
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left,
})
registerTheme(pageSubtitle, "TextColor3", "Muted")

local pageContainer = make("Frame", contentArea, {
	Name = "Pages",
	Position = UDim2.fromOffset(22, 76),
	Size = UDim2.new(1, -44, 1, -91),
	BackgroundTransparency = 1,
})

local function makePage(tabName, description)
	local page = make("ScrollingFrame", pageContainer, {
		Name = tabName .. "Page",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 4,
		ScrollBarImageTransparency = 0.25,
		Visible = false,
	})

	local padding = make("UIPadding", page, {
		PaddingTop = UDim.new(0, 1),
		PaddingBottom = UDim.new(0, 12),
		PaddingRight = UDim.new(0, 5),
	})

	make("UIListLayout", page, {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 9),
	})

	pages[tabName] = page
	pageDescriptions[tabName] = description
	return page
end

local function addSection(page, text, order)
	local label = make("TextLabel", page, {
		Size = UDim2.new(1, 0, 0, 22),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		Text = string.upper(text),
		TextSize = 10,
		TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder = order or 0,
	})
	registerTheme(label, "TextColor3", "Muted")
	return label
end

local function makeCard(page, title, description, order, height)
	local card = make("Frame", page, {
		Size = UDim2.new(1, 0, 0, height or 68),
		BorderSizePixel = 0,
		LayoutOrder = order or 1,
	})
	registerTheme(card, "BackgroundColor3", "Card")
	addCorner(card, 10)
	addStroke(card, "Border", 1)

	local titleLabel = make("TextLabel", card, {
		Position = UDim2.fromOffset(14, 9),
		Size = UDim2.new(1, -152, 0, 20),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		Text = title,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	registerTheme(titleLabel, "TextColor3", "Text")

	local descriptionLabel = make("TextLabel", card, {
		Position = UDim2.fromOffset(14, 31),
		Size = UDim2.new(1, -152, 0, 27),
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		Text = description,
		TextSize = 10,
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	registerTheme(descriptionLabel, "TextColor3", "Muted")

	return card, titleLabel, descriptionLabel
end

local function makeActionButton(parent, text, callback, width)
	local button = make("TextButton", parent, {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.fromOffset(width or 106, 32),
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Enum.Font.GothamMedium,
		Text = text,
		TextSize = 11,
	})
	registerTheme(button, "BackgroundColor3", "AccentSoft")
	registerTheme(button, "TextColor3", "Text")
	addCorner(button, 8)

	button.Activated:Connect(callback)
	return button
end

local function addActionCard(page, title, description, order, buttonText, callback)
	local card = makeCard(page, title, description, order)
	makeActionButton(card, buttonText, callback)
	return card
end

local function addToggleCard(page, title, description, order, initialValue, callback)
	local card = makeCard(page, title, description, order)

	local toggleButton = make("TextButton", card, {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.fromOffset(62, 30),
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Enum.Font.GothamBold,
		TextSize = 10,
	})
	addCorner(toggleButton, 9)

	local value = initialValue

	local function setValue(newValue)
		value = not not newValue
		toggleButton.Text = value and "ON" or "OFF"
		setThemeRole(
			toggleButton,
			"BackgroundColor3",
			value and "Accent" or "Panel"
		)
		if callback then
			callback(value)
		end
	end

	toggleButton.Activated:Connect(function()
		setValue(not value)
	end)

	setValue(value)
	return {
		Set = setValue,
		Get = function()
			return value
		end,
		Button = toggleButton,
	}
end

local toastItems = {}

local function repositionToasts()
	for index, item in ipairs(toastItems) do
		if item.frame and item.frame.Parent then
			playTween(item.frame, {
				Position = UDim2.new(1, -20, 0, 20 + (index - 1) * 78),
			})
		end
	end
end

local function notify(title, message)
	if not notificationsEnabled or not screenGui.Parent then
		return
	end

	local toast = make("Frame", screenGui, {
		Name = "Notification",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 30, 0, 20),
		Size = UDim2.fromOffset(310, 68),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ZIndex = 20,
	})
	registerTheme(toast, "BackgroundColor3", "Card")
	addCorner(toast, 10)
	addStroke(toast, "Border", 1)

	local heading = make("TextLabel", toast, {
		Position = UDim2.fromOffset(13, 9),
		Size = UDim2.new(1, -26, 0, 20),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		Text = title,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 21,
	})
	registerTheme(heading, "TextColor3", "Text")

	local bodyText = make("TextLabel", toast, {
		Position = UDim2.fromOffset(13, 31),
		Size = UDim2.new(1, -26, 0, 25),
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		Text = message,
		TextSize = 10,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		ZIndex = 21,
	})
	registerTheme(bodyText, "TextColor3", "Muted")

	local item = { frame = toast }
	table.insert(toastItems, item)
	repositionToasts()

	playTween(toast, { BackgroundTransparency = 0 })
	playTween(heading, { TextTransparency = 0 })
	playTween(bodyText, { TextTransparency = 0 })

	task.delay(3.5, function()
		if not toast.Parent then
			return
		end

		playTween(toast, {
			BackgroundTransparency = 1,
			Position = toast.Position + UDim2.fromOffset(16, 0),
		})

		for _, child in ipairs(toast:GetChildren()) do
			if child:IsA("TextLabel") then
				playTween(child, { TextTransparency = 1 })
			elseif child:IsA("UIStroke") then
				playTween(child, { Transparency = 1 })
			end
		end

		task.delay(reducedMotion and 0 or 0.2, function()
			if toast.Parent then
				toast:Destroy()
			end

			for index, existingItem in ipairs(toastItems) do
				if existingItem == item then
					table.remove(toastItems, index)
					break
				end
			end
			repositionToasts()
		end)
	end)
end

local function selectTab(tabName)
	if not pages[tabName] then
		return
	end

	currentTab = tabName
	for name, page in pairs(pages) do
		page.Visible = name == tabName
	end

	pageTitle.Text = tabName
	pageSubtitle.Text = pageDescriptions[tabName] or ""

	for name, button in pairs(navButtons) do
		local selected = name == tabName
		setThemeRole(button, "BackgroundColor3", selected and "AccentSoft" or "Panel")
		setThemeRole(button, "TextColor3", selected and "Text" or "Muted")
	end
end

local tabs = {
	{ name = "Overview", description = "Your current session at a glance." },
	{ name = "Appearance", description = "Adjust the look and motion of this interface." },
	{ name = "Tools", description = "Useful interface and Roblox settings actions." },
	{ name = "Settings", description = "Manage notifications, scale, and preferences." },
}

for index, tab in ipairs(tabs) do
	local button = make("TextButton", sidebar, {
		Name = tab.name .. "Tab",
		Size = UDim2.new(1, 0, 0, 38),
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Enum.Font.GothamMedium,
		Text = "   " .. tab.name,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder = index,
	})
	registerTheme(button, "BackgroundColor3", "Panel")
	registerTheme(button, "TextColor3", "Muted")
	addCorner(button, 8)

	button.Activated:Connect(function()
		selectTab(tab.name)
	end)

	navButtons[tab.name] = button
end

local sidebarFooter = make("Frame", sidebar, {
	AnchorPoint = Vector2.new(0, 1),
	Position = UDim2.new(0, 0, 1, 0),
	Size = UDim2.new(1, 0, 0, 58),
	BorderSizePixel = 0,
})
registerTheme(sidebarFooter, "BackgroundColor3", "Card")
addCorner(sidebarFooter, 9)
addStroke(sidebarFooter, "Border", 1)

local footerStatus = make("TextLabel", sidebarFooter, {
	Position = UDim2.fromOffset(11, 8),
	Size = UDim2.new(1, -22, 0, 17),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamMedium,
	Text = "●  Interface ready",
	TextSize = 10,
	TextXAlignment = Enum.TextXAlignment.Left,
})
registerTheme(footerStatus, "TextColor3", "Green")

local footerPlayer = make("TextLabel", sidebarFooter, {
	Position = UDim2.fromOffset(11, 28),
	Size = UDim2.new(1, -22, 0, 17),
	BackgroundTransparency = 1,
	Font = Enum.Font.Gotham,
	Text = player.DisplayName,
	TextSize = 10,
	TextTruncate = Enum.TextTruncate.AtEnd,
	TextXAlignment = Enum.TextXAlignment.Left,
})
registerTheme(footerPlayer, "TextColor3", "Muted")

local overviewPage = makePage("Overview", tabs[1].description)
local appearancePage = makePage("Appearance", tabs[2].description)
local toolsPage = makePage("Tools", tabs[3].description)
local settingsPage = makePage("Settings", tabs[4].description)

-- Overview page
addSection(overviewPage, "Session", 1)

local overviewCard, _, overviewDescription = makeCard(
	overviewPage,
	"Experience session",
	"",
	2,
	76
)

local function refreshSession()
	local placeName = game.Name
	if placeName == "" then
		placeName = "Roblox experience"
	end

	overviewDescription.Text = string.format(
		"%s  •  Place ID %s  •  Player %s  •  Refreshed %s",
		placeName,
		tostring(game.PlaceId),
		player.DisplayName,
		os.date("%H:%M:%S")
	)
end

refreshSession()
makeActionButton(overviewCard, "Refresh", function()
	refreshSession()
	notify("Session refreshed", "The session details are up to date.")
end, 92)

addSection(overviewPage, "Quick actions", 3)

addActionCard(
	overviewPage,
	"Open Roblox settings",
	"Open the platform's built-in settings menu.",
	4,
	"Open settings",
	function()
		local ok = pcall(function()
			GuiService:OpenSettings()
		end)

		if not ok then
			notify("Settings unavailable", "Roblox settings could not be opened here.")
		end
	end
)

addActionCard(
	overviewPage,
	"Appearance",
	"Jump to the controls for theme, window size, and motion.",
	5,
	"Customize",
	function()
		selectTab("Appearance")
	end
)

addSection(overviewPage, "About", 6)

local aboutCard = make("Frame", overviewPage, {
	Size = UDim2.new(1, 0, 0, 62),
	BorderSizePixel = 0,
	LayoutOrder = 7,
})
registerTheme(aboutCard, "BackgroundColor3", "Card")
addCorner(aboutCard, 10)
addStroke(aboutCard, "Border", 1)

local aboutText = make("TextLabel", aboutCard, {
	Position = UDim2.fromOffset(14, 10),
	Size = UDim2.new(1, -28, 1, -20),
	BackgroundTransparency = 1,
	Font = Enum.Font.Gotham,
	Text = "This original hub is client-side UI for your own experience. It uses Roblox Studio APIs and does not include executor-only features.",
	TextSize = 10,
	TextWrapped = true,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Center,
})
registerTheme(aboutText, "TextColor3", "Muted")

-- Appearance page
addSection(appearancePage, "Window", 1)

local compactMode = false
local minimized = false

local function getWindowSize()
	if compactMode then
		return UDim2.fromOffset(700, 470)
	end
	return UDim2.fromOffset(760, 510)
end

local function updateWindowSize()
	if minimized then
		local width = compactMode and 700 or 760
		playTween(window, { Size = UDim2.fromOffset(width, 50) })
	else
		playTween(window, { Size = getWindowSize() })
	end
end

local function setMinimized(value)
	minimized = not not value

	if minimized then
		body.Visible = false
		minimizeButton.Text = "□"
		playTween(window, {
			Size = UDim2.fromOffset(compactMode and 700 or 760, 50),
		})
	else
		body.Visible = true
		minimizeButton.Text = "—"
		playTween(window, { Size = getWindowSize() })
	end
end

local clockToggle
local compactToggle
local motionToggle
local notificationToggle

compactToggle = addToggleCard(
	appearancePage,
	"Compact window",
	"Use a smaller window size while keeping all controls available.",
	2,
	false,
	function(value)
		compactMode = value
		updateWindowSize()
	end
)

clockToggle = addToggleCard(
	appearancePage,
	"Title bar clock",
	"Show or hide the local time in the title bar.",
	3,
	true,
	function(value)
		clockLabel.Visible = value
	end
)

addSection(appearancePage, "Motion", 4)

motionToggle = addToggleCard(
	appearancePage,
	"Reduced motion",
	"Turn off interface tweens and use immediate transitions.",
	5,
	false,
	function(value)
		reducedMotion = value
	end
)

addSection(appearancePage, "Theme", 6)

local themeButton
local function cycleTheme()
	local names = { "Obsidian", "DeepTeal" }
	local currentIndex = table.find(names, themeName) or 1
	local nextIndex = currentIndex % #names + 1

	applyTheme(names[nextIndex])
	if themeButton then
		themeButton.Text = themeName
	end

	notify("Theme changed", "Using the " .. themeName .. " color theme.")
end

local themeCard = makeCard(
	appearancePage,
	"Color theme",
	"Switch between the included interface color palettes.",
	7
)
themeButton = makeActionButton(themeCard, themeName, cycleTheme, 106)

-- Tools page
addSection(toolsPage, "Interface", 1)

addActionCard(
	toolsPage,
	"Recenter window",
	"Move the hub back to the center of the screen.",
	2,
	"Recenter",
	function()
		playTween(window, {
			Position = UDim2.new(0.5, 0, 0.5, 0),
		})
		notify("Window centered", "The hub was moved to the screen center.")
	end
)

addActionCard(
	toolsPage,
	"Minimize window",
	"Collapse the hub to its title bar. Click the square button to restore it.",
	3,
	"Minimize",
	function()
		setMinimized(true)
	end
)

addSection(toolsPage, "Roblox", 4)

addActionCard(
	toolsPage,
	"Open Roblox settings",
	"Open Roblox's built-in settings menu.",
	5,
	"Open settings",
	function()
		local ok = pcall(function()
			GuiService:OpenSettings()
		end)

		if not ok then
			notify("Settings unavailable", "Roblox settings could not be opened here.")
		end
	end
)

addActionCard(
	toolsPage,
	"Show session details",
	"Display the current experience, place ID, and player name.",
	6,
	"Show details",
	function()
		notify(
			"Current session",
			string.format("%s • Place %s • %s", game.Name, tostring(game.PlaceId), player.DisplayName)
		)
	end
)

-- Settings page
addSection(settingsPage, "Notifications", 1)

notificationToggle = addToggleCard(
	settingsPage,
	"Hub notifications",
	"Enable or silence notifications created by this interface.",
	2,
	true,
	function(value)
		notificationsEnabled = value
	end
)

addSection(settingsPage, "Interface scale", 3)

local scaleCard = make("Frame", settingsPage, {
	Size = UDim2.new(1, 0, 0, 74),
	BorderSizePixel = 0,
	LayoutOrder = 4,
})
registerTheme(scaleCard, "BackgroundColor3", "Card")
addCorner(scaleCard, 10)
addStroke(scaleCard, "Border", 1)

local scaleTitle = make("TextLabel", scaleCard, {
	Position = UDim2.fromOffset(14, 10),
	Size = UDim2.new(1, -150, 0, 20),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamMedium,
	Text = "UI scale",
	TextSize = 13,
	TextXAlignment = Enum.TextXAlignment.Left,
})
registerTheme(scaleTitle, "TextColor3", "Text")

local scaleDescription = make("TextLabel", scaleCard, {
	Position = UDim2.fromOffset(14, 33),
	Size = UDim2.new(1, -150, 0, 18),
	BackgroundTransparency = 1,
	Font = Enum.Font.Gotham,
	Text = "Current scale: 100%",
	TextSize = 10,
	TextXAlignment = Enum.TextXAlignment.Left,
})
registerTheme(scaleDescription, "TextColor3", "Muted")

local function updateScale(delta)
	scaleValue = math.clamp(math.round((scaleValue + delta) * 100) / 100, 0.8, 1.15)
	scaleDescription.Text = string.format("Current scale: %d%%", math.round(scaleValue * 100))
	updateResponsiveScale()
end

local minusButton = make("TextButton", scaleCard, {
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -91, 0.5, 0),
	Size = UDim2.fromOffset(32, 32),
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Font = Enum.Font.GothamBold,
	Text = "−",
	TextSize = 17,
})
registerTheme(minusButton, "BackgroundColor3", "AccentSoft")
registerTheme(minusButton, "TextColor3", "Text")
addCorner(minusButton, 8)
minusButton.Activated:Connect(function()
	updateScale(-0.05)
end)

local plusButton = make("TextButton", scaleCard, {
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -13, 0.5, 0),
	Size = UDim2.fromOffset(32, 32),
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Font = Enum.Font.GothamBold,
	Text = "+",
	TextSize = 17,
})
registerTheme(plusButton, "BackgroundColor3", "AccentSoft")
registerTheme(plusButton, "TextColor3", "Text")
addCorner(plusButton, 8)
plusButton.Activated:Connect(function()
	updateScale(0.05)
end)

addSection(settingsPage, "Preferences", 5)

local function resetPreferences()
	applyTheme("Obsidian")
	if themeButton then
		themeButton.Text = themeName
	end

	if compactToggle then
		compactToggle.Set(false)
	end
	if clockToggle then
		clockToggle.Set(true)
	end
	if motionToggle then
		motionToggle.Set(false)
	end
	if notificationToggle then
		notificationToggle.Set(true)
	end

	scaleValue = 1
	scaleDescription.Text = "Current scale: 100%"
	updateResponsiveScale()
	playTween(window, { Position = UDim2.new(0.5, 0, 0.5, 0) })
	setMinimized(false)

	notify("Preferences reset", "The hub is back to its default settings.")
end

addActionCard(
	settingsPage,
	"Reset preferences",
	"Restore the default theme, scale, window size, and toggle states.",
	6,
	"Reset",
	resetPreferences
)

addActionCard(
	settingsPage,
	"Close hub",
	"Remove this interface from the screen.",
	7,
	"Close",
	function()
		screenGui:Destroy()
	end
)

-- Minimize and close controls
minimizeButton.Activated:Connect(function()
	setMinimized(not minimized)
end)

closeButton.Activated:Connect(function()
	screenGui:Destroy()
end)

-- Dragging is limited to the empty/title area, not the window buttons.
local dragging = false
local dragStart = nil
local startPosition = nil

dragHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPosition = window.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging
		and (input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		window.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end
end)

-- Keep the clock current while the interface exists.
task.spawn(function()
	while screenGui.Parent do
		clockLabel.Text = os.date("%H:%M")
		task.wait(1)
	end
end)

selectTab("Overview")
notify("Hub ready", "Use the sidebar to explore the interface.")
