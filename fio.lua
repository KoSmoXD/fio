-- First Is Owner | FIO Hub starter
-- Client utilities and optional F3X BTools actions. Server permissions still apply.
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
        UDim2.new((tabIndex - 1) / 5, 0, 0, 0),
        UDim2.new(1 / 5, -4, 1, 0))
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
local exploits = makePage("Exploits", 4)
local btools = makePage("BTools", 5)

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

-- Client Anti-Lag: locally remove bursts of newly replicated generic BTools debris.
-- Does not send network requests, create parts, modify the server, or alter other clients.
-- Existing map parts and player characters are never scanned for removal.
local clientAntiLagEnabled = false
local clientAntiLagConnection = nil
local recentClutter = {}
local clutterWindowStarted = 0
local clutterBurstUntil = 0
local locallyRemoved = 0
local CLUTTER_WINDOW_SECONDS = 2
local CLUTTER_THRESHOLD = 24
local CLUTTER_BURST_SECONDS = 8
local CLUTTER_NAMES = {
    Part = true, Wedge = true, Cylinder = true,
    CornerWedge = true, Block = true
}

local function otherPlayerCount(excluding)
    local count = 0
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player ~= excluding then
            count += 1
        end
    end
    return count
end

local antiLagButton = makeButton("Client Anti-Lag: OFF", visuals,
    UDim2.fromOffset(13, 216), UDim2.new(1, -26, 0, 34))
antiLagButton.TextSize = 13

local function isGenericDebris(part)
    if not part:IsA("BasePart") or not CLUTTER_NAMES[part.Name] then
        return false
    end
    local parent = part.Parent
    if not parent then return false end
    if parent == workspace then return true end
    -- Some building tools place a generic Model directly in Workspace.
    if parent:IsA("Model") and parent.Parent == workspace
        and (parent.Name == "Model" or parent.Name == "BTools"
            or parent.Name == "F3X") then
        return true
    end
    return false
end

local function stopClientAntiLag(message)
    clientAntiLagEnabled = false
    antiLagButton.Text = "Client Anti-Lag: OFF"
    if clientAntiLagConnection then
        clientAntiLagConnection:Disconnect()
        clientAntiLagConnection = nil
    end
    table.clear(recentClutter)
    clutterWindowStarted = 0
    clutterBurstUntil = 0
    if message then setStatus(message) end
end

local function removeLocalDebris(part)
    if not clientAntiLagEnabled or not part.Parent then return end
    if not isGenericDebris(part) then return end
    -- This is client-only removal of a replicated instance. Other players'
    -- copies and the authoritative server Workspace are not modified.
    local ok = pcall(function() part:Destroy() end)
    if ok then locallyRemoved += 1 end
end

local function observeLocalDebris(descendant)
    if not clientAntiLagEnabled or not isGenericDebris(descendant) then return end
    local now = os.clock()
    if now <= clutterBurstUntil then
        clutterBurstUntil = now + CLUTTER_BURST_SECONDS
        removeLocalDebris(descendant)
        return
    end
    if now - clutterWindowStarted > CLUTTER_WINDOW_SECONDS then
        clutterWindowStarted = now
        table.clear(recentClutter)
    end
    if #recentClutter < CLUTTER_THRESHOLD then
        table.insert(recentClutter, descendant)
    end
    if #recentClutter >= CLUTTER_THRESHOLD then
        clutterBurstUntil = now + CLUTTER_BURST_SECONDS
        for _, part in ipairs(recentClutter) do
            removeLocalDebris(part)
        end
        table.clear(recentClutter)
        setStatus("Client Anti-Lag: filtering new clutter locally")
    end
end

antiLagButton.MouseButton1Click:Connect(function()
    if clientAntiLagEnabled then
        stopClientAntiLag("Client Anti-Lag disabled; " .. locallyRemoved
            .. " parts removed locally this session")
        return
    end
    if otherPlayerCount() == 0 then
        setStatus("Client Anti-Lag: alone in server, nothing to filter")
        return
    end
    locallyRemoved = 0
    clutterWindowStarted = os.clock()
    clutterBurstUntil = 0
    table.clear(recentClutter)
    clientAntiLagEnabled = true
    antiLagButton.Text = "Client Anti-Lag: ON"
    clientAntiLagConnection = workspace.DescendantAdded:Connect(observeLocalDebris)
    setStatus("Client Anti-Lag: watching new generic building parts")
end)

-- Automatically stop when everyone except this client has left the server.
track(Players.PlayerRemoving, function(leaving)
    if clientAntiLagEnabled and otherPlayerCount(leaving) == 0 then
        stopClientAntiLag("Client Anti-Lag stopped: everyone else left")
    end
end)

-- Exploits
local RunService = game:GetService("RunService")
local exploitEnabled = {
    Fly = false,
    Noclip = false,
    InfiniteJump = false,
    PlayerESP = false,
    ClickTP = false,
    AntiFling = false,
    WorkspaceHelper = false
}
local exploitButtons = {}
local flyBody = nil
local flyRoot = nil
local flyUpHeld = false
local flyDownHeld = false
local flySpeed = 48
local collisionStates = {}
local espHighlights = {}

label("EXPLOITS", exploits,
    UDim2.fromOffset(13, 10), UDim2.new(1, -26, 0, 24), 16, true)
label("Local movement and visibility tools. Server checks may override them.",
    exploits, UDim2.fromOffset(13, 38), UDim2.new(1, -26, 0, 34), 12)

local flyUpButton = makeButton("UP", gui,
    UDim2.new(1, -66, 0.5, -70), UDim2.fromOffset(54, 48))
local flyDownButton = makeButton("DOWN", gui,
    UDim2.new(1, -66, 0.5, -15), UDim2.fromOffset(54, 48))
flyUpButton.Visible = false
flyDownButton.Visible = false

local function bindHold(button, setter)
    track(button.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
            setter(true)
        end
    end)
    track(button.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
            setter(false)
        end
    end)
end
bindHold(flyUpButton, function(value) flyUpHeld = value end)
bindHold(flyDownButton, function(value) flyDownHeld = value end)

local function stopFly()
    exploitEnabled.Fly = false
    if flyBody then flyBody:Destroy() flyBody = nil end
    flyRoot = nil
    flyUpHeld, flyDownHeld = false, false
    flyUpButton.Visible = false
    flyDownButton.Visible = false
    if exploitButtons.Fly then exploitButtons.Fly.Text = "Fly: OFF" end
end

local function startFly()
    local character = localPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = ownHumanoid()
    if not root or not humanoid then
        setStatus("Fly requires a spawned character")
        return false
    end
    stopFly()
    flyRoot = root
    flyBody = create("BodyVelocity", {
        Name = "FIO_Fly",
        MaxForce = Vector3.new(1e7, 1e7, 1e7),
        P = 7500,
        Velocity = Vector3.zero
    }, root)
    exploitEnabled.Fly = true
    flyUpButton.Visible = true
    flyDownButton.Visible = true
    return true
end

local function stopNoclip()
    exploitEnabled.Noclip = false
    for part, original in pairs(collisionStates) do
        if part and part.Parent then part.CanCollide = original end
        collisionStates[part] = nil
    end
end

local function clearEsp()
    exploitEnabled.PlayerESP = false
    for player, highlight in pairs(espHighlights) do
        if highlight then highlight:Destroy() end
        espHighlights[player] = nil
    end
end

local function refreshEsp()
    if not exploitEnabled.PlayerESP then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local character = player.Character
            local old = espHighlights[player]
            if old and (not old.Parent or old.Adornee ~= character) then
                old:Destroy()
                espHighlights[player] = nil
            end
            if character and not espHighlights[player] then
                local highlight = create("Highlight", {
                    Name = "FIO_PlayerESP",
                    FillColor = Color3.fromRGB(255, 200, 50),
                    OutlineColor = Color3.fromRGB(255, 255, 255),
                    FillTransparency = 0.75,
                    OutlineTransparency = 0,
                    DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
                    Adornee = character
                }, character)
                espHighlights[player] = highlight
            end
        end
    end
    for player, highlight in pairs(espHighlights) do
        if not player.Parent then
            highlight:Destroy()
            espHighlights[player] = nil
        end
    end
end

-- Workspace Helper is an editable toggle backed by workspace_helper_custom.lua.
-- No workspace spawning or network remotes are implemented by the hub itself.
local workspaceHelperModule = nil
local workspaceHelperSource =
    "https://raw.githubusercontent.com/KoSmoXD/fio/feat/fio-hub-starter/workspace_helper_custom.lua"

local function setWorkspaceHelper(shouldEnable)
    local context = {setStatus = setStatus}
    if shouldEnable then
        if workspaceHelperModule then return true end
        local ok, result = pcall(function()
            local source = game:HttpGet(workspaceHelperSource)
            local compiled, compileError = loadstring(source)
            if not compiled then
                error("custom feature compile failed: " .. tostring(compileError))
            end
            local module = compiled()
            if type(module) ~= "table"
                or type(module.Enable) ~= "function"
                or type(module.Disable) ~= "function" then
                error("expected module with Enable(context) and Disable(context)")
            end
            return module
        end)
        if not ok then
            setStatus("Workspace Helper load failed: " .. tostring(result):sub(1, 105))
            return false
        end
        local enabled, enableError = pcall(result.Enable, context)
        if not enabled then
            pcall(result.Disable, context)
            setStatus("Workspace Helper error: " .. tostring(enableError):sub(1, 105))
            return false
        end
        workspaceHelperModule = result
        return true
    end

    if workspaceHelperModule then
        local module = workspaceHelperModule
        workspaceHelperModule = nil
        local ok, err = pcall(module.Disable, context)
        if not ok then
            setStatus("Workspace Helper cleanup error: " .. tostring(err):sub(1, 105))
        end
    end
    return false
end

local featureNames = {
    {"Fly", "Fly"},
    {"Noclip", "Noclip"},
    {"InfiniteJump", "Infinite jump"},
    {"PlayerESP", "Player ESP"},
    {"ClickTP", "Click teleport"},
    {"AntiFling", "Anti-fling"},
    {"WorkspaceHelper", "Workspace Helper"}
}
for index, feature in ipairs(featureNames) do
    local key, display = feature[1], feature[2]
    local rowNumber = math.floor((index - 1) / 2)
    local colNumber = (index - 1) % 2
    local button = makeButton(display .. ": OFF", exploits,
        UDim2.new(colNumber * 0.5, 13 + colNumber * 3, 0, 73 + rowNumber * 42),
        UDim2.new(0.5, -22, 0, 36))
    exploitButtons[key] = button
    if key == "WorkspaceHelper" then
        button.TextSize = 11
        button.TextWrapped = true
    end
    button.MouseButton1Click:Connect(function()
        local newValue = not exploitEnabled[key]
        if key == "Fly" then
            if newValue then
                newValue = startFly()
            else
                stopFly()
            end
        elseif key == "WorkspaceHelper" then
            newValue = setWorkspaceHelper(newValue)
        elseif key == "Noclip" and not newValue then
            stopNoclip()
        elseif key == "PlayerESP" then
            if newValue then
                exploitEnabled.PlayerESP = true
                refreshEsp()
            else
                clearEsp()
            end
        end
        exploitEnabled[key] = newValue
        button.Text = display .. (newValue and ": ON" or ": OFF")
        if newValue or key ~= "Fly" then setStatus(button.Text) end
    end)
end
label("Fly: WASD/joystick, E/Space up, Q down. Mobile: UP/DOWN.",
    exploits, UDim2.fromOffset(13, 238), UDim2.new(1, -26, 0, 26), 11)

track(RunService.Heartbeat, function()
    if exploitEnabled.Fly then
        local humanoid = ownHumanoid()
        if not flyBody or not flyBody.Parent or not flyRoot or not flyRoot.Parent
            or not humanoid then
            stopFly()
        else
            local rising = flyUpHeld
                or UserInputService:IsKeyDown(Enum.KeyCode.E)
                or UserInputService:IsKeyDown(Enum.KeyCode.Space)
            local falling = flyDownHeld
                or UserInputService:IsKeyDown(Enum.KeyCode.Q)
            local vertical = (rising and 1 or 0) - (falling and 1 or 0)
            flyBody.Velocity = humanoid.MoveDirection * flySpeed
                + Vector3.new(0, vertical * flySpeed, 0)
        end
    end
    if exploitEnabled.AntiFling then
        local character = localPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if root and root.AssemblyLinearVelocity.Magnitude > 120 then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end
end)

track(RunService.Stepped, function()
    if not exploitEnabled.Noclip then return end
    local character = localPlayer.Character
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            if collisionStates[part] == nil then
                collisionStates[part] = part.CanCollide
            end
            part.CanCollide = false
        end
    end
end)

track(UserInputService.JumpRequest, function()
    if not exploitEnabled.InfiniteJump then return end
    local humanoid = ownHumanoid()
    if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

track(UserInputService.InputBegan, function(input, processed)
    if processed or not exploitEnabled.ClickTP then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local camera = workspace.CurrentCamera
    local character = localPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not camera or not root then return end
    local ray = camera:ViewportPointToRay(input.Position.X, input.Position.Y)
    local parameters = RaycastParams.new()
    parameters.FilterType = Enum.RaycastFilterType.Exclude
    parameters.FilterDescendantsInstances = {character}
    local result = workspace:Raycast(ray.Origin, ray.Direction * 1500, parameters)
    if result then
        local originalRotation = root.CFrame - root.Position
        root.CFrame = CFrame.new(result.Position + Vector3.new(0, 3.5, 0))
            * originalRotation
        setStatus("Local click teleport attempted")
    end
end)

local espAccumulator = 0
track(RunService.Heartbeat, function(dt)
    espAccumulator = espAccumulator + dt
    if espAccumulator >= 1 then
        espAccumulator = 0
        refreshEsp()
    end
end)
track(localPlayer.CharacterRemoving, function()
    if exploitEnabled.Fly then stopFly() end
    if exploitEnabled.Noclip then stopNoclip() end
end)

local function stopExploits()
    setWorkspaceHelper(false)
    exploitEnabled.WorkspaceHelper = false
    stopFly()
    stopNoclip()
    clearEsp()
    exploitEnabled.InfiniteJump = false
    exploitEnabled.ClickTP = false
    exploitEnabled.AntiFling = false
end


-- BTools integrations (F3X-compatible endpoints only).
-- These actions never bypass the game's server-side edit permissions.
local antiJail = false
local killTouch = false
local glitchTitle = false
local touchConnections = {}
local touchCharacterConnection = nil
local touchCooldowns = {}
local titleBillboard = nil
local titleGeneration = 0
local jailBusy = false

label("BTOOLS / F3X", btools, UDim2.fromOffset(13, 10),
    UDim2.new(1, -26, 0, 23), 16, true)
label("Requires equipped server-authorized BTools. Some game objects may be protected.",
    btools, UDim2.fromOffset(13, 33),
    UDim2.new(1, -26, 0, 42), 12)
local btoolStatus = label("BTools: not checked", btools,
    UDim2.fromOffset(13, 76), UDim2.new(1, -26, 0, 21), 12)

local function findBtools()
    local character = localPlayer.Character
    local backpack = localPlayer:FindFirstChildOfClass("Backpack")
    for _, location in ipairs({character or false, backpack or false}) do
        if location then
            for _, item in ipairs(location:GetChildren()) do
                if item:IsA("Tool") then
                    local api = item:FindFirstChild("SyncAPI", true)
                    local endpoint = api and api:FindFirstChild("ServerEndpoint", true)
                    if endpoint and endpoint:IsA("RemoteFunction") then
                        return item, endpoint
                    end
                end
            end
        end
    end
    return nil, nil
end

local function getEquippedBtools()
    local tool, endpoint = findBtools()
    if not endpoint then
        btoolStatus.Text = "BTools: F3X SyncAPI not found"
        setStatus("Equip server-authorized F3X BTools first")
        return nil
    end
    local character = localPlayer.Character
    if not character or tool.Parent ~= character then
        local humanoid = ownHumanoid()
        if not humanoid then
            setStatus("Cannot equip BTools without a character")
            return nil
        end
        humanoid:EquipTool(tool)
    end
    if tool.Parent ~= localPlayer.Character then
        setStatus("BTools must be equipped")
        return nil
    end
    btoolStatus.Text = "BTools: equipped (authorization unverified)"
    return endpoint
end

local function callBtools(action, payload)
    local endpoint = getEquippedBtools()
    if not endpoint then return false end
    local ok, err = pcall(function()
        endpoint:InvokeServer(action, payload)
    end)
    if not ok then
        setStatus("BTools request failed: " .. tostring(err):sub(1, 80))
    end
    -- A successful remote invocation is not proof that the server accepted it.
    return ok
end

local function belongsToPlayer(part)
    local ancestor = part
    while ancestor and ancestor ~= workspace do
        if ancestor:IsA("Model") and Players:GetPlayerFromCharacter(ancestor) then
            return true
        end
        ancestor = ancestor.Parent
    end
    return false
end

local function isJailPart(part)
    local ancestor = part
    local depth = 0
    while ancestor and ancestor ~= workspace and depth < 5 do
        local name = ancestor.Name:lower()
        if name:find("jail", 1, true)
            or name:find("prison", 1, true)
            or name:find("cage", 1, true)
            or name:find("cell", 1, true) then
            return true
        end
        ancestor = ancestor.Parent
        depth += 1
    end
    return false
end

local function removeNearbyJail()
    if jailBusy or not antiJail then return end
    local character = localPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local endpoint = getEquippedBtools()
    if not endpoint then return end
    jailBusy = true
    local ok, err = pcall(function()
        local overlap = OverlapParams.new()
        overlap.FilterType = Enum.RaycastFilterType.Exclude
        overlap.FilterDescendantsInstances = {character}
        overlap.MaxParts = 150
        local nearby = workspace:GetPartBoundsInRadius(root.Position, 22, overlap)
        local targets = {}
        for _, part in ipairs(nearby) do
            if #targets >= 30 then break end
            if part:IsA("BasePart") and not belongsToPlayer(part) and isJailPart(part) then
                table.insert(targets, part)
            end
        end
        if #targets > 0 then
            -- Deliberately limited to named jail parts near your own character.
            endpoint:InvokeServer("Remove", targets)
            task.wait(0.25)
            local remaining = 0
            for _, part in ipairs(targets) do
                if part:IsDescendantOf(workspace) then remaining += 1 end
            end
            setStatus("Anti Jail: " .. (#targets - remaining) ..
                "/" .. #targets .. " nearby jail parts removed")
        end
    end)
    jailBusy = false
    if not ok then setStatus("Anti Jail error: " .. tostring(err):sub(1, 80)) end
end

local function disconnectTouches()
    for _, connection in ipairs(touchConnections) do
        connection:Disconnect()
    end
    table.clear(touchConnections)
    if touchCharacterConnection then
        touchCharacterConnection:Disconnect()
        touchCharacterConnection = nil
    end
end

local function onKillTouch(other)
    if not killTouch or not other:IsA("BasePart") then return end
    local model = other
    local target = nil
    while model and model ~= workspace do
        if model:IsA("Model") then
            target = Players:GetPlayerFromCharacter(model)
            if target then break end
        end
        model = model.Parent
    end
    if not target or target == localPlayer then return end
    local now = os.clock()
    if touchCooldowns[target] and now - touchCooldowns[target] < 4 then return end
    touchCooldowns[target] = now
    local head = model:FindFirstChild("Head")
    if not head or not head:IsA("BasePart") then return end
    task.spawn(function()
        if not killTouch then return end
        if callBtools("Remove", {head}) then
            task.wait(0.25)
            if not killTouch then return end
            if head:IsDescendantOf(workspace) then
                setStatus("Kill Touch: server did not remove @" .. target.Name .. "'s head")
            else
                setStatus("Kill Touch: removed head of @" .. target.Name)
            end
        end
    end)
end

local function bindTouchCharacter(character)
    disconnectTouches()
    if not killTouch then return end
    local function bindPart(descendant)
        if not descendant:IsA("BasePart")
            or descendant:FindFirstAncestorOfClass("Accessory") then return end
        table.insert(touchConnections, descendant.Touched:Connect(onKillTouch))
    end
    for _, descendant in ipairs(character:GetDescendants()) do bindPart(descendant) end
    touchCharacterConnection = character.DescendantAdded:Connect(bindPart)
end

local function stopGlitchTitle()
    glitchTitle = false
    titleGeneration += 1
    if titleBillboard then titleBillboard:Destroy() titleBillboard = nil end
end

local function startGlitchTitle()
    local head = localPlayer.Character and localPlayer.Character:FindFirstChild("Head")
    if not head then
        setStatus("Glitchy Title: character head unavailable")
        return false
    end
    stopGlitchTitle()
    glitchTitle = true
    titleGeneration += 1
    local generation = titleGeneration
    titleBillboard = create("BillboardGui", {
        Name = "FIO_GlitchTitle",
        Size = UDim2.fromOffset(250, 45),
        StudsOffsetWorldSpace = Vector3.new(0, 3.2, 0),
        AlwaysOnTop = true,
        Adornee = head
    }, head)
    local textObject = create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Text = "",
        TextScaled = true,
        TextStrokeTransparency = 0.25,
        Font = Enum.Font.GothamBold,
        TextColor3 = WHITE
    }, titleBillboard)
    local frames = {"OWNER??", "0WN3R", "O W N E R", "#ERROR", "OWNER //", "0\u0338W\u0338N\u0338E\u0338R"}
    task.spawn(function()
        local count = 0
        while glitchTitle and titleGeneration == generation
            and textObject.Parent and head.Parent do
            count += 1
            textObject.Text = frames[(count % #frames) + 1]
            textObject.Rotation = (count % 3 - 1) * 3
            textObject.TextColor3 = count % 2 == 0 and WHITE
                or Color3.fromRGB(140, 225, 255)
            task.wait(0.16)
        end
    end)
    setStatus("Glitchy Title enabled (local visual only)")
    return true
end

local antiJailButton = makeButton("Anti Jail: OFF", btools,
    UDim2.fromOffset(13, 108), UDim2.new(1, -26, 0, 37))
local killTouchButton = makeButton("Kill Touch: OFF", btools,
    UDim2.fromOffset(13, 153), UDim2.new(1, -26, 0, 37))
local glitchTitleButton = makeButton("Glitchy Title: OFF", btools,
    UDim2.fromOffset(13, 198), UDim2.new(1, -26, 0, 37))
antiJailButton.MouseButton1Click:Connect(function()
    if not antiJail and not getEquippedBtools() then return end
    antiJail = not antiJail
    antiJailButton.Text = "Anti Jail: " .. (antiJail and "ON" or "OFF")
    setStatus(antiJail and "Anti Jail: watching for nearby jail objects" or "Anti Jail disabled")
    if antiJail then task.spawn(removeNearbyJail) end
end)
killTouchButton.MouseButton1Click:Connect(function()
    if not killTouch and not getEquippedBtools() then return end
    killTouch = not killTouch
    killTouchButton.Text = "Kill Touch: " .. (killTouch and "ON" or "OFF")
    if killTouch then
        if localPlayer.Character then bindTouchCharacter(localPlayer.Character) end
        setStatus("Kill Touch: removing touched players' heads if authorized")
    else
        disconnectTouches()
        setStatus("Kill Touch disabled")
    end
end)
glitchTitleButton.MouseButton1Click:Connect(function()
    if not glitchTitle then
        if not getEquippedBtools() then return end
        if startGlitchTitle() then glitchTitleButton.Text = "Glitchy Title: ON" end
    else
        stopGlitchTitle()
        glitchTitleButton.Text = "Glitchy Title: OFF"
        setStatus("Glitchy Title disabled")
    end
end)

label("Anti Jail / Kill Touch: server permission required.\nTitle: cosmetic and visible only to you.",
    btools, UDim2.fromOffset(13, 235), UDim2.new(1, -26, 0, 26), 11)

local jailElapsed = 0
track(RunService.Heartbeat, function(dt)
    if not antiJail then return end
    jailElapsed += dt
    if jailElapsed >= 1.7 then
        jailElapsed = 0
        task.spawn(removeNearbyJail)
    end
end)
track(localPlayer.CharacterAdded, function(character)
    if killTouch then bindTouchCharacter(character) end
    if glitchTitle then
        stopGlitchTitle()
        glitchTitleButton.Text = "Glitchy Title: OFF"
        setStatus("Glitchy Title stopped on respawn; re-enable when ready")
    end
end)

local function stopBtools()
    antiJail = false
    killTouch = false
    disconnectTouches()
    stopGlitchTitle()
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
    stopExploits()
    stopBtools()
    stopClientAntiLag()
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
environment.FIO_HUB = {Destroy = destroy, Version = "0.5.0"}
unloadButton.MouseButton1Click:Connect(destroy)
showTab("Home")
print("[FIO] Hub v0.5.0 loaded")
