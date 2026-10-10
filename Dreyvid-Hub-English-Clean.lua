-- [ Dreyvid Source 100% Complete — cleaned function names (English UI) ]
-- [ By CeboScripts ] https://discord.gg/AwGHNh7Z7T

local players = game:GetService("Players")
local tweenService = game:GetService("TweenService")
local proximityPromptService = game:GetService("ProximityPromptService")
local runService = game:GetService("RunService")
local workspaceService = game:GetService("Workspace")
local statsService = game:GetService("Stats")
local teleportService = game:GetService("TeleportService")
local httpService = game:GetService("HttpService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local collectionService = game:GetService("CollectionService")
local userInputService = game:GetService("UserInputService")
local guiService = game:GetService("GuiService")
local coreGui = game:GetService("CoreGui")
local localPlayer = players.LocalPlayer
local currentCamera = workspaceService.CurrentCamera
local placeId = game.PlaceId
local playerGui

if not playerGui then
  pcall(function() playerGui = coreGui end)
end

if not playerGui then
  playerGui = localPlayer:WaitForChild("PlayerGui")
end

local function copyToClipboard(p1)
  if setclipboard then
    setclipboard(p1)
  elseif toclipboard then
    toclipboard(p1)
  end
end

local function loadUiScale()
  if readfile and isfile then
    local v1, v2 = pcall(isfile, "dreyvid_config_v2.txt")

    if v1 and v2 then
      local v3, v4 = pcall(readfile, "dreyvid_config_v2.txt")

      if v3 and v4 then
        local v5 = tonumber(v4)

        if v5 then
          return math.clamp(v5, 0.7, 1.15)
        end

        return 1
      end

      return 1
    end

    return 1
  end

  return 1
end

local function saveUiScale(p2)
  if writefile then
    pcall(function() writefile("dreyvid_config_v2.txt", tostring(p2)) end)
  end
end

local getUserThumbnailAsync = players:GetUserThumbnailAsync(
  players:GetUserIdFromNameAsync("anki1362"), Enum.ThumbnailType.HeadShot,
  Enum.ThumbnailSize.Size420x420
)

local v6 = {
  CFrame.new(4747.71, 70.57, -335.25), CFrame.new(3520.94, 70.73, -343.74),
  CFrame.new(2446.02, 70.88, -351.18), CFrame.new(1352.11, 71.02, -358.75),
  CFrame.new(544.49, 71.13, -364.34),
}

local v7 = false
local v8 = {}
local v9 = {}

local function runAntiHitTeleport()
  local character = localPlayer.Character

  if not character then
    return
  end

  local humanoid = character:FindFirstChildOfClass("Humanoid")
  local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
  local cframe, connect, v10

  if not humanoid or not humanoidRootPart then
    return
  else
    cframe = currentCamera.CFrame
    local cameraType = currentCamera.CameraType

    currentCamera.CameraType = Enum.CameraType.Scriptable
    currentCamera.CFrame = cframe

    humanoid.BreakJointsOnDeath = false

    for index, value in ipairs(character:GetDescendants()) do
      if value:IsA("Motor6D") then
        value.Enabled = true
      end
    end

    connect = nil

    humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
    humanoidRootPart.AssemblyAngularVelocity = Vector3.zero

    for index2, value2 in ipairs(v6) do
      humanoid.PlatformStand = true
      humanoid.Health = 100

      humanoidRootPart.CFrame = value2
      humanoidRootPart.AssemblyLinearVelocity = Vector3.zero

      currentCamera.CFrame = cframe
      task.wait(0.02)
    end

    v10 = os.clock()

    connect = runService.Heartbeat:Connect(function()
      if os.clock() - v10 > 0.35 then
        connect:Disconnect()
        return
      end

      humanoid.Health = 100
      humanoid.PlatformStand = true

      humanoidRootPart.CFrame = v6[#v6]
      humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
      humanoidRootPart.AssemblyAngularVelocity = Vector3.zero

      currentCamera.CFrame = cframe
    end)

    task.wait(0.35)
    humanoid.PlatformStand = false
    currentCamera.CameraType = cameraType
    return
  end
end

local function applyPromptHoldSettings(value3)
  if not (value3 and typeof(value3) == "Instance" and value3:IsA("ProximityPrompt")) then
    return
  end

  if v7 then
    if v8[value3] == nil then
      v8[value3] = value3.HoldDuration
    end

    value3.HoldDuration = 0
    value3.RequiresLineOfSight = false
  elseif v8[value3] ~= nil then
    value3.HoldDuration = v8[value3]
    v8[value3] = nil
  end
end

local function setInstantPromptsEnabled(p3)
  if p3 then
    for index3, value4 in ipairs(workspaceService:GetDescendants()) do
      applyPromptHoldSettings(value4)
    end

    local descendantAdded = workspaceService.DescendantAdded
    table.insert(v9, descendantAdded:Connect(applyPromptHoldSettings))
    local promptShown = proximityPromptService.PromptShown
    table.insert(v9, promptShown:Connect(applyPromptHoldSettings))
  else
    for index4, value5 in ipairs(v9) do
    end

    v9 = {}

    for key, value6 in pairs(v8) do
      if key and key.Parent then
        key.HoldDuration = value6
      end
    end

    v8 = {}
  end
end

local vector = Vector3.new(200, 2, 200)
local v11 = false
local v12 = setmetatable({}, { __mode = "k" })
local v13 = {}

local platInvisible = Instance.new("Folder")
platInvisible.Name = "PlatInvisible"
platInvisible.Parent = workspaceService

local function forceInstantPrompt(value7)
  if not value7 or not value7:IsA("ProximityPrompt") then
    return
  end

  if value7.HoldDuration <= 0 then
    return
  end

  if v12[value7] == nil then
    v12[value7] = value7.HoldDuration
  end

  pcall(function() value7.HoldDuration = 0 end)
end

local promptShown2 = proximityPromptService.PromptShown
table.insert(v13, promptShown2:Connect(forceInstantPrompt))
local descendantAdded2 = workspaceService.DescendantAdded

table.insert(v13, descendantAdded2:Connect(function(p4)
  if p4:IsA("ProximityPrompt") then
    forceInstantPrompt(p4)
  end
end))

for index5, value8 in ipairs(workspaceService:GetDescendants()) do
  if value8:IsA("ProximityPrompt") then
    forceInstantPrompt(value8)
  end
end

local v14 = {}
local v15 = {}

local function hideBasePart(key2)
  if not key2 or not key2:IsA("BasePart") then
    return
  end

  if v15[key2] == nil then
    v15[key2] = {
      Transparency = key2.Transparency,
      LocalTransparencyModifier = key2.LocalTransparencyModifier,
    }
  end

  pcall(function()
    key2.Transparency = 1
    key2.LocalTransparencyModifier = 1
  end)
end

local function makeObjectInvisible(p5)
  if not p5 or not p5.Parent then
    return
  end

  local v16 = {}

  if p5:IsA("BasePart") then
    hideBasePart(p5)
    v16[#v16 + 1] = p5
  end

  for index6, value9 in ipairs(p5:GetDescendants()) do
    local v17 = value9

    if v17:IsA("BasePart") then
      hideBasePart(v17)
      v16[#v16 + 1] = v17
    elseif v17:IsA("Decal") or v17:IsA("Texture") then
      if v15[v17] == nil then
        v15[v17] = { Transparency = v17.Transparency }
      end

      pcall(function() v17.Transparency = 1 end)
      v16[#v16 + 1] = v17
    elseif v17:IsA("ParticleEmitter") or v17:IsA("Trail") or v17:IsA("Beam") then
      pcall(function() v17.Enabled = false end)
    elseif v17:IsA("PointLight") or v17:IsA("SpotLight") or v17:IsA("SurfaceLight") then
      pcall(function() v17.Enabled = false end)
    end
  end

  task.spawn(function()
    while p5 and p5.Parent do
      for index7, value10 in ipairs(v16) do
        local v18 = value10

        if v18.Parent then
          pcall(function()
            if v18:IsA("BasePart") then
              v18.Transparency = 1
              v18.LocalTransparencyModifier = 1
            elseif v18:IsA("Decal") or v18:IsA("Texture") then
              v18.Transparency = 1
            end
          end)
        end
      end

      runService.Heartbeat:Wait()
    end
  end)
end

local function disablePartTouch(value11)
  if not value11 or not value11:IsA("BasePart") then
    return
  end

  if v14[value11] == nil then
    v14[value11] = value11.CanTouch
  end

  pcall(function() value11.CanTouch = false end)
end

local function disableTrapObject(value12)
  if not value12 or not value12.Parent then
    return
  end

  if value12:IsA("BasePart") then
    disablePartTouch(value12)
  end

  for index8, value13 in ipairs(value12:GetDescendants()) do
    if value13:IsA("BasePart") then
      disablePartTouch(value13)
    end
  end

  makeObjectInvisible(value12)
end

for index9, value14 in ipairs(collectionService:GetTagged("PlacedTrap")) do
  disableTrapObject(value14)
end

collectionService:GetInstanceAddedSignal("PlacedTrap"):Connect(function(p6)
  task.defer(function() disableTrapObject(p6) end)
end)

local function raycastGroundY(position)
  local raycastParams = RaycastParams.new()
  raycastParams.FilterType = Enum.RaycastFilterType.Exclude

  local v19 = { platInvisible }

  if localPlayer.Character then
    table.insert(v19, localPlayer.Character)
  end

  raycastParams.FilterDescendantsInstances = v19
  local raycast = workspaceService:Raycast(position, Vector3.new(0, -2000, 0), raycastParams)
  return raycast and raycast.Position.Y or position.Y
end

local function getRootAndCharacter()
  local character2 = localPlayer.Character

  if not character2 then
    return nil, nil
  end

  return character2:FindFirstChild("HumanoidRootPart"), character2
end

local pisoInvisible

local function makePart(x, z, p7)
  if pisoInvisible then
    pisoInvisible:Destroy()
  end

  pisoInvisible = Instance.new("Part")
  pisoInvisible.Name = "PisoInvisible"
  pisoInvisible.Anchored = true
  pisoInvisible.CanCollide = true
  pisoInvisible.CanQuery = false
  pisoInvisible.CanTouch = false
  pisoInvisible.Material = Enum.Material.SmoothPlastic
  pisoInvisible.Transparency = 1
  pisoInvisible.Size = vector
  pisoInvisible.CFrame = CFrame.new(x, p7, z)
  pisoInvisible.Parent = platInvisible
end

local v20, connect2

local function startPlatformFollow()
  if connect2 then
    return
  end

  connect2 = runService.Stepped:Connect(function()
    if not v11 or not v20 then
      return
    else
      local v21 = getRootAndCharacter()

      if not v21 then
        return
      end

      if pisoInvisible and pisoInvisible.Parent then
        local z2 = pisoInvisible.Position.Z
        local x2 = pisoInvisible.Position.X
        local z3 = v21.Position.Z
        local x3 = v21.Position.X

        if (x2 - x3) * (x2 - x3) + (z2 - z3) * (z2 - z3) > 4 then
          pisoInvisible.CFrame = CFrame.new(x3, v20 - 0.5, z3)
        end
      end

      if v21.Position.Y < v20 then
        local v22 = math.max(v21.AssemblyLinearVelocity.Y, 0)

        v21.CFrame = CFrame.new(v21.Position.X, v20, v21.Position.Z) * v21.CFrame.Rotation

        v21.AssemblyLinearVelocity = Vector3.new(
          v21.AssemblyLinearVelocity.X, v22, v21.AssemblyLinearVelocity.Z
        )

        v21.AssemblyAngularVelocity = Vector3.zero
      end

      return
    end
  end)
end

local function stopPlatformFollow()
  if connect2 then
    pcall(function() connect2:Disconnect() end)
    connect2 = nil
  end
end

local v23 = false

local function liftToInvisiblePlatform()
  if v23 or not v11 then
    return
  end

  local v24
  v24, v233 = getRootAndCharacter()

  local vector2, rotation

  if not v24 then
    return
  else
    v23 = true
    v20 = raycastGroundY(v24.Position) + 40
    makePart(v24.Position.X, v24.Position.Z, v20 - 0.5)
    local position2 = v24.Position
    vector2 = Vector3.new(position2.X, v20 + 3, position2.Z)
    rotation = v24.CFrame.Rotation
    local v25 = os.clock()

    while v23 do
      local v26 = math.clamp((os.clock() - v25) / 0.2375, 0, 1)
      local lerp = position2:Lerp(vector2, v26 * v26 * (3 - 2 * v26))

      pcall(function()
        v24.CFrame = CFrame.new(lerp) * rotation
        v24.AssemblyLinearVelocity = Vector3.zero
        v24.AssemblyAngularVelocity = Vector3.zero
      end)

      if v26 >= 1 then
        break
      end

      runService.Heartbeat:Wait()
    end

    if v24 and v24.Parent then
      pcall(function()
        v24.CFrame = CFrame.new(vector2) * rotation
        v24.AssemblyLinearVelocity = Vector3.zero
        v24.AssemblyAngularVelocity = Vector3.zero
      end)
    end

    startPlatformFollow()
    v23 = false
    return
  end
end

local function onToolEquippedLift()
  if not v11 then
    return
  end

  task.wait(0.1)
  liftToInvisiblePlatform()
end

local function watchCharacterTools(character3)
  if not character3 then
    return
  end

  character3.ChildAdded:Connect(function(child)
    if child:IsA("Tool") then
      task.spawn(onToolEquippedLift)
    end
  end)
end

localPlayer.CharacterAdded:Connect(watchCharacterTools)

if localPlayer.Character then
  watchCharacterTools(localPlayer.Character)
end

localPlayer.CharacterAdded:Connect(function()
  task.wait(0.5)
  v20 = nil

  if pisoInvisible then
    pisoInvisible:Destroy()
    pisoInvisible = nil
  end
end)

local function disableStayUpMode()
  v11 = false
  v20 = nil
  v23 = false
  stopPlatformFollow()

  if pisoInvisible then
    pisoInvisible:Destroy()
    pisoInvisible = nil
  end
end

local function enableStayUpMode()
  v11 = true
end

local function makeFrame(frame, p8, p9, p10, p11, zindex)
  local frame2 = Instance.new("Frame")
  frame2.Size = UDim2.new(0, p8, 0, p9)
  frame2.Position = UDim2.new(0.5, p10, 0.5, p11)
  frame2.AnchorPoint = Vector2.new(0.5, 0.5)
  frame2.BackgroundColor3 = Color3.fromRGB(60, 140, 255)
  frame2.BackgroundTransparency = 0.85
  frame2.BorderSizePixel = 0
  frame2.ZIndex = zindex
  frame2.Parent = frame

  local uiCorner = Instance.new("UICorner")
  uiCorner.CornerRadius = UDim.new(1, 0)
  uiCorner.Parent = frame2

  local uiGradient = Instance.new("UIGradient")

  uiGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 140, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 220, 255)),
  })

  uiGradient.Rotation = 45
  uiGradient.Parent = frame2

  return frame2, uiGradient
end

if playerGui:FindFirstChild("DreyvidHub") then
  playerGui.DreyvidHub:Destroy()
end

if playerGui:FindFirstChild("DreyvidIntro") then
  playerGui.DreyvidIntro:Destroy()
end

local function makeTextLabel(p12)
  local dreyvidIntro = Instance.new("ScreenGui")
  dreyvidIntro.Name = "DreyvidIntro"
  dreyvidIntro.ResetOnSpawn = false
  dreyvidIntro.IgnoreGuiInset = true
  dreyvidIntro.DisplayOrder = 999
  dreyvidIntro.Parent = playerGui

  local frame3 = Instance.new("Frame")
  frame3.Size = UDim2.new(1, 0, 1, 0)
  frame3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
  frame3.BackgroundTransparency = 1
  frame3.BorderSizePixel = 0
  frame3.ZIndex = 150
  frame3.Parent = dreyvidIntro

  tweenService:Create(frame3, TweenInfo.new(0.4), { BackgroundTransparency = 0.4 }):Play()

  local frame4 = Instance.new("Frame")
  frame4.Size = UDim2.new(0, 500, 0, 150)
  frame4.Position = UDim2.new(0.5, -250, 0.5, -75)
  frame4.BackgroundTransparency = 1
  frame4.ZIndex = 200
  frame4.Parent = dreyvidIntro

  local v27 = makeFrame(frame4, 400, 130, 0, 0, 198)
  v27.BackgroundTransparency = 1

  local v28 = makeFrame(frame4, 300, 90, 0, 0, 199)
  v28.BackgroundTransparency = 1

  local textLabel = Instance.new("TextLabel")
  textLabel.Size = UDim2.new(1, 0, 0, 80)
  textLabel.Position = UDim2.new(0, 0, 0.5, -40)
  textLabel.BackgroundTransparency = 1
  textLabel.Text = "Dreyvid Hub"
  textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
  textLabel.Font = Enum.Font.GothamBold
  textLabel.TextSize = 56
  textLabel.TextStrokeTransparency = 0.3
  textLabel.TextStrokeColor3 = Color3.fromRGB(60, 140, 255)
  textLabel.TextTransparency = 1
  textLabel.ZIndex = 210
  textLabel.Parent = frame4

  local textLabel2 = Instance.new("TextLabel")
  textLabel2.Size = UDim2.new(1, 0, 0, 20)
  textLabel2.Position = UDim2.new(0, 0, 0.5, 38)
  textLabel2.BackgroundTransparency = 1
  textLabel2.Text = "PREMIUM HUB · v2.1"
  textLabel2.TextColor3 = Color3.fromRGB(120, 180, 255)
  textLabel2.Font = Enum.Font.GothamBold
  textLabel2.TextSize = 14
  textLabel2.TextTransparency = 1
  textLabel2.ZIndex = 210
  textLabel2.Parent = frame4

  task.spawn(function()
    tweenService:Create(
      v27, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
      { BackgroundTransparency = 0.75 }
    ):Play()

    tweenService:Create(v28, TweenInfo.new(
      0.9, Enum.EasingStyle.Quint, Enum.EasingDirection.Out
    ), { BackgroundTransparency = 0.82 }):Play()

    textLabel.TextTransparency = 0
    textLabel.Size = UDim2.new(0.5, 0, 0.5, 40)

    tweenService:Create(textLabel, TweenInfo.new(
      0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out
    ), {
      Size = UDim2.new(1, 0, 0, 80),
      Position = UDim2.new(0, 0, 0.5, -40),
    }):Play()

    task.wait(0.3)
    textLabel2.TextTransparency = 0
  end)

  task.spawn(function()
    task.wait(2.8)

    if not dreyvidIntro.Parent then
      return
    end

    tweenService:Create(textLabel, TweenInfo.new(0.6, Enum.EasingStyle.Quart), {
      TextTransparency = 1,
      TextSize = 80,
    }):Play()

    tweenService:Create(textLabel2, TweenInfo.new(0.6), { TextTransparency = 1 }):Play()
    tweenService:Create(v27, TweenInfo.new(0.6), { BackgroundTransparency = 1 }):Play()
    tweenService:Create(v28, TweenInfo.new(0.6), { BackgroundTransparency = 1 }):Play()
    tweenService:Create(frame3, TweenInfo.new(0.6), { BackgroundTransparency = 1 }):Play()

    task.wait(0.7)
    dreyvidIntro:Destroy()

    if p12 then
      p12()
    end
  end)
end

local connect3

local buildMainHubUI

function buildMainHubUI()
  local dreyvidHub, v29, frame5, frame7, frame8, uiStroke, uiStroke2, frame9, textButton,
    textButton2, uiStroke5, uiScale, frame10, frame11, uiStroke6, uiGradient4, frame12,
    textButton3, uiStroke7, uiScale2, frame13, frame14, textButton4, btn, stroke, btn2, stroke2,
    btn3, stroke3, btn4, stroke4, frame18, frame19, frame20, textButton6, uiStroke13, frame22,
    frame23, frame24, frame25, uiScale3, frame28, uiScale4, frame31, frame32, frame33, frame34,
    textButton8, frame36, frame38, textLabel30, frame41, textLabel31, frame44, textButton9

  if playerGui:FindFirstChild("DreyvidHub") then
    playerGui.DreyvidHub:Destroy()
  end

  dreyvidHub = Instance.new("ScreenGui")
  dreyvidHub.Name = "DreyvidHub"
  dreyvidHub.ResetOnSpawn = false
  dreyvidHub.Parent = playerGui

  v29 = loadUiScale()

  frame5 = Instance.new("Frame")
  frame5.Size = UDim2.new(0, 145, 0, 26)
  frame5.Position = UDim2.new(0.5, -72, 0, 4)
  frame5.BackgroundTransparency = 1
  frame5.ZIndex = 5
  frame5.Parent = dreyvidHub

  do
    local frame6 = Instance.new("Frame")
    frame6.Size = UDim2.new(1, 20, 1, 10)
    frame6.Position = UDim2.new(0.5, -10, 0.5, -5)
    frame6.BackgroundColor3 = Color3.fromRGB(60, 140, 255)
    frame6.BackgroundTransparency = 0.85
    frame6.BorderSizePixel = 0
    frame6.ZIndex = 4
    frame6.Parent = frame5

    local uiCorner2 = Instance.new("UICorner")
    uiCorner2.CornerRadius = UDim.new(1, 0)
    uiCorner2.Parent = frame6

    local textLabel3 = Instance.new("TextLabel")
    textLabel3.Size = UDim2.new(1, 0, 1, 0)
    textLabel3.BackgroundTransparency = 1
    textLabel3.Text = "Dreyvid Hub"
    textLabel3.TextColor3 = Color3.fromRGB(240, 244, 255)
    textLabel3.Font = Enum.Font.GothamBold
    textLabel3.TextSize = 18
    textLabel3.TextStrokeTransparency = 0.5
    textLabel3.TextStrokeColor3 = Color3.fromRGB(60, 140, 255)
    textLabel3.ZIndex = 5
    textLabel3.Parent = frame5
  end

  do
    frame7 = Instance.new("Frame")
    frame7.Size = UDim2.fromOffset(280, 125)
    frame7.Position = UDim2.new(0, 5, 0, 37)
    frame7.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame7.BackgroundTransparency = 0.5
    frame7.BorderSizePixel = 0
    frame7.ZIndex = 1
    frame7.Parent = dreyvidHub

    local uiCorner3 = Instance.new("UICorner")
    uiCorner3.CornerRadius = UDim.new(0, 16)
    uiCorner3.Parent = frame7

    frame8 = Instance.new("Frame")
  end

  do
    frame8.Size = UDim2.fromOffset(270, 115)
    frame8.Position = UDim2.new(0, 10, 0, 42)
    frame8.BackgroundColor3 = Color3.fromRGB(15, 17, 23)
    frame8.BorderSizePixel = 0
    frame8.ClipsDescendants = true
    frame8.Active = true
    frame8.Draggable = true
    frame8.ZIndex = 2
    frame8.Parent = dreyvidHub

    local uiCorner4 = Instance.new("UICorner")
    uiCorner4.CornerRadius = UDim.new(0, 14)
    uiCorner4.Parent = frame8
  end

  do
    local uiGradient2 = Instance.new("UIGradient")

    uiGradient2.Color = ColorSequence.new(
      Color3.fromRGB(24, 28, 40), Color3.fromRGB(12, 14, 20)
    )

    uiGradient2.Rotation = 135
    uiGradient2.Parent = frame8

    uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(90, 120, 160)
    uiStroke.Thickness = 1.2
    uiStroke.Transparency = 0.4
    uiStroke.Parent = frame8

    frame8:GetPropertyChangedSignal("Position"):Connect(function()
      frame7.Position = UDim2.new(
        frame8.Position.X.Scale, frame8.Position.X.Offset - 5, frame8.Position.Y.Scale,
        frame8.Position.Y.Offset - 5
      )
    end)

    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Size = UDim2.fromOffset(42, 42)
    imageLabel.Position = UDim2.new(0, 14, 0, 12)
    imageLabel.BackgroundTransparency = 1
    imageLabel.Image = getUserThumbnailAsync
    imageLabel.ScaleType = Enum.ScaleType.Crop
    imageLabel.ZIndex = 3
    imageLabel.Parent = frame8

    local uiCorner5 = Instance.new("UICorner")
    uiCorner5.CornerRadius = UDim.new(1, 0)
    uiCorner5.Parent = imageLabel

    uiStroke2 = Instance.new("UIStroke")
    uiStroke2.Color = Color3.fromRGB(120, 180, 255)
    uiStroke2.Thickness = 1.5
    uiStroke2.Transparency = 0.2
    uiStroke2.Parent = imageLabel
  end

  do
    local textLabel4 = Instance.new("TextLabel")
    textLabel4.Size = UDim2.new(1, -110, 0, 20)
    textLabel4.Position = UDim2.new(0, 64, 0, 14)
    textLabel4.BackgroundTransparency = 1
    textLabel4.Text = "Drey"
    textLabel4.TextColor3 = Color3.fromRGB(240, 244, 255)
    textLabel4.Font = Enum.Font.GothamBold
    textLabel4.TextSize = 17
    textLabel4.TextXAlignment = Enum.TextXAlignment.Left
    textLabel4.ZIndex = 3
    textLabel4.Parent = frame8

    local textLabel5 = Instance.new("TextLabel")
    textLabel5.Size = UDim2.new(1, -110, 0, 14)
    textLabel5.Position = UDim2.new(0, 64, 0, 36)
    textLabel5.BackgroundTransparency = 1
    textLabel5.Text = "ANTI-HIT"
    textLabel5.TextColor3 = Color3.fromRGB(140, 150, 170)
    textLabel5.Font = Enum.Font.GothamMedium
    textLabel5.TextSize = 10
    textLabel5.TextXAlignment = Enum.TextXAlignment.Left
    textLabel5.ZIndex = 3
    textLabel5.Parent = frame8
  end

  do
    frame9 = Instance.new("Frame")
    frame9.Size = UDim2.fromOffset(6, 6)
    frame9.Position = UDim2.new(0, 118, 0, 39)
    frame9.BackgroundColor3 = Color3.fromRGB(230, 70, 80)
    frame9.BorderSizePixel = 0
    frame9.ZIndex = 3
    frame9.Parent = frame8

    local uiCorner6 = Instance.new("UICorner")
    uiCorner6.CornerRadius = UDim.new(1, 0)
    uiCorner6.Parent = frame9

    textButton = Instance.new("TextButton")
    textButton.Size = UDim2.fromOffset(28, 28)
  end

  do
    textButton.Position = UDim2.new(1, -72, 0, 10)
    textButton.BackgroundColor3 = Color3.fromRGB(30, 35, 48)
    textButton.Text = "⚙"
    textButton.TextColor3 = Color3.fromRGB(120, 180, 255)
    textButton.Font = Enum.Font.GothamBold
    textButton.TextSize = 16
    textButton.AutoButtonColor = false
    textButton.ZIndex = 3
    textButton.Parent = frame8

    local uiCorner7 = Instance.new("UICorner")
    uiCorner7.CornerRadius = UDim.new(0, 8)
    uiCorner7.Parent = textButton
  end

  do
    local uiStroke3 = Instance.new("UIStroke")
    uiStroke3.Color = Color3.fromRGB(70, 90, 130)
    uiStroke3.Thickness = 1
    uiStroke3.Transparency = 0.6
    uiStroke3.Parent = textButton

    local imageButton = Instance.new("ImageButton")
    imageButton.Size = UDim2.fromOffset(28, 28)
    imageButton.Position = UDim2.new(1, -40, 0, 10)
    imageButton.BackgroundColor3 = Color3.fromRGB(30, 35, 48)
    imageButton.Image = "rbxassetid://93628638506572"
    imageButton.ImageColor3 = Color3.fromRGB(120, 180, 255)
    imageButton.ScaleType = Enum.ScaleType.Fit
    imageButton.ZIndex = 3
    imageButton.Parent = frame8

    local uiCorner8 = Instance.new("UICorner")
    uiCorner8.CornerRadius = UDim.new(0, 8)
    uiCorner8.Parent = imageButton

    local uiStroke4 = Instance.new("UIStroke")
    uiStroke4.Color = Color3.fromRGB(70, 90, 130)
    uiStroke4.Thickness = 1
    uiStroke4.Transparency = 0.6
    uiStroke4.Parent = imageButton

    imageButton.MouseButton1Click:Connect(function() copyToClipboard("https://discord.gg/MbQWs6SAgK") end)
  end

  do
    textButton2 = Instance.new("TextButton")
    textButton2.Size = UDim2.new(1, -28, 0, 34)
    textButton2.Position = UDim2.new(0, 14, 1, -48)
    textButton2.BackgroundColor3 = Color3.fromRGB(40, 25, 30)
    textButton2.Text = "OFF"
    textButton2.TextColor3 = Color3.fromRGB(230, 120, 120)
    textButton2.Font = Enum.Font.GothamBold
    textButton2.TextSize = 14
    textButton2.AutoButtonColor = false
    textButton2.ZIndex = 3
    textButton2.Parent = frame8

    local uiCorner9 = Instance.new("UICorner")
    uiCorner9.CornerRadius = UDim.new(0, 8)
    uiCorner9.Parent = textButton2
  end

  uiStroke5 = Instance.new("UIStroke")
  uiStroke5.Color = Color3.fromRGB(120, 50, 60)
  uiStroke5.Thickness = 1
  uiStroke5.Transparency = 0.4
  uiStroke5.Parent = textButton2

  task.spawn(function()
    while dreyvidHub.Parent do
      tweenService:Create(uiStroke, TweenInfo.new(
        1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut
      ), {
        Color = Color3.fromRGB(120, 180, 255),
        Transparency = 0.1,
        Thickness = 1.8,
      }):Play()

      task.wait(1.8)

      tweenService:Create(uiStroke, TweenInfo.new(
        1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut
      ), {
        Color = Color3.fromRGB(90, 120, 160),
        Transparency = 0.4,
        Thickness = 1.2,
      }):Play()

      task.wait(1.8)
    end
  end)

  task.spawn(function()
    while dreyvidHub.Parent do
      tweenService:Create(uiStroke2, TweenInfo.new(
        1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut
      ), {
        Transparency = 0,
        Thickness = 2,
        Color = Color3.fromRGB(180, 120, 255),
      }):Play()

      task.wait(1.5)

      tweenService:Create(uiStroke2, TweenInfo.new(
        1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut
      ), {
        Transparency = 0.2,
        Thickness = 1.5,
        Color = Color3.fromRGB(120, 180, 255),
      }):Play()

      task.wait(1.5)
    end
  end)

  task.spawn(function()
    while dreyvidHub.Parent do
      tweenService:Create(frame9, TweenInfo.new(
        0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut
      ), {
        Size = UDim2.fromOffset(8, 8),
        Position = UDim2.new(0, 117, 0, 38),
      }):Play()

      task.wait(0.6)

      tweenService:Create(frame9, TweenInfo.new(
        0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut
      ), {
        Size = UDim2.fromOffset(6, 6),
        Position = UDim2.new(0, 118, 0, 39),
      }):Play()

      task.wait(0.6)
    end
  end)

  uiScale = Instance.new("UIScale")
  uiScale.Scale = v29
  uiScale.Parent = frame8

  frame10 = Instance.new("Frame")

  do
    frame10.Size = UDim2.fromOffset(250, 105)
    frame10.Position = UDim2.new(0, 5, 0, 167)
    frame10.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame10.BackgroundTransparency = 0.5
    frame10.BorderSizePixel = 0
    frame10.ZIndex = 1
    frame10.Visible = false
    frame10.Parent = dreyvidHub

    local uiCorner10 = Instance.new("UICorner")
    uiCorner10.CornerRadius = UDim.new(0, 16)
    uiCorner10.Parent = frame10

    frame11 = Instance.new("Frame")
  end

  do
    frame11.Size = UDim2.fromOffset(240, 95)
    frame11.Position = UDim2.new(0, 10, 0, 172)
    frame11.BackgroundColor3 = Color3.fromRGB(15, 17, 23)
    frame11.BorderSizePixel = 0
    frame11.ClipsDescendants = true
    frame11.Active = true
    frame11.Draggable = true
    frame11.ZIndex = 2
    frame11.Visible = false
    frame11.Parent = dreyvidHub

    local uiCorner11 = Instance.new("UICorner")
    uiCorner11.CornerRadius = UDim.new(0, 14)
    uiCorner11.Parent = frame11
  end

  do
    local uiGradient3 = Instance.new("UIGradient")

    uiGradient3.Color = ColorSequence.new(
      Color3.fromRGB(24, 28, 40), Color3.fromRGB(12, 14, 20)
    )

    uiGradient3.Rotation = 135
    uiGradient3.Parent = frame11

    uiStroke6 = Instance.new("UIStroke")
    uiStroke6.Color = Color3.fromRGB(90, 120, 160)
    uiStroke6.Thickness = 1.2
    uiStroke6.Transparency = 0.4
    uiStroke6.Parent = frame11

    frame11:GetPropertyChangedSignal("Position"):Connect(function()
      frame10.Position = UDim2.new(
        frame11.Position.X.Scale, frame11.Position.X.Offset - 5, frame11.Position.Y.Scale,
        frame11.Position.Y.Offset - 5
      )
    end)

    local textLabel6 = Instance.new("TextLabel")
    textLabel6.Size = UDim2.new(1, -28, 0, 24)
    textLabel6.Position = UDim2.new(0, 14, 0, 12)
    textLabel6.BackgroundTransparency = 1
    textLabel6.Text = "Hold the egg longer"
    textLabel6.TextColor3 = Color3.fromRGB(240, 244, 255)
    textLabel6.Font = Enum.Font.GothamBold
    textLabel6.TextSize = 15
    textLabel6.TextXAlignment = Enum.TextXAlignment.Left
    textLabel6.ZIndex = 3
    textLabel6.Parent = frame11

    uiGradient4 = Instance.new("UIGradient")

    uiGradient4.Color = ColorSequence.new({
      ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
      ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 200, 255)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 140, 255)),
    })

    uiGradient4.Rotation = 0
    uiGradient4.Parent = textLabel6
  end

  do
    local textLabel7 = Instance.new("TextLabel")
    textLabel7.Size = UDim2.new(1, -28, 0, 14)
    textLabel7.Position = UDim2.new(0, 14, 0, 36)
    textLabel7.BackgroundTransparency = 1
    textLabel7.Text = "Stays up automatically"
    textLabel7.TextColor3 = Color3.fromRGB(140, 150, 170)
    textLabel7.Font = Enum.Font.GothamMedium
    textLabel7.TextSize = 10
    textLabel7.TextXAlignment = Enum.TextXAlignment.Left
    textLabel7.ZIndex = 3
    textLabel7.Parent = frame11

    frame12 = Instance.new("Frame")
  end

  do
    frame12.Size = UDim2.fromOffset(6, 6)
    frame12.Position = UDim2.new(1, -28, 0, 18)
    frame12.BackgroundColor3 = Color3.fromRGB(230, 70, 80)
    frame12.BorderSizePixel = 0
    frame12.ZIndex = 3
    frame12.Parent = frame11

    local uiCorner12 = Instance.new("UICorner")
    uiCorner12.CornerRadius = UDim.new(1, 0)
    uiCorner12.Parent = frame12

    textButton3 = Instance.new("TextButton")
    textButton3.Size = UDim2.new(1, -28, 0, 28)
    textButton3.Position = UDim2.new(0, 14, 1, -38)
  end

  do
    textButton3.BackgroundColor3 = Color3.fromRGB(40, 25, 30)
    textButton3.Text = "OFF"
    textButton3.TextColor3 = Color3.fromRGB(230, 120, 120)
    textButton3.Font = Enum.Font.GothamBold
    textButton3.TextSize = 12
    textButton3.AutoButtonColor = false
    textButton3.ZIndex = 3
    textButton3.Parent = frame11

    local uiCorner13 = Instance.new("UICorner")
    uiCorner13.CornerRadius = UDim.new(0, 8)
    uiCorner13.Parent = textButton3

    uiStroke7 = Instance.new("UIStroke")
  end

  uiStroke7.Color = Color3.fromRGB(120, 50, 60)
  uiStroke7.Thickness = 1
  uiStroke7.Transparency = 0.4
  uiStroke7.Parent = textButton3

  task.spawn(function()
    while dreyvidHub.Parent do
      tweenService:Create(uiStroke6, TweenInfo.new(
        1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut
      ), {
        Color = Color3.fromRGB(120, 180, 255),
        Transparency = 0.1,
        Thickness = 1.8,
      }):Play()

      task.wait(1.8)

      tweenService:Create(uiStroke6, TweenInfo.new(
        1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut
      ), {
        Color = Color3.fromRGB(90, 120, 160),
        Transparency = 0.4,
        Thickness = 1.2,
      }):Play()

      task.wait(1.8)
    end
  end)

  task.spawn(function()
    local v30 = 0

    while dreyvidHub.Parent do
      v30 = v30 + 1

      tweenService:Create(uiGradient4, TweenInfo.new(2, Enum.EasingStyle.Linear), {
        Rotation = v30 * 45,
      }):Play()

      task.wait(2)

      if v30 > 8 then
        v30 = 0
      end
    end
  end)

  uiScale2 = Instance.new("UIScale")
  uiScale2.Scale = v29
  uiScale2.Parent = frame11

  frame13 = Instance.new("Frame")
  frame13.Size = UDim2.fromOffset(360, 460)
  frame13.Position = UDim2.new(0.5, -180, 0.5, -230)

  do
    frame13.BackgroundColor3 = Color3.fromRGB(13, 15, 21)
    frame13.BorderSizePixel = 0
    frame13.Visible = false
    frame13.ZIndex = 100
    frame13.Parent = dreyvidHub

    local uiCorner14 = Instance.new("UICorner")
    uiCorner14.CornerRadius = UDim.new(0, 18)
    uiCorner14.Parent = frame13

    local uiGradient5 = Instance.new("UIGradient")

    uiGradient5.Color = ColorSequence.new({
      ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 32, 46)),
      ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 17, 24)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 24, 34)),
    })

    uiGradient5.Rotation = 135
    uiGradient5.Parent = frame13
  end

  do
    local uiStroke8 = Instance.new("UIStroke")
    uiStroke8.Color = Color3.fromRGB(60, 140, 255)
    uiStroke8.Thickness = 1.5
    uiStroke8.Transparency = 0.15
    uiStroke8.Parent = frame13

    local uiGradient6 = Instance.new("UIGradient")

    uiGradient6.Color = ColorSequence.new({
      ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 140, 255)),
      ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 100, 255)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 220, 255)),
    })

    uiGradient6.Parent = uiStroke8

    frame14 = Instance.new("Frame")
    frame14.Size = UDim2.new(1, 0, 0, 54)
    frame14.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    frame14.BackgroundTransparency = 0.3
  end

  do
    frame14.BorderSizePixel = 0
    frame14.ZIndex = 101
    frame14.Parent = frame13

    local uiCorner15 = Instance.new("UICorner")
    uiCorner15.CornerRadius = UDim.new(0, 18)
    uiCorner15.Parent = frame14

    local frame15 = Instance.new("Frame")
    frame15.Size = UDim2.new(1, 0, 0, 20)
    frame15.Position = UDim2.new(0, 0, 1, -20)
    frame15.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    frame15.BackgroundTransparency = 0.3
    frame15.BorderSizePixel = 0
    frame15.ZIndex = 101
    frame15.Parent = frame14
  end

  do
    local frame16 = Instance.new("Frame")
    frame16.Size = UDim2.fromOffset(34, 34)
    frame16.Position = UDim2.new(0, 14, 0.5, -17)
    frame16.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
    frame16.BorderSizePixel = 0
    frame16.ZIndex = 102
    frame16.Parent = frame14

    local uiCorner16 = Instance.new("UICorner")
    uiCorner16.CornerRadius = UDim.new(0, 9)
    uiCorner16.Parent = frame16

    local textLabel8 = Instance.new("TextLabel")
    textLabel8.Size = UDim2.fromScale(1, 1)
    textLabel8.BackgroundTransparency = 1
    textLabel8.Text = "⚙"
    textLabel8.TextColor3 = Color3.fromRGB(120, 180, 255)
    textLabel8.Font = Enum.Font.GothamBold
    textLabel8.TextSize = 18
    textLabel8.ZIndex = 103
    textLabel8.Parent = frame16
  end

  do
    local textLabel9 = Instance.new("TextLabel")
    textLabel9.Size = UDim2.new(1, -120, 0, 20)
    textLabel9.Position = UDim2.new(0, 58, 0, 10)
    textLabel9.BackgroundTransparency = 1
    textLabel9.Text = "Settings"
    textLabel9.TextColor3 = Color3.fromRGB(240, 244, 255)
    textLabel9.Font = Enum.Font.GothamBold
    textLabel9.TextSize = 16
    textLabel9.TextXAlignment = Enum.TextXAlignment.Left
    textLabel9.ZIndex = 102
    textLabel9.Parent = frame14

    local textLabel10 = Instance.new("TextLabel")
    textLabel10.Size = UDim2.new(1, -120, 0, 14)
    textLabel10.Position = UDim2.new(0, 58, 0, 30)
    textLabel10.BackgroundTransparency = 1
    textLabel10.Text = "DREYVID · v2.1"
    textLabel10.TextColor3 = Color3.fromRGB(110, 120, 150)
    textLabel10.Font = Enum.Font.GothamMedium
    textLabel10.TextSize = 9
    textLabel10.TextXAlignment = Enum.TextXAlignment.Left
    textLabel10.ZIndex = 102
    textLabel10.Parent = frame14
  end

  do
    textButton4 = Instance.new("TextButton")
    textButton4.Size = UDim2.fromOffset(30, 30)
    textButton4.Position = UDim2.new(1, -42, 0, 12)
    textButton4.BackgroundColor3 = Color3.fromRGB(60, 25, 30)
    textButton4.Text = "×"
    textButton4.TextColor3 = Color3.fromRGB(255, 140, 140)
    textButton4.Font = Enum.Font.GothamBold
    textButton4.TextSize = 20
    textButton4.AutoButtonColor = false
    textButton4.ZIndex = 102
    textButton4.Parent = frame14

    local uiCorner17 = Instance.new("UICorner")
    uiCorner17.CornerRadius = UDim.new(0, 8)
    uiCorner17.Parent = textButton4
  end

  do
    local uiStroke9 = Instance.new("UIStroke")
    uiStroke9.Color = Color3.fromRGB(120, 50, 60)
    uiStroke9.Thickness = 1
    uiStroke9.Transparency = 0.4
    uiStroke9.Parent = textButton4

    local frame17 = Instance.new("Frame")
    frame17.Size = UDim2.new(1, -24, 0, 38)
    frame17.Position = UDim2.new(0, 12, 0, 66)
    frame17.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    frame17.BackgroundTransparency = 0.5
    frame17.BorderSizePixel = 0
    frame17.ZIndex = 101
    frame17.Parent = frame13

    local uiCorner18 = Instance.new("UICorner")
    uiCorner18.CornerRadius = UDim.new(0, 10)
    uiCorner18.Parent = frame17

    local uiPadding = Instance.new("UIPadding")
    uiPadding.PaddingLeft = UDim.new(0, 4)
    uiPadding.PaddingRight = UDim.new(0, 4)
    uiPadding.PaddingTop = UDim.new(0, 4)
    uiPadding.PaddingBottom = UDim.new(0, 4)
    uiPadding.Parent = frame17

    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.FillDirection = Enum.FillDirection.Horizontal
    uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uiListLayout.Padding = UDim.new(0, 4)
    uiListLayout.Parent = frame17

    local function makeTextButton(text, layoutOrder)
      local textButton5 = Instance.new("TextButton")
      textButton5.Size = UDim2.new(0.25, -3, 1, 0)
      textButton5.BackgroundColor3 = Color3.fromRGB(30, 35, 48)
      textButton5.BackgroundTransparency = 0.5
      textButton5.Text = text
      textButton5.TextColor3 = Color3.fromRGB(180, 180, 200)
      textButton5.Font = Enum.Font.GothamBold
      textButton5.TextSize = 12
      textButton5.AutoButtonColor = false
      textButton5.ZIndex = 102
      textButton5.LayoutOrder = layoutOrder
      textButton5.Parent = frame17

      local uiCorner19 = Instance.new("UICorner")
      uiCorner19.CornerRadius = UDim.new(0, 8)
      uiCorner19.Parent = textButton5

      local uiStroke10 = Instance.new("UIStroke")
      uiStroke10.Color = Color3.fromRGB(70, 90, 130)
      uiStroke10.Thickness = 1
      uiStroke10.Transparency = 0.6
      uiStroke10.Parent = textButton5

      return textButton5, uiStroke10
    end

    btn, stroke = makeTextButton("Features", 1)
    btn2, stroke2 = makeTextButton("Size", 2)
    btn3, stroke3 = makeTextButton("Support", 3)
    btn4, stroke4 = makeTextButton("Info", 4)
  end

  frame18 = Instance.new("Frame")
  frame18.Size = UDim2.new(1, -24, 1, -124)
  frame18.Position = UDim2.new(0, 12, 0, 114)
  frame18.BackgroundTransparency = 1
  frame18.ZIndex = 101
  frame18.Parent = frame13

  frame19 = Instance.new("Frame")
  frame19.Size = UDim2.new(1, 0, 1, 0)
  frame19.BackgroundTransparency = 1
  frame19.Visible = true
  frame19.ZIndex = 102
  frame19.Parent = frame18

  do
    local textLabel11 = Instance.new("TextLabel")
    textLabel11.Size = UDim2.new(1, 0, 0, 16)
    textLabel11.Position = UDim2.new(0, 0, 0, 0)
    textLabel11.BackgroundTransparency = 1
    textLabel11.Text = "AVAILABLE FEATURES"
    textLabel11.TextColor3 = Color3.fromRGB(120, 180, 255)
    textLabel11.Font = Enum.Font.GothamBold
    textLabel11.TextSize = 10
    textLabel11.TextXAlignment = Enum.TextXAlignment.Left
    textLabel11.ZIndex = 103
    textLabel11.Parent = frame19

    frame20 = Instance.new("Frame")
  end

  do
    frame20.Size = UDim2.new(1, 0, 0, 78)
    frame20.Position = UDim2.new(0, 0, 0, 26)
    frame20.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
    frame20.BackgroundTransparency = 0.2
    frame20.BorderSizePixel = 0
    frame20.ZIndex = 102
    frame20.Parent = frame19

    local uiCorner20 = Instance.new("UICorner")
    uiCorner20.CornerRadius = UDim.new(0, 12)
    uiCorner20.Parent = frame20

    local uiStroke11 = Instance.new("UIStroke")
    uiStroke11.Color = Color3.fromRGB(70, 90, 130)
    uiStroke11.Thickness = 1
    uiStroke11.Transparency = 0.4
    uiStroke11.Parent = frame20
  end

  do
    local frame21 = Instance.new("Frame")
    frame21.Size = UDim2.fromOffset(50, 50)
    frame21.Position = UDim2.new(0, 14, 0.5, -25)
    frame21.BackgroundColor3 = Color3.fromRGB(28, 34, 48)
    frame21.BorderSizePixel = 0
    frame21.ZIndex = 103
    frame21.Parent = frame20

    local uiCorner21 = Instance.new("UICorner")
    uiCorner21.CornerRadius = UDim.new(0, 10)
    uiCorner21.Parent = frame21

    local uiStroke12 = Instance.new("UIStroke")
    uiStroke12.Color = Color3.fromRGB(120, 180, 255)
    uiStroke12.Thickness = 1
    uiStroke12.Transparency = 0.4
    uiStroke12.Parent = frame21

    local textLabel12 = Instance.new("TextLabel")
    textLabel12.Size = UDim2.fromScale(1, 1)
    textLabel12.BackgroundTransparency = 1
    textLabel12.Text = "↑"
    textLabel12.TextColor3 = Color3.fromRGB(120, 200, 255)
    textLabel12.Font = Enum.Font.GothamBlack
    textLabel12.TextSize = 28
    textLabel12.ZIndex = 104
    textLabel12.Parent = frame21
  end

  do
    local textLabel13 = Instance.new("TextLabel")
    textLabel13.Size = UDim2.new(1, -110, 0, 18)
    textLabel13.Position = UDim2.new(0, 76, 0, 16)
    textLabel13.BackgroundTransparency = 1
    textLabel13.Text = "Hold the egg longer"
    textLabel13.TextColor3 = Color3.fromRGB(240, 244, 255)
    textLabel13.Font = Enum.Font.GothamBold
    textLabel13.TextSize = 13
    textLabel13.TextXAlignment = Enum.TextXAlignment.Left
    textLabel13.ZIndex = 103
    textLabel13.Parent = frame20

    local textLabel14 = Instance.new("TextLabel")
    textLabel14.Size = UDim2.new(1, -110, 0, 14)
    textLabel14.Position = UDim2.new(0, 76, 0, 36)
    textLabel14.BackgroundTransparency = 1
    textLabel14.Text = "Goes up and stays up"
    textLabel14.TextColor3 = Color3.fromRGB(140, 150, 170)
    textLabel14.Font = Enum.Font.GothamMedium
    textLabel14.TextSize = 10
    textLabel14.TextXAlignment = Enum.TextXAlignment.Left
    textLabel14.ZIndex = 103
    textLabel14.Parent = frame20
  end

  do
    textButton6 = Instance.new("TextButton")
    textButton6.Size = UDim2.fromOffset(60, 26)
    textButton6.Position = UDim2.new(1, -75, 0.5, -13)
    textButton6.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    textButton6.BorderSizePixel = 0
    textButton6.Text = ""
    textButton6.AutoButtonColor = false
    textButton6.ZIndex = 103
    textButton6.Parent = frame20

-- https://discord.gg/AwGHNh7Z7T
    local uiCorner22 = Instance.new("UICorner")
    uiCorner22.CornerRadius = UDim.new(1, 0)
    uiCorner22.Parent = textButton6
  end

  uiStroke13 = Instance.new("UIStroke")
  uiStroke13.Color = Color3.fromRGB(90, 90, 110)
  uiStroke13.Thickness = 1
  uiStroke13.Transparency = 0.3
  uiStroke13.Parent = textButton6

  frame22 = Instance.new("Frame")
  frame22.Size = UDim2.fromOffset(20, 20)
  frame22.Position = UDim2.new(0, 3, 0.5, -10)
  frame22.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
  frame22.BorderSizePixel = 0
  frame22.ZIndex = 104
  frame22.Parent = textButton6

  do
    local uiCorner23 = Instance.new("UICorner")
    uiCorner23.CornerRadius = UDim.new(1, 0)
    uiCorner23.Parent = frame22

    frame23 = Instance.new("Frame")
    frame23.Size = UDim2.new(1, 0, 1, 0)
    frame23.BackgroundTransparency = 1
    frame23.Visible = false
    frame23.ZIndex = 102
    frame23.Parent = frame18

    local textLabel15 = Instance.new("TextLabel")
    textLabel15.Size = UDim2.new(1, 0, 0, 16)
    textLabel15.Position = UDim2.new(0, 0, 0, 0)
    textLabel15.BackgroundTransparency = 1
    textLabel15.Text = "SIZE PER PANEL"
    textLabel15.TextColor3 = Color3.fromRGB(120, 180, 255)
    textLabel15.Font = Enum.Font.GothamBold
    textLabel15.TextSize = 10
    textLabel15.TextXAlignment = Enum.TextXAlignment.Left
    textLabel15.ZIndex = 103
    textLabel15.Parent = frame23
  end

  do
    local textLabel16 = Instance.new("TextLabel")
    textLabel16.Size = UDim2.new(1, 0, 0, 26)
    textLabel16.Position = UDim2.new(0, 0, 0, 20)
    textLabel16.BackgroundTransparency = 1
    textLabel16.Text = "Change each panel size without moving its position"
    textLabel16.TextColor3 = Color3.fromRGB(140, 150, 170)
    textLabel16.Font = Enum.Font.GothamMedium
    textLabel16.TextSize = 10
    textLabel16.TextWrapped = true
    textLabel16.TextXAlignment = Enum.TextXAlignment.Left
    textLabel16.TextYAlignment = Enum.TextYAlignment.Top
    textLabel16.ZIndex = 103
    textLabel16.Parent = frame23
  end

  do
    frame24 = Instance.new("Frame")
    frame24.Size = UDim2.new(1, 0, 0, 90)
    frame24.Position = UDim2.new(0, 0, 0, 52)
    frame24.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    frame24.BackgroundTransparency = 0.4
    frame24.BorderSizePixel = 0
    frame24.ZIndex = 102
    frame24.Parent = frame23

    local uiCorner24 = Instance.new("UICorner")
    uiCorner24.CornerRadius = UDim.new(0, 10)
    uiCorner24.Parent = frame24

    local textLabel17 = Instance.new("TextLabel")
    textLabel17.Size = UDim2.new(1, -20, 0, 14)
    textLabel17.Position = UDim2.new(0, 10, 0, 6)
    textLabel17.BackgroundTransparency = 1
    textLabel17.Text = "PREVIEW"
    textLabel17.TextColor3 = Color3.fromRGB(120, 130, 160)
    textLabel17.Font = Enum.Font.GothamBold
    textLabel17.TextSize = 9
    textLabel17.TextXAlignment = Enum.TextXAlignment.Left
    textLabel17.ZIndex = 103
    textLabel17.Parent = frame24
  end

  do
    frame25 = Instance.new("Frame")
    frame25.Size = UDim2.fromOffset(120, 50)
    frame25.Position = UDim2.new(0, 15, 0.5, -18)
    frame25.BackgroundColor3 = Color3.fromRGB(15, 17, 23)
    frame25.BorderSizePixel = 0
    frame25.ZIndex = 103
    frame25.Parent = frame24

    local uiCorner25 = Instance.new("UICorner")
    uiCorner25.CornerRadius = UDim.new(0, 8)
    uiCorner25.Parent = frame25

    local uiStroke14 = Instance.new("UIStroke")
    uiStroke14.Color = Color3.fromRGB(60, 140, 255)
    uiStroke14.Thickness = 1
    uiStroke14.Transparency = 0.3
    uiStroke14.Parent = frame25
  end

  do
    local frame26 = Instance.new("Frame")
    frame26.Size = UDim2.fromOffset(4, 4)
    frame26.Position = UDim2.new(0, 8, 0, 8)
    frame26.BackgroundColor3 = Color3.fromRGB(50, 220, 130)
    frame26.BorderSizePixel = 0
    frame26.ZIndex = 104
    frame26.Parent = frame25

    local uiCorner26 = Instance.new("UICorner")
    uiCorner26.CornerRadius = UDim.new(1, 0)
    uiCorner26.Parent = frame26

    local textLabel18 = Instance.new("TextLabel")
    textLabel18.Size = UDim2.new(1, -20, 0, 10)
    textLabel18.Position = UDim2.new(0, 16, 0, 5)
    textLabel18.BackgroundTransparency = 1
    textLabel18.Text = "Anti-Hit"
    textLabel18.TextColor3 = Color3.fromRGB(240, 244, 255)
    textLabel18.Font = Enum.Font.GothamBold
    textLabel18.TextSize = 8
    textLabel18.TextXAlignment = Enum.TextXAlignment.Left
    textLabel18.ZIndex = 104
    textLabel18.Parent = frame25
  end

  do
    local frame27 = Instance.new("Frame")
    frame27.Size = UDim2.new(1, -16, 0, 14)
    frame27.Position = UDim2.new(0, 8, 1, -20)
    frame27.BackgroundColor3 = Color3.fromRGB(40, 25, 30)
    frame27.BorderSizePixel = 0
    frame27.ZIndex = 104
    frame27.Parent = frame25

    local uiCorner27 = Instance.new("UICorner")
    uiCorner27.CornerRadius = UDim.new(0, 4)
    uiCorner27.Parent = frame27

    uiScale3 = Instance.new("UIScale")
    uiScale3.Scale = 1
  end

  do
    uiScale3.Parent = frame25

    frame28 = Instance.new("Frame")
    frame28.Size = UDim2.fromOffset(100, 50)
    frame28.Position = UDim2.new(1, -115, 0.5, -18)
    frame28.BackgroundColor3 = Color3.fromRGB(15, 17, 23)
    frame28.BorderSizePixel = 0
    frame28.ZIndex = 103
    frame28.Parent = frame24

    local uiCorner28 = Instance.new("UICorner")
    uiCorner28.CornerRadius = UDim.new(0, 8)
    uiCorner28.Parent = frame28

    local uiStroke15 = Instance.new("UIStroke")
    uiStroke15.Color = Color3.fromRGB(120, 180, 255)
    uiStroke15.Thickness = 1
    uiStroke15.Transparency = 0.3
    uiStroke15.Parent = frame28
  end

  do
    local frame29 = Instance.new("Frame")
    frame29.Size = UDim2.fromOffset(4, 4)
    frame29.Position = UDim2.new(0, 8, 0, 8)
    frame29.BackgroundColor3 = Color3.fromRGB(50, 220, 130)
    frame29.BorderSizePixel = 0
    frame29.ZIndex = 104
    frame29.Parent = frame28

    local uiCorner29 = Instance.new("UICorner")
    uiCorner29.CornerRadius = UDim.new(1, 0)
    uiCorner29.Parent = frame29

    local textLabel19 = Instance.new("TextLabel")
    textLabel19.Size = UDim2.new(1, -20, 0, 10)
    textLabel19.Position = UDim2.new(0, 16, 0, 5)
    textLabel19.BackgroundTransparency = 1
    textLabel19.Text = "Egg"
    textLabel19.TextColor3 = Color3.fromRGB(240, 244, 255)
    textLabel19.Font = Enum.Font.GothamBold
    textLabel19.TextSize = 8
    textLabel19.TextXAlignment = Enum.TextXAlignment.Left
    textLabel19.ZIndex = 104
    textLabel19.Parent = frame28
  end

  do
    local frame30 = Instance.new("Frame")
    frame30.Size = UDim2.new(1, -16, 0, 14)
    frame30.Position = UDim2.new(0, 8, 1, -20)
    frame30.BackgroundColor3 = Color3.fromRGB(20, 45, 35)
    frame30.BorderSizePixel = 0
    frame30.ZIndex = 104
    frame30.Parent = frame28

    local uiCorner30 = Instance.new("UICorner")
    uiCorner30.CornerRadius = UDim.new(0, 4)
    uiCorner30.Parent = frame30

    uiScale4 = Instance.new("UIScale")
    uiScale4.Scale = 1
  end

  do
    uiScale4.Parent = frame28

    local textLabel20 = Instance.new("TextLabel")
    textLabel20.Size = UDim2.new(1, 0, 0, 16)
    textLabel20.Position = UDim2.new(0, 0, 0, 152)
    textLabel20.BackgroundTransparency = 1
    textLabel20.Text = "ADJUST SIZE"
    textLabel20.TextColor3 = Color3.fromRGB(140, 150, 170)
    textLabel20.Font = Enum.Font.GothamBold
    textLabel20.TextSize = 10
    textLabel20.TextXAlignment = Enum.TextXAlignment.Left
    textLabel20.ZIndex = 103
    textLabel20.Parent = frame23
  end

  do
    frame31 = Instance.new("Frame")
    frame31.Size = UDim2.new(1, 0, 0, 8)
    frame31.Position = UDim2.new(0, 0, 0, 174)
    frame31.BackgroundColor3 = Color3.fromRGB(30, 35, 48)
    frame31.BorderSizePixel = 0
    frame31.ZIndex = 103
    frame31.Parent = frame23

    local uiCorner31 = Instance.new("UICorner")
    uiCorner31.CornerRadius = UDim.new(1, 0)
    uiCorner31.Parent = frame31

    frame32 = Instance.new("Frame")
    frame32.BackgroundColor3 = Color3.fromRGB(60, 140, 255)
  end

  do
    frame32.BorderSizePixel = 0
    frame32.ZIndex = 104
    frame32.Parent = frame31

    local uiCorner32 = Instance.new("UICorner")
    uiCorner32.CornerRadius = UDim.new(1, 0)
    uiCorner32.Parent = frame32

    frame33 = Instance.new("Frame")
    frame33.Size = UDim2.fromOffset(18, 18)
    frame33.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame33.BorderSizePixel = 0
    frame33.ZIndex = 105
    frame33.Parent = frame31
  end

  do
    local uiCorner33 = Instance.new("UICorner")
    uiCorner33.CornerRadius = UDim.new(1, 0)
    uiCorner33.Parent = frame33

    local uiStroke16 = Instance.new("UIStroke")
    uiStroke16.Color = Color3.fromRGB(60, 140, 255)
    uiStroke16.Thickness = 2
    uiStroke16.Transparency = 0.3
    uiStroke16.Parent = frame33

    local textLabel21 = Instance.new("TextLabel")
    textLabel21.Size = UDim2.new(1, 0, 0, 20)
    textLabel21.Position = UDim2.new(0, 0, 0, 196)
    textLabel21.BackgroundTransparency = 1
    textLabel21.Text = "100%"
    textLabel21.TextColor3 = Color3.fromRGB(240, 244, 255)
    textLabel21.Font = Enum.Font.GothamBold
    textLabel21.TextSize = 16
    textLabel21.TextXAlignment = Enum.TextXAlignment.Center
    textLabel21.ZIndex = 103
    textLabel21.Parent = frame23

    local function applyUiScale(text2, p13)
      uiScale.Scale = text2
      uiScale2.Scale = text2
      uiScale3.Scale = text2
      uiScale4.Scale = text2
      local v31 = math.clamp((text2 - 0.7) / 0.44999999999999996, 0, 1)
      frame32.Size = UDim2.new(v31, 0, 1, 0)
      frame33.Position = UDim2.new(v31, -9, 0.5, -9)
      textLabel21.Text = tostring(math.floor(text2 * 100 + 0.5)) .. "%"

      if p13 then
        saveUiScale(text2)
      end
    end

    local v32 = (v29 - 0.7) / 0.44999999999999996
    frame32.Size = UDim2.new(math.clamp(v32, 0, 1), 0, 1, 0)
    frame33.Position = UDim2.new(math.clamp(v32, 0, 1), -9, 0.5, -9)
    textLabel21.Text = tostring(math.floor(v29 * 100 + 0.5)) .. "%"
    uiScale3.Scale = v29
    uiScale4.Scale = v29

    frame31.InputBegan:Connect(function(input)
      local v33 = input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch

      local onScaleSliderDrag, connect4

      if v33 then
        function onScaleSliderDrag(p14)
          applyUiScale(0.7 + 0.44999999999999996 * math.clamp(
            (userInputService:GetMouseLocation().X - frame31.AbsolutePosition.X) / frame31.AbsoluteSize.X,
            0, 1
          ), p14)
        end

        onScaleSliderDrag(false)

        connect4 = userInputService.InputChanged:Connect(function(input2)
          if input2.UserInputType == Enum.UserInputType.MouseMovement
            or input2.UserInputType == Enum.UserInputType.Touch then
            onScaleSliderDrag(false)
          end
        end)

        userInputService.InputEnded:Connect(function(input3)
          if input3 == input then
            onScaleSliderDrag(true)
            connect4:Disconnect()
            endConn:Disconnect()
          end
        end)
      end
    end)

    local textButton7 = Instance.new("TextButton")
    textButton7.Size = UDim2.new(1, 0, 0, 28)
    textButton7.Position = UDim2.new(0, 0, 0, 224)
    textButton7.BackgroundColor3 = Color3.fromRGB(30, 40, 55)
    textButton7.Text = "Reset (100%)"
    textButton7.TextColor3 = Color3.fromRGB(180, 200, 230)
    textButton7.Font = Enum.Font.GothamBold
    textButton7.TextSize = 11
    textButton7.AutoButtonColor = false
    textButton7.ZIndex = 103
    textButton7.Parent = frame23

    local uiCorner34 = Instance.new("UICorner")
    uiCorner34.CornerRadius = UDim.new(0, 8)
    uiCorner34.Parent = textButton7

    textButton7.MouseButton1Click:Connect(function() applyUiScale(1, true) end)
  end

  do
    frame34 = Instance.new("Frame")
    frame34.Size = UDim2.new(1, 0, 1, 0)
    frame34.BackgroundTransparency = 1
    frame34.Visible = false
    frame34.ZIndex = 102
    frame34.Parent = frame18

    local frame35 = Instance.new("Frame")
    frame35.Size = UDim2.fromOffset(50, 50)
    frame35.Position = UDim2.new(0.5, -25, 0, 0)
    frame35.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
    frame35.BorderSizePixel = 0
    frame35.ZIndex = 103
    frame35.Parent = frame34

    local uiCorner35 = Instance.new("UICorner")
    uiCorner35.CornerRadius = UDim.new(0, 12)
    uiCorner35.Parent = frame35

    local textLabel22 = Instance.new("TextLabel")
    textLabel22.Size = UDim2.fromScale(1, 1)
    textLabel22.BackgroundTransparency = 1
    textLabel22.Text = "💡"
    textLabel22.Font = Enum.Font.GothamBold
    textLabel22.TextSize = 28
    textLabel22.ZIndex = 104
    textLabel22.Parent = frame35
  end

  do
    local textLabel23 = Instance.new("TextLabel")
    textLabel23.Size = UDim2.new(1, 0, 0, 22)
    textLabel23.Position = UDim2.new(0, 0, 0, 60)
    textLabel23.BackgroundTransparency = 1
    textLabel23.Text = "Send your suggestions"
    textLabel23.TextColor3 = Color3.fromRGB(240, 244, 255)
    textLabel23.Font = Enum.Font.GothamBold
    textLabel23.TextSize = 15
    textLabel23.ZIndex = 103
    textLabel23.Parent = frame34

    local textLabel24 = Instance.new("TextLabel")
    textLabel24.Size = UDim2.new(1, 0, 0, 40)
    textLabel24.Position = UDim2.new(0, 0, 0, 88)
    textLabel24.BackgroundTransparency = 1
    textLabel24.Text = "What would you like us to add in the next v3 update?"
    textLabel24.TextColor3 = Color3.fromRGB(160, 170, 200)
    textLabel24.Font = Enum.Font.GothamMedium
    textLabel24.TextSize = 12
    textLabel24.TextWrapped = true
    textLabel24.ZIndex = 103
    textLabel24.Parent = frame34
  end

  do
    textButton8 = Instance.new("TextButton")
    textButton8.Size = UDim2.new(1, 0, 0, 54)
    textButton8.Position = UDim2.new(0, 0, 0, 140)
    textButton8.BackgroundColor3 = Color3.fromRGB(45, 60, 90)
    textButton8.Text = "Join here"
    textButton8.TextColor3 = Color3.fromRGB(180, 210, 255)
    textButton8.Font = Enum.Font.GothamBold
    textButton8.TextSize = 15
    textButton8.AutoButtonColor = false
    textButton8.ZIndex = 103
    textButton8.Parent = frame34

    local uiCorner36 = Instance.new("UICorner")
    uiCorner36.CornerRadius = UDim.new(0, 12)
    uiCorner36.Parent = textButton8
  end

  do
    local uiStroke17 = Instance.new("UIStroke")
    uiStroke17.Color = Color3.fromRGB(90, 130, 200)
    uiStroke17.Thickness = 1
    uiStroke17.Transparency = 0.2
    uiStroke17.Parent = textButton8

    local imageLabel2 = Instance.new("ImageLabel")
    imageLabel2.Size = UDim2.fromOffset(32, 32)
    imageLabel2.Position = UDim2.new(0, 16, 0.5, -16)
    imageLabel2.BackgroundTransparency = 1
    imageLabel2.Image = "rbxassetid://93628638506572"
    imageLabel2.ImageColor3 = Color3.fromRGB(180, 210, 255)
    imageLabel2.ScaleType = Enum.ScaleType.Fit
    imageLabel2.ZIndex = 104
    imageLabel2.Parent = textButton8
  end

  do
    textButton8.MouseButton1Click:Connect(function()
      if not pcall(function() guiService:OpenBrowserWindow("https://discord.gg/MbQWs6SAgK") end) then
        copyToClipboard("https://discord.gg/MbQWs6SAgK")
      end
    end)

    textButton8.MouseEnter:Connect(function()
      tweenService:Create(textButton8, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(60, 80, 120),
      }):Play()
    end)

    textButton8.MouseLeave:Connect(function()
      tweenService:Create(textButton8, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(45, 60, 90),
      }):Play()
    end)

    frame36 = Instance.new("Frame")
    frame36.Size = UDim2.new(1, 0, 1, 0)
    frame36.BackgroundTransparency = 1
    frame36.Visible = false
    frame36.ZIndex = 102
    frame36.Parent = frame18

    local frame37 = Instance.new("Frame")
    frame37.Size = UDim2.fromOffset(50, 50)
    frame37.Position = UDim2.new(0.5, -25, 0, 0)
    frame37.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
    frame37.BorderSizePixel = 0
    frame37.ZIndex = 103
    frame37.Parent = frame36

    local uiCorner37 = Instance.new("UICorner")
    uiCorner37.CornerRadius = UDim.new(0, 12)
    uiCorner37.Parent = frame37

    local textLabel25 = Instance.new("TextLabel")
    textLabel25.Size = UDim2.fromScale(1, 1)
    textLabel25.BackgroundTransparency = 1
    textLabel25.Text = "ℹ"
    textLabel25.TextColor3 = Color3.fromRGB(120, 180, 255)
    textLabel25.Font = Enum.Font.GothamBold
    textLabel25.TextSize = 28
    textLabel25.ZIndex = 104
    textLabel25.Parent = frame37
  end

  do
    local textLabel26 = Instance.new("TextLabel")
    textLabel26.Size = UDim2.new(1, 0, 0, 22)
    textLabel26.Position = UDim2.new(0, 0, 0, 60)
    textLabel26.BackgroundTransparency = 1
    textLabel26.Text = "Dreyvid Hub"
    textLabel26.TextColor3 = Color3.fromRGB(240, 244, 255)
    textLabel26.Font = Enum.Font.GothamBold
    textLabel26.TextSize = 16
    textLabel26.ZIndex = 103
    textLabel26.Parent = frame36

    local textLabel27 = Instance.new("TextLabel")
    textLabel27.Size = UDim2.new(1, 0, 0, 16)
    textLabel27.Position = UDim2.new(0, 0, 0, 88)
    textLabel27.BackgroundTransparency = 1
    textLabel27.Text = "Version v2.1"
    textLabel27.TextColor3 = Color3.fromRGB(160, 170, 200)
    textLabel27.Font = Enum.Font.GothamMedium
    textLabel27.TextSize = 12
    textLabel27.ZIndex = 103
    textLabel27.Parent = frame36
  end

  do
    local textLabel28 = Instance.new("TextLabel")
    textLabel28.Size = UDim2.new(1, 0, 0, 80)
    textLabel28.Position = UDim2.new(0, 0, 0, 116)
    textLabel28.BackgroundTransparency = 1
    textLabel28.Text = "Hub with Anti-Hit, Hold Egg Longer, Anti-Trap, Server Hop, FPS/Ping, Speedometer and more."
    textLabel28.TextColor3 = Color3.fromRGB(180, 190, 220)
    textLabel28.Font = Enum.Font.GothamMedium
    textLabel28.TextSize = 11
    textLabel28.TextWrapped = true
    textLabel28.ZIndex = 103
    textLabel28.Parent = frame36

    local v34 = {
      { btn = btn, stroke = stroke, panel = frame19 },
      { btn = btn2, stroke = stroke2, panel = frame23 },
      { btn = btn3, stroke = stroke3, panel = frame34 },
      { btn = btn4, stroke = stroke4, panel = frame36 },
    }

    local function selectSettingsTab(p15)
      for index10, value15 in ipairs(v34) do
        local v35 = value15 == p15
        value15.panel.Visible = v35

        if v35 then
          tweenService:Create(value15.btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(30, 60, 100),
            BackgroundTransparency = 0.2,
            TextColor3 = Color3.fromRGB(120, 200, 255),
          }):Play()

          tweenService:Create(value15.stroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(60, 140, 255),
            Transparency = 0.2,
          }):Play()
        else
          tweenService:Create(value15.btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(30, 35, 48),
            BackgroundTransparency = 0.5,
            TextColor3 = Color3.fromRGB(180, 180, 200),
          }):Play()

          tweenService:Create(value15.stroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(70, 90, 130),
            Transparency = 0.6,
          }):Play()
        end
      end
    end

    for index11, value16 in ipairs(v34) do
      local v36 = value16
      v36.btn.MouseButton1Click:Connect(function() selectSettingsTab(v36) end)
    end

    selectSettingsTab(v34[1])
  end

  do
    local v37 = false

    local function updateStayUpButtonVisual()
      if v37 then
        tweenService:Create(textButton6, TweenInfo.new(0.25), {
          BackgroundColor3 = Color3.fromRGB(30, 60, 100),
        }):Play()

        tweenService:Create(uiStroke13, TweenInfo.new(0.25), {
          Color = Color3.fromRGB(60, 140, 255),
          Transparency = 0.1,
        }):Play()

        tweenService:Create(frame22, TweenInfo.new(0.25), {
          Position = UDim2.new(1, -23, 0.5, -10),
          BackgroundColor3 = Color3.fromRGB(100, 200, 255),
        }):Play()
      else
        tweenService:Create(textButton6, TweenInfo.new(0.25), {
          BackgroundColor3 = Color3.fromRGB(45, 45, 55),
        }):Play()

        tweenService:Create(uiStroke13, TweenInfo.new(0.25), {
          Color = Color3.fromRGB(90, 90, 110),
          Transparency = 0.3,
        }):Play()

        tweenService:Create(frame22, TweenInfo.new(0.25), {
          Position = UDim2.new(0, 3, 0.5, -10),
          BackgroundColor3 = Color3.fromRGB(200, 200, 210),
        }):Play()
      end
    end

    textButton6.MouseButton1Click:Connect(function()
      v37 = not v37

      if v37 then
        frame11.Visible = true
        frame10.Visible = true
        enableStayUpMode()
      else
        frame11.Visible = false
        frame10.Visible = false
        disableStayUpMode()
      end

      updateStayUpButtonVisual()
    end)

    textButton.MouseButton1Click:Connect(function() frame13.Visible = not frame13.Visible end)
    textButton4.MouseButton1Click:Connect(function() frame13.Visible = false end)

    local function setAntiHitToggleVisual(p16)
      if p16 then
        tweenService:Create(textButton2, TweenInfo.new(0.25), {
          BackgroundColor3 = Color3.fromRGB(20, 45, 35),
          TextColor3 = Color3.fromRGB(100, 230, 160),
        }):Play()

        tweenService:Create(uiStroke5, TweenInfo.new(0.25), {
          Color = Color3.fromRGB(50, 150, 100),
        }):Play()

        tweenService:Create(frame9, TweenInfo.new(0.25), {
          BackgroundColor3 = Color3.fromRGB(50, 220, 130),
        }):Play()

        textButton2.Text = "ON"
      else
        tweenService:Create(textButton2, TweenInfo.new(0.25), {
          BackgroundColor3 = Color3.fromRGB(40, 25, 30),
          TextColor3 = Color3.fromRGB(230, 120, 120),
        }):Play()

        tweenService:Create(uiStroke5, TweenInfo.new(0.25), {
          Color = Color3.fromRGB(120, 50, 60),
        }):Play()

        tweenService:Create(frame9, TweenInfo.new(0.25), {
          BackgroundColor3 = Color3.fromRGB(230, 70, 80),
        }):Play()

        textButton2.Text = "OFF"
      end
    end

    textButton2.MouseButton1Click:Connect(function()
      v7 = not v7

      if v7 then
        if frame11.Visible then
          frame11.Visible = false
          frame10.Visible = false
          disableStayUpMode()
          v37 = false
          updateStayUpButtonVisual()
        end

        setAntiHitToggleVisual(true)
        setInstantPromptsEnabled(true)

        if not connect3 then
          connect3 = proximityPromptService.PromptTriggered:Connect(function(p17, p18)
            if p18 == localPlayer then
              runAntiHitTeleport()
            end
          end)
        end
      else
        setAntiHitToggleVisual(false)
        setInstantPromptsEnabled(false)

        if connect3 then
          connect3:Disconnect()
          connect3 = nil
        end
      end
    end)

    local function setEggHoldToggleVisual(p19)
      if p19 then
        tweenService:Create(textButton3, TweenInfo.new(0.25), {
          BackgroundColor3 = Color3.fromRGB(20, 45, 35),
          TextColor3 = Color3.fromRGB(100, 230, 160),
        }):Play()

        tweenService:Create(uiStroke7, TweenInfo.new(0.25), {
          Color = Color3.fromRGB(50, 150, 100),
        }):Play()

        tweenService:Create(frame12, TweenInfo.new(0.25), {
          BackgroundColor3 = Color3.fromRGB(50, 220, 130),
        }):Play()

        textButton3.Text = "ON"
      else
        tweenService:Create(textButton3, TweenInfo.new(0.25), {
          BackgroundColor3 = Color3.fromRGB(40, 25, 30),
          TextColor3 = Color3.fromRGB(230, 120, 120),
        }):Play()

        tweenService:Create(uiStroke7, TweenInfo.new(0.25), {
          Color = Color3.fromRGB(120, 50, 60),
        }):Play()

        tweenService:Create(frame12, TweenInfo.new(0.25), {
          BackgroundColor3 = Color3.fromRGB(230, 70, 80),
        }):Play()

        textButton3.Text = "OFF"
      end
    end

    textButton3.MouseButton1Click:Connect(function()
      v11 = not v11

      if v11 then
        if v7 then
          v7 = false
          setAntiHitToggleVisual(false)
          setInstantPromptsEnabled(false)

          if connect3 then
            connect3:Disconnect()
            connect3 = nil
          end
        end

        enableStayUpMode()
        setEggHoldToggleVisual(true)
      else
        disableStayUpMode()
        setEggHoldToggleVisual(false)
      end
    end)

    frame38 = Instance.new("Frame")
    frame38.Size = UDim2.new(0, 200, 0, 46)
    frame38.Position = UDim2.new(1, -210, 1, -56)
  end

  do
    frame38.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame38.BackgroundTransparency = 0.15
    frame38.BorderSizePixel = 0
    frame38.ZIndex = 2
    frame38.Parent = dreyvidHub

    local uiCorner38 = Instance.new("UICorner")
    uiCorner38.CornerRadius = UDim.new(0, 18)
    uiCorner38.Parent = frame38

    local uiStroke18 = Instance.new("UIStroke")
    uiStroke18.Color = Color3.fromRGB(60, 140, 255)
    uiStroke18.Thickness = 1
    uiStroke18.Transparency = 0.2
    uiStroke18.Parent = frame38
  end

  do
    local textLabel29 = Instance.new("TextLabel")
    textLabel29.Size = UDim2.new(0, 60, 0, 14)
    textLabel29.Position = UDim2.new(0, 14, 0, 6)
    textLabel29.BackgroundTransparency = 1
    textLabel29.Text = "SPEED"
    textLabel29.TextColor3 = Color3.fromRGB(120, 180, 255)
    textLabel29.Font = Enum.Font.GothamBold
    textLabel29.TextSize = 9
    textLabel29.TextXAlignment = Enum.TextXAlignment.Left
    textLabel29.ZIndex = 3
    textLabel29.Parent = frame38

    textLabel30 = Instance.new("TextLabel")
  end

  do
    textLabel30.Size = UDim2.new(0, 80, 0, 20)
    textLabel30.Position = UDim2.new(1, -90, 0, 4)
    textLabel30.BackgroundTransparency = 1
    textLabel30.Text = "0"
    textLabel30.TextColor3 = Color3.fromRGB(240, 244, 255)
    textLabel30.Font = Enum.Font.GothamBold
    textLabel30.TextSize = 16
    textLabel30.TextXAlignment = Enum.TextXAlignment.Right
    textLabel30.ZIndex = 3
    textLabel30.Parent = frame38

    local frame39 = Instance.new("Frame")
    frame39.Size = UDim2.new(1, -24, 0, 6)
    frame39.Position = UDim2.new(0, 12, 1, -12)
    frame39.BackgroundColor3 = Color3.fromRGB(30, 35, 48)
    frame39.BorderSizePixel = 0
    frame39.ZIndex = 3
    frame39.Parent = frame38

    local uiCorner39 = Instance.new("UICorner")
    uiCorner39.CornerRadius = UDim.new(1, 0)
    uiCorner39.Parent = frame39

    local frame40 = Instance.new("Frame")
    frame40.Size = UDim2.new(0, 0, 1, 0)
    frame40.BackgroundColor3 = Color3.fromRGB(60, 140, 255)
    frame40.BorderSizePixel = 0
    frame40.ZIndex = 4
    frame40.Parent = frame39

    local uiCorner40 = Instance.new("UICorner")
    uiCorner40.CornerRadius = UDim.new(1, 0)
    uiCorner40.Parent = frame40

    local uiScale5 = Instance.new("UIScale")
    uiScale5.Scale = v29
    uiScale5.Parent = frame38

    runService.RenderStepped:Connect(function()
      if not dreyvidHub.Parent then
        return
      else
        local character4 = localPlayer.Character
        local humanoidRootPart2 = character4 and character4:FindFirstChild("HumanoidRootPart")

        local magnitude = humanoidRootPart2 and Vector3.new(
          humanoidRootPart2.AssemblyLinearVelocity.X, 0,
          humanoidRootPart2.AssemblyLinearVelocity.Z
        ).Magnitude or 0

        textLabel30.Text = tostring(math.floor(magnitude + 0.5))
        frame40.Size = UDim2.new(math.clamp(magnitude / 100, 0, 1), 0, 1, 0)

        if magnitude < 20 then
          frame40.BackgroundColor3 = Color3.fromRGB(60, 140, 255)
        elseif magnitude < 50 then
          frame40.BackgroundColor3 = Color3.fromRGB(60, 200, 255)
        elseif magnitude < 80 then
          frame40.BackgroundColor3 = Color3.fromRGB(255, 200, 60)
        else
          frame40.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        end

        return
      end
    end)
  end

  do
    frame41 = Instance.new("Frame")
    frame41.Size = UDim2.new(0, 170, 0, 30)
    frame41.Position = UDim2.new(0.5, -85, 0, 34)
    frame41.BackgroundTransparency = 1
    frame41.Parent = dreyvidHub

    local uiListLayout2 = Instance.new("UIListLayout")
    uiListLayout2.FillDirection = Enum.FillDirection.Horizontal
    uiListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uiListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
    uiListLayout2.Padding = UDim.new(0, 10)
    uiListLayout2.Parent = frame41

    local frame42 = Instance.new("Frame")
    frame42.Size = UDim2.new(0, 75, 0, 24)
    frame42.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame42.BackgroundTransparency = 0.5
    frame42.BorderSizePixel = 0
    frame42.LayoutOrder = 1
    frame42.Parent = frame41

    local uiCorner41 = Instance.new("UICorner")
    uiCorner41.CornerRadius = UDim.new(0, 12)
    uiCorner41.Parent = frame42

    textLabel31 = Instance.new("TextLabel")
    textLabel31.Size = UDim2.new(1, -8, 1, 0)
    textLabel31.Position = UDim2.new(0, 4, 0, 0)
    textLabel31.BackgroundTransparency = 1
    textLabel31.Text = "FPS: --"
    textLabel31.TextColor3 = Color3.fromRGB(240, 244, 255)
    textLabel31.Font = Enum.Font.GothamBold
    textLabel31.TextSize = 12
    textLabel31.Parent = frame42
  end

  do
    local frame43 = Instance.new("Frame")
    frame43.Size = UDim2.new(0, 75, 0, 24)
    frame43.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame43.BackgroundTransparency = 0.5
    frame43.BorderSizePixel = 0
    frame43.LayoutOrder = 2
    frame43.Parent = frame41

    local uiCorner42 = Instance.new("UICorner")
    uiCorner42.CornerRadius = UDim.new(0, 12)
    uiCorner42.Parent = frame43

    local textLabel32 = Instance.new("TextLabel")
    textLabel32.Size = UDim2.new(1, -8, 1, 0)
    textLabel32.Position = UDim2.new(0, 4, 0, 0)
    textLabel32.BackgroundTransparency = 1
    textLabel32.Text = "PING: --"
    textLabel32.TextColor3 = Color3.fromRGB(240, 244, 255)
    textLabel32.Font = Enum.Font.GothamBold
    textLabel32.TextSize = 12
    textLabel32.Parent = frame43

    local v38 = 0
    local v39 = 0

    task.spawn(function()
      while dreyvidHub.Parent do
        task.wait(1)
        local v40 = math.floor(v38 / v39 + 0.5)
        v38 = 0
        v39 = 0
        textLabel31.Text = "FPS: " .. tostring(v40)

        if v40 >= 50 then
          textLabel31.TextColor3 = Color3.fromRGB(80, 230, 130)
        elseif v40 >= 30 then
          textLabel31.TextColor3 = Color3.fromRGB(255, 210, 80)
        else
          textLabel31.TextColor3 = Color3.fromRGB(255, 80, 80)
        end
      end
    end)

    runService.RenderStepped:Connect(function(delta)
      if not dreyvidHub.Parent then
        return
      end

      v38 = v38 + 1
      v39 = v39 + delta
    end)

    task.spawn(function()
      while dreyvidHub.Parent do
        task.wait(1)

        local v41, v42 = pcall(function()
          return statsService.Network.ServerStatsItem["Data Ping"]:GetValue()
        end)

        if v41 and v42 then
          local v43 = math.floor(v42 + 0.5)
          textLabel32.Text = "PING: " .. v43

          if v43 <= 80 then
            textLabel32.TextColor3 = Color3.fromRGB(80, 230, 130)
          elseif v43 <= 150 then
            textLabel32.TextColor3 = Color3.fromRGB(255, 210, 80)
          else
            textLabel32.TextColor3 = Color3.fromRGB(255, 80, 80)
          end
        end
      end
    end)
  end

  do
    frame44 = Instance.new("Frame")
    frame44.Size = UDim2.new(0, 175, 0, 75)
    frame44.Position = UDim2.new(1, -185, 0, 30)
    frame44.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame44.BackgroundTransparency = 0.25
    frame44.BorderSizePixel = 0
    frame44.Parent = dreyvidHub

    local uiCorner43 = Instance.new("UICorner")
    uiCorner43.CornerRadius = UDim.new(0, 14)
    uiCorner43.Parent = frame44

    local uiStroke19 = Instance.new("UIStroke")
    uiStroke19.Color = Color3.fromRGB(60, 140, 255)
    uiStroke19.Thickness = 1
    uiStroke19.Transparency = 0.2
    uiStroke19.Parent = frame44
  end

  do
    local textLabel33 = Instance.new("TextLabel")
    textLabel33.Size = UDim2.new(0, 100, 0, 18)
    textLabel33.Position = UDim2.new(0, 14, 0, 6)
    textLabel33.BackgroundTransparency = 1
    textLabel33.Text = "Server Hop"
    textLabel33.TextColor3 = Color3.fromRGB(240, 244, 255)
    textLabel33.Font = Enum.Font.GothamBold
    textLabel33.TextSize = 13
    textLabel33.TextXAlignment = Enum.TextXAlignment.Left
    textLabel33.Parent = frame44

    textButton9 = Instance.new("TextButton")
    textButton9.Size = UDim2.fromOffset(32, 26)
  end

  do
    textButton9.Position = UDim2.new(0, 14, 0, 36)
    textButton9.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
    textButton9.Text = "1"
    textButton9.TextColor3 = Color3.fromRGB(240, 244, 255)
    textButton9.Font = Enum.Font.GothamBold
    textButton9.TextSize = 13
    textButton9.AutoButtonColor = false
    textButton9.Parent = frame44

    local uiCorner44 = Instance.new("UICorner")
    uiCorner44.CornerRadius = UDim.new(0, 6)
    uiCorner44.Parent = textButton9

    local textButton10 = Instance.new("TextButton")
    textButton10.Size = UDim2.new(1, -58, 0, 26)
    textButton10.Position = UDim2.new(0, 52, 0, 36)
    textButton10.BackgroundColor3 = Color3.fromRGB(30, 60, 100)
    textButton10.Text = "ON"
    textButton10.TextColor3 = Color3.fromRGB(120, 200, 255)
    textButton10.Font = Enum.Font.GothamBold
    textButton10.TextSize = 12
    textButton10.AutoButtonColor = false
    textButton10.Parent = frame44

    local uiCorner45 = Instance.new("UICorner")
    uiCorner45.CornerRadius = UDim.new(0, 6)
    uiCorner45.Parent = textButton10

    local uiScale6 = Instance.new("UIScale")
    uiScale6.Scale = v29
    uiScale6.Parent = frame44

    local v44 = 1

    textButton9.MouseButton1Click:Connect(function()
      v44 = v44 + 1

      if v44 > 5 then
        v44 = 1
      end

      textButton9.Text = tostring(v44)
    end)

    local function findLowPlayerServerId(p20)
      local v45 = "https://games.roblox.com/v1/games/" .. placeId
        .. "/servers/Public?sortOrder=Asc&limit=100"

      local v46, v47 = pcall(function() return game:HttpGet(v45) end)

      if not v46 or not v47 then
        return nil
      else
        local v48, v49 = pcall(httpService.JSONDecode, httpService, v47)

        if not v48 or not v49 or not v49.data then
          return nil
        else
          local v50 = tostring(game.JobId)
          local v51 = {}

          for index12, value17 in ipairs(v49.data) do
            if value17.id and tostring(value17.id) ~= v50 and value17.playing
              and value17.playing <= p20 and value17.playing > 0 then
              table.insert(v51, tostring(value17.id))
            end
          end

          if #v51 == 0 then
            return nil
          end

          return v51[math.random(1, #v51)]
        end
      end
    end

    textButton10.MouseButton1Click:Connect(function()
      textButton10.Active = false
      textButton10.Text = "..."

      local v52 = findLowPlayerServerId(v44)

      if not v52 then
        textButton10.Text = "NONE"
        task.wait(2)

        textButton10.Text = "ON"
        textButton10.Active = true

        return
      end

      textButton10.Text = "OK"
      task.wait(0.3)
      pcall(function() teleportService:TeleportToPlaceInstance(placeId, v52, localPlayer) end)
      textButton10.Active = true
    end)
  end
end

makeTextLabel(function() buildMainHubUI() end)
local localPlayer2 = players.LocalPlayer

local v53 = {
  Enabled = true,
  CooldownSeconds = 15,
  WebhookName = "Dreyvid Hub",
  WebhookAvatar = "https://media.discordapp.net/attachments/1554158589449343167/1555760950177435768/e541296a-ea4d-409d-8f84-7cf852b8e96d.png?backend=b2&ex=6ac1b2cb&is=6ac0614b&hm=b5a1d1b37b145350533ea559580f7cd7ed62854015eb40e82b0771e67fdd06ab&=&format=webp&quality=lossless&width=768&height=768",
  MinValue = 500000000,
  ShowGUI = false,
}

local playerGui2
pcall(function() playerGui2 = gethui() end)

if not playerGui2 then
  pcall(function() playerGui2 = coreGui end)
end

if not playerGui2 then
  playerGui2 = localPlayer2:WaitForChild("PlayerGui")
end

local v54 = syn and syn.request or http and http.request or http_request or request

local function requireModulePath(...)
  local v55 = { ... }

  local v56, v57 = pcall(function()
    local waitForChild = replicatedStorage

    for index13, value18 in ipairs(v55) do
      waitForChild = waitForChild:WaitForChild(value18, 3)

      if not waitForChild then
        return nil
      end
    end

    return require(waitForChild)
  end)

  return v56 and v57 or nil
end

local v58 = requireModulePath("Client", "EggState")
local v59 = requireModulePath("Data", "Assets")

local packages = replicatedStorage:FindFirstChild("Packages")
packages = packages and packages:FindFirstChild("Networking")

local function buildEggInfoFromAsset(assetCategory, assetScale)
  local directory = v59 and v59.Directory
  local v60 = type(directory) == "table" and directory[tostring(assetCategory)] or nil
  local name = v60 and tostring(v60.DisplayName or assetCategory) or tostring(assetCategory)
  local v61 = v60 and tonumber(v60.EarningRate) or 0
  local v62 = tonumber(assetScale) or 1
  local v63 = v62 > 5 and (v62 / 5) ^ 1.2 * 19.637875755794 or v62 ^ 1.85

  local v64 = v60 and type(v60.Rarity) == "table"
    and tonumber(v60.Rarity.RarityNumber or v60.Rarity.Rank)

  local v65 = v60
  local v66 = v64 or 0

  if v60 then
    v65 = type(v60.Rarity) == "table" and tostring(v60.Rarity.DisplayName or "")
  end

  local rarityName = v65 or ""

  return {
    Name = name,
    Category = tostring(assetCategory),
    Rarity = v66 or 0,
    RarityName = rarityName,
    Value = v61 * v63,
    Scale = v62,
  }
end

local function formatValueLong(value19)
  if value19 >= 1000000000000 then
    return string.format("%.2f Trillion", value19 / 1000000000000)
  elseif value19 >= 1000000000 then
    return string.format("%.2f Billion", value19 / 1000000000)
  elseif value19 >= 1000000 then
    return string.format("%.2f Million", value19 / 1000000)
  else
    if value19 >= 1000 then
      return string.format("%.1fK", value19 / 1000)
    end

    return string.format("%.0f", value19)
  end
end

local function formatValueShort(value20)
  if value20 >= 1000000000000 then
    return string.format("%.2fT", value20 / 1000000000000)
  elseif value20 >= 1000000000 then
    return string.format("%.2fB", value20 / 1000000000)
  elseif value20 >= 1000000 then
    return string.format("%.2fM", value20 / 1000000)
  else
    if value20 >= 1000 then
      return string.format("%.1fK", value20 / 1000)
    end

    return string.format("%.0f", value20)
  end
end

local function getFieldEggsFromEggState()
  if type(v58) ~= "table" or type(v58.ReadFieldEggs) ~= "function" then
    return nil
  else
    local v67, v68 = pcall(v58.ReadFieldEggs)

    if not v67 or type(v68) ~= "table" or type(v68.Records) ~= "table" then
      return nil
    else
      local count = 0

      for key3 in pairs(v68.Records) do
        count = count + 1
      end

      if count > 0 then
        return v68.Records
      end

      return nil
    end
  end
end

local getFieldEggsFromRemote

local function tryGetFieldEggRecords()
  for index14, value21 in ipairs({ getFieldEggsFromEggState, getFieldEggsFromRemote }) do
    local v69, v70 = pcall(value21)

    if v69 and type(v70) == "table" then
      local count2 = 0

      for key4 in pairs(v70) do
        count2 = count2 + 1
      end

      if count2 > 0 then
        return v70, count2
      end
    end
  end

  return {}, 0
end

function getFieldEggsFromRemote()
  if not packages then
    return nil
  end

  local rfEggWorldAskFieldEggSnapshot = packages:FindFirstChild("RF/EggWorld/AskFieldEggSnapshot")

  if not rfEggWorldAskFieldEggSnapshot
    or not rfEggWorldAskFieldEggSnapshot:IsA("RemoteFunction") then
    return nil
  else
    local v71, v72 = pcall(function() return rfEggWorldAskFieldEggSnapshot:InvokeServer() end)

    if not v71 or type(v72) ~= "table" or type(v72.Records) ~= "table" then
      return nil
    else
      local count3 = 0

      for key5 in pairs(v72.Records) do
        count3 = count3 + 1
      end

      if count3 > 0 then
        return v72.Records
      end

      return nil
    end
  end
end

local function sendLowValueEggWebhook(p21)
  if not v54 or not p21 then
    return false, "no_request"
  else
    local v73 = {
      username = v53.WebhookName,
      avatar_url = v53.WebhookAvatar,
      content = "🔻 **" .. localPlayer2.Name .. "** found an egg **under 500M**",
      embeds = {
        {
          title = "🔻 Egg Under 500M",
          description = string.format(
            "👤 **User:** %s\n🐣 **Egg:** %s\n💰 **Value:** $%s/s\n📍 **Area:** %s\n🆔 **Job ID:** `%s`",
            localPlayer2.Name, p21.Name, formatValueShort(p21.Value), p21.AreaId or "?",
            tostring(game.JobId or "Unknown")
          ),
          color = 16711680,
          footer = { text = "Dreyvid Hub · " .. os.date("%H:%M:%S") },
        },
      },
    }

    local v74, v75 = pcall(function()
      return v54({
        Url = "https://discord.com/api/webhooks/1554158678435700857/bR8eh8vHQ4DzSZ6xow2FEtf-i37uwS_YChILWaJPUYYODLrL2fI1puHMEK80udjxMY0c",
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = httpService:JSONEncode(v73),
      })
    end)

    if v74 and type(v75) == "table" then
      return v75.StatusCode == 200 or v75.StatusCode == 204, v75.StatusCode
    end

    return false, tostring(v75)
  end
end

local function getBestFieldEgg()
  local v76, v77

  for key6, value22 in pairs((tryGetFieldEggRecords())) do
    if type(value22) == "table" and value22.State ~= "Claimed" then
      if value22.Value and value22.Rarity then
        v77 = value22
      else
        v77 = buildEggInfoFromAsset(value22.AssetCategory, value22.AssetScale)
      end

      v77.Uid = key6
      v77.AreaId = tostring(value22.AreaId or "?")

      if not v76 or v77.Value > v76.Value then
        v76 = v77
      end
    end
  end

  return v76
end

local function formatEggPlainText(p22)
  local v78 = "R" .. tostring(p22.Rarity)

  if p22.RarityName and p22.RarityName ~= "" then
    v78 = p22.RarityName .. " (R" .. tostring(p22.Rarity) .. ")"
  end

  return table.concat({
    "=================================", "   🐣 NEW BEST EGG - DREYVID HUB",
    "=================================", "", "👤 User:         " .. localPlayer2.Name,
    "🐣 Egg:          " .. p22.Name, "📦 Category:     " .. (p22.Category or "?"),
    "💰 Value:        $" .. formatValueLong(p22.Value) .. "/s",
    "📈 Exact value:  " .. string.format("%.0f", p22.Value) .. "/s",
    "⭐ Rarity:       " .. v78, "📍 Area:         " .. (p22.AreaId or "?"),
    "📊 Scale:        x" .. string.format("%.2f", p22.Scale or 1),
    "🆔 Job ID:       " .. tostring(game.JobId or "Unknown"),
    "🆔 Place ID:     " .. tostring(game.PlaceId or "Unknown"),
    "🕒 Time:         " .. os.date("%Y-%m-%d %H:%M:%S"), "",
    "=================================",
  }, "\n")
end

local function sendHighValueEggWebhook(p23)
  local v79 = not v54 or not p23
  local v80

  if v79 then
    return false, "no_request"
  else
    local v81 = "R" .. tostring(p23.Rarity)

    if p23.RarityName and p23.RarityName ~= "" then
      v81 = p23.RarityName .. " (R" .. tostring(p23.Rarity) .. ")"
    end

    local v82 = formatValueShort(p23.Value)
    local v83 = tostring(game.JobId or "Unknown")

    local v84 = string.format(
      "**%s**\n\n💰 **Value:** $%s/s\n⭐ **Rarity:** %s\n📍 **Area:** %s\n📊 **Scale:** x%.2f\n🆔 **Job ID:** `%s`\n👤 **User:** %s",
      p23.Name, v82, v81, p23.AreaId or "?", p23.Scale or 1, v83, localPlayer2.Name
    )

    local v85 = formatEggPlainText(p23)

    v80 = {
      username = v53.WebhookName,
      avatar_url = v53.WebhookAvatar,
      content = "🔥 **" .. localPlayer2.Name .. "** found an egg **above 500M**",
      embeds = {
        {
          title = "🐣 NEW BEST EGG",
          description = v84,
          color = 5763719,
          footer = { text = "Dreyvid Hub · " .. os.date("%H:%M:%S") },
          fields = {
            {
              name = "📄 Plain text (copy on PC)",
              value = [[
```
]] .. v85 .. "\n```",
              inline = false,
            },
          },
        },
      },
    }

    local v86, v87 = pcall(function()
      return v54({
        Url = "https://discord.com/api/webhooks/1554158678435700857/bR8eh8vHQ4DzSZ6xow2FEtf-i37uwS_YChILWaJPUYYODLrL2fI1puHMEK80udjxMY0c",
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = httpService:JSONEncode(v80),
      })
    end)

    if v86 and type(v87) == "table" then
      return v87.StatusCode == 200 or v87.StatusCode == 204, v87.StatusCode
    end

    return false, tostring(v87)
  end
end

local v88 = 0
local uid

task.spawn(function()
  task.wait(2)

  while v53.Enabled do
    local v89 = getBestFieldEgg()

    if v89 then
      local v90 = os.clock()
      local v91 = v90 - v88

      if v89.Uid ~= uid and v91 >= v53.CooldownSeconds then
        uid = v89.Uid
        v88 = v90

        if v89.Value >= v53.MinValue then
          local v92, v93 = sendHighValueEggWebhook(v89)

          if v92 then
            print(string.format(
              "[Dreyvid] ✓ Sent (HIGH): %s ($%s/s) - User: %s", v89.Name,
              formatValueShort(v89.Value), localPlayer2.Name
            ))
          else
            warn("[Dreyvid] ✗ HIGH failed. Code:", v93)
            uid = nil
          end
        else
          local v94, v95 = sendLowValueEggWebhook(v89)

          if v94 then
            print(string.format(
              "[Dreyvid] ✓ Sent (LOW): %s ($%s/s) - User: %s", v89.Name, formatValueShort(v89.Value),
              localPlayer2.Name
            ))
          else
            warn("[Dreyvid] ✗ LOW failed. Code:", v95)
            uid = nil
          end
        end
      end
    end

    task.wait(3)
  end
end)

print("[Dreyvid] ✅ Script running (silent, 500M+ filter, with avatar and username)")
print("[Dreyvid] 👤 Current user:", localPlayer2.Name)

