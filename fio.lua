-- First Is Owner | FIO Hub starter
-- Client-side utilities only. No owner/admin spoofing or remote calls.
local PLACE_ID = 130496219537579
if game.PlaceId ~= PLACE_ID then
    warn("[FIO] Wrong experience; expected First Is Owner.")
    return
end

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer
if not localPlayer then return end

local environment = (type(getgenv) == "function" and getgenv()) or _G
if environment.FIO_HUB and type(environment.FIO_HUB.Destroy) == "function" then
    environment.FIO_HUB.Destroy()
end

local connections = {}
local function track(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(connections, connection)
    return connection
end

local function create(className, properties, parent)
    local object = Instance.new(className)
    for key, value in pairs(properties) do
        object[key] = value
    end
    object.Parent = parent
    return object
end

local WHITE = Color3.fromRGB(255, 255, 255)
local TEXT = Color3.fromRGB(35, 35, 35)
local BLUE = Color3.fromRGB(23, 68, 151)
local GRAY = Color3.fromRGB(210, 212, 215)

local gui = create("ScreenGui", {
    Name = "FIO_Hub",
    ResetOnSpawn = false,
    IgnoreGuiInset = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, localPlayer:WaitForChild("PlayerGui"))

local window = create("Frame", {
    Name = "Window",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0.94, 0, 0, 375),
    BackgroundColor3 = GRAY,
    BorderColor3 = Color3.fromRGB(75, 75, 75),
    BorderSizePixel = 1,
    Active = true
}, gui)
create("UISizeConstraint", {
    MinSize = Vector2.new(285, 375),
    MaxSize = Vector2.new(500, 375)
}, window)

local bar = create("Frame", {
    Name = "TitleBar",
    Size = UDim2.new(1, 0, 0, 34),
    BackgroundColor3 = BLUE,
    BorderSizePixel = 0,
    Active = true
}, window)
create("TextLabel", {
    Name = "Title",
    Size = UDim2.new(1, -104, 1, 0),
    Position = UDim2.fromOffset(10, 0),
    BackgroundTransparency = 1,
    Text = "FIRST IS OWNER  /  FIO HUB",
    TextColor3 = WHITE,
    TextSize = 15,
    Font = Enum.Font.ArialBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, bar)

local function makeButton(text, parent, position, size)
    return create("TextButton", {
        Text = text,
        Font = Enum.Font.Arial,
        TextSize = 14,
        TextColor3 = TEXT,
        BackgroundColor3 = Color3.fromRGB(241, 241, 241),
        BorderColor3 = Color3.fromRGB(115, 115, 115),
        Position = position,
        Size = size,
        AutoButtonColor = true
    }, parent)
end

local hideButton = makeButton("_", bar, UDim2.new(1, -65, 0, 5), UDim2.fromOffset(26, 24))
local unloadButton = makeButton("X", bar, UDim2.new(1, -34, 0, 5), UDim2.fromOffset(26, 24))

local opener = makeButton("FIO", gui, UDim2.new(0, 8, 0.5, -16), UDim2.fromOffset(52, 32))
opener.Visible = false
opener.TextColor3 = WHITE
opener.BackgroundColor3 = BLUE

local tabsBar = create("Frame", {
    Position = UDim2.fromOffset(9, 43),
    Size = UDim2.new(1, -18, 0, 29),
    BackgroundTransparency = 1
}, window)
local content = create("Frame", {
    Position = UDim2.fromOffset(9, 78),
    Size = UDim2.new(1, -18, 1, -110),
    BackgroundColor3 = WHITE,
    BorderColor3 = Color3.fromRGB(135, 135, 135)
}, window)

local status = create("TextLabel", {
    Position = UDim2.new(0, 11, 1, -27),
    Size = UDim2.new(1, -22, 0, 20),
    Text = "Ready",
    TextColor3 = TEXT,
    TextSize = 12,
    Font = Enum.Font.Arial,
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd
}, window)
local function setStatus(message)
    status.Text = tostring(message)
end

local pages = {}
local tabButtons = {}
local function makePage(name, tabIndex)
    local tab = makeButton(name, tabsBar,
        UDim2.new((tabIndex - 1) / 3, 0, 0, 0),
        UDim2.new(1 / 3, -4, 1, 0))
    tabButtons[name] = tab
    local page = create("Frame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible = false
    }, content)
    pages[name] = page
    return page
end
local home = makePage("Home", 1)
local playersPage = makePage("Players", 2)
local visuals = makePage("Visuals", 3)

local function showTab(name)
    for tabName, page in pairs(pages) do
        local selected = tabName == name
        page.Visible = selected
        tabButtons[tabName].BackgroundColor3 =
            selected and WHITE or Color3.fromRGB(222, 224, 226)
    end
end
for name, tab in pairs(tabButtons) do
    tab.MouseButton1Click:Connect(function()
        showTab(name)
    end)
end

local function label(text, parent, position, size, textSize, bold)
    return create("TextLabel", {
        Text = text,
        BackgroundTransparency = 1,
        Position = position,
        Size = size,
        TextColor3 = TEXT,
        TextSize = textSize or 14,
        Font = bold and Enum.Font.ArialBold or Enum.Font.Arial,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true
    }, parent)
end

-- Home
label("FIRST IS OWNER", home, UDim2.fromOffset(13, 14),
    UDim2.new(1, -26, 0, 23), 18, true)
label("Client utility hub / starter build", home,
    UDim2.fromOffset(13, 42), UDim2.new(1, -26, 0, 23), 14)

local serverLabel = label("", home, UDim2.fromOffset(13, 82),
    UDim2.new(1, -26, 0, 23), 14)
local function updateServer()
    serverLabel.Text = "Players: " .. #Players:GetPlayers() .. " / " .. Players.MaxPlayers
end
updateServer()
track(Players.PlayerAdded, updateServer)
track(Players.PlayerRemoving, function()
    task.defer(updateServer)
end)

label("Server authority", home, UDim2.fromOffset(13, 121),
    UDim2.new(1, -26, 0, 24), 15, true)
label("Owner position, admin ranks and coins are managed by the game's server. This hub does not unlock them.", home,
    UDim2.fromOffset(13, 150), UDim2.new(1, -26, 0, 70), 14)
label("Right Shift: show / hide this window", home,
    UDim2.new(0, 13, 1, -31), UDim2.new(1, -26, 0, 24), 13)

-- Players
local selectedPlayer = nil
local spectating = false
label("PLAYERS", playersPage, UDim2.fromOffset(12, 10),
    UDim2.new(1, -24, 0, 24), 16, true)
local selectedLabel = label("Selected: none", playersPage,
    UDim2.fromOffset(12, 37), UDim2.new(1, -24, 0, 23), 13)

local list = create("ScrollingFrame", {
    Position = UDim2.fromOffset(12, 64),
    Size = UDim2.new(1, -24, 1, -113),
    BackgroundColor3 = Color3.fromRGB(245, 245, 245),
    BorderColor3 = Color3.fromRGB(160, 160, 160),
    ScrollBarThickness = 5,
    CanvasSize = UDim2.fromOffset(0, 0)
}, playersPage)
local layout = create("UIListLayout", {
    Padding = UDim.new(0, 4),
    SortOrder = Enum.SortOrder.Name
}, list)
create("UIPadding", {
    PaddingTop = UDim.new(0, 5),
    PaddingLeft = UDim.new(0, 5),
    PaddingRight = UDim.new(0, 5)
}, list)

local function ownHumanoid()
    local character = localPlayer.Character
    return character and character:FindFirstChildOfClass("Humanoid")
end
local function stopSpectate()
    local camera = workspace.CurrentCamera
    local humanoid = ownHumanoid()
    if camera and humanoid then
        camera.CameraSubject = humanoid
    end
    spectating = false
end
local function renderPlayers()
    for _, child in ipairs(list:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local entry = makeButton(player.DisplayName .. " (@" .. player.Name .. ")",
                list, UDim2.fromOffset(0, 0), UDim2.new(1, -4, 0, 28))
            entry.Name = player.Name
            entry.TextXAlignment = Enum.TextXAlignment.Left
            entry.MouseButton1Click:Connect(function()
                selectedPlayer = player
                selectedLabel.Text = "Selected: @" .. player.Name
                setStatus("Selected @" .. player.Name)
            end)
        end
    end
end
track(layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
    list.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 12)
end)
renderPlayers()
track(Players.PlayerAdded, renderPlayers)
track(Players.PlayerRemoving, function(player)
    if selectedPlayer == player then
        selectedPlayer = nil
        selectedLabel.Text = "Selected: none"
        if spectating then stopSpectate() end
    end
    task.defer(renderPlayers)
end)

local spectateButton = makeButton("Spectate", playersPage,
    UDim2.new(0, 12, 1, -40), UDim2.new(0.33, -12, 0, 30))
local teleportButton = makeButton("Teleport", playersPage,
    UDim2.new(0.33, 5, 1, -40), UDim2.new(0.34, -10, 0, 30))
local resetButton = makeButton("Reset cam", playersPage,
    UDim2.new(0.67, 1, 1, -40), UDim2.new(0.33, -13, 0, 30))

spectateButton.MouseButton1Click:Connect(function()
    if not selectedPlayer then setStatus("Select a player first") return end
    local character = selectedPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local camera = workspace.CurrentCamera
    if not humanoid or not camera then setStatus("Target not spawned") return end
    camera.CameraSubject = humanoid
    spectating = true
    setStatus("Spectating @" .. selectedPlayer.Name)
end)
teleportButton.MouseButton1Click:Connect(function()
    if not selectedPlayer then setStatus("Select a player first") return end
    local mine = localPlayer.Character
    local theirs = selectedPlayer.Character
    local myRoot = mine and mine:FindFirstChild("HumanoidRootPart")
    local theirRoot = theirs and theirs:FindFirstChild("HumanoidRootPart")
    if not myRoot or not theirRoot then setStatus("Character unavailable") return end
    myRoot.CFrame = theirRoot.CFrame * CFrame.new(3, 0, 0)
    setStatus("Local teleport attempted")
end)
resetButton.MouseButton1Click:Connect(function()
    stopSpectate()
    setStatus("Camera restored")
end)

-- Visuals & movement
label("VISUALS & MOVEMENT", visuals,
    UDim2.fromOffset(13, 13), UDim2.new(1, -26, 0, 26), 16, true)
label("Changes on this page are client-side only.", visuals,
    UDim2.fromOffset(13, 44), UDim2.new(1, -26, 0, 39), 13)
local lightingSnapshot = {
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
    ClockTime = Lighting.ClockTime
}
local brightEnabled = false
local function setFullbright(on)
    brightEnabled = on
    if on then
        Lighting.Brightness = 3
        Lighting.Ambient = WHITE
        Lighting.OutdoorAmbient = WHITE
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100000
        Lighting.ClockTime = 12
    else
        for key, value in pairs(lightingSnapshot) do
            Lighting[key] = value
        end
    end
end
local brightButton = makeButton("Fullbright: OFF", visuals,
    UDim2.fromOffset(13, 93), UDim2.new(1, -26, 0, 34))
brightButton.MouseButton1Click:Connect(function()
    setFullbright(not brightEnabled)
    brightButton.Text = brightEnabled and "Fullbright: ON" or "Fullbright: OFF"
    setStatus(brightButton.Text)
end)
label("WalkSpeed (may be reset by the game)", visuals,
    UDim2.fromOffset(13, 149), UDim2.new(1, -26, 0, 24), 14)
local speeds = {16, 32, 50}
for index, speed in ipairs(speeds) do
    local speedButton = makeButton(tostring(speed), visuals,
        UDim2.new((index - 1) / 3, 13, 0, 177),
        UDim2.new(1 / 3, -18, 0, 33))
    speedButton.MouseButton1Click:Connect(function()
        local humanoid = ownHumanoid()
        if not humanoid then setStatus("Character unavailable") return end
        humanoid.WalkSpeed = speed
        setStatus("WalkSpeed set to " .. speed .. " (local)")
    end)
end

-- Window controls / unload
local function setWindowVisible(visible)
    window.Visible = visible
    opener.Visible = not visible
end
hideButton.MouseButton1Click:Connect(function()
    setWindowVisible(false)
end)
opener.MouseButton1Click:Connect(function()
    setWindowVisible(true)
end)
track(UserInputService.InputBegan, function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        setWindowVisible(not window.Visible)
    end
end)

local dragging = false
local dragStart
local startPosition
track(bar.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = window.Position
    end
end)
track(UserInputService.InputEnded, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
track(UserInputService.InputChanged, function(input)
    if not dragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = input.Position - dragStart
    window.Position = UDim2.new(
        startPosition.X.Scale, startPosition.X.Offset + delta.X,
        startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
    )
end)

local destroyed = false
local function destroy()
    if destroyed then return end
    destroyed = true
    if brightEnabled then setFullbright(false) end
    if spectating then stopSpectate() end
    for _, connection in ipairs(connections) do
        connection:Disconnect()
    end
    gui:Destroy()
    if environment.FIO_HUB and environment.FIO_HUB.Destroy == destroy then
        environment.FIO_HUB = nil
    end
end
environment.FIO_HUB = {Destroy = destroy, Version = "0.1.0"}
unloadButton.MouseButton1Click:Connect(destroy)
showTab("Home")
print("[FIO] Hub v0.1.0 loaded")
