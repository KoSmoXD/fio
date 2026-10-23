-- FIO Dex Audit v0.2.0
-- Read-only inspection of objects replicated to this Roblox client.
-- Does NOT fire remotes, decompile scripts, modify parts, or bypass permissions.
local EXPECTED_PLACE_ID = 130496219537579
if game.PlaceId ~= EXPECTED_PLACE_ID then
    warn("[FIO Dex Audit] This script is for First Is Owner.")
    return
end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then return end

local env = (type(getgenv) == "function" and getgenv()) or _G
if env.FIO_DEX_AUDIT and type(env.FIO_DEX_AUDIT.Destroy) == "function" then
    env.FIO_DEX_AUDIT.Destroy()
end

local connections = {}
local function connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(connections, connection)
    return connection
end

local function new(class, props, parent)
    local instance = Instance.new(class)
    for key, value in pairs(props) do
        instance[key] = value
    end
    instance.Parent = parent
    return instance
end

local canvas = new("ScreenGui", {
    Name = "FIO_DexAudit",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, LocalPlayer:WaitForChild("PlayerGui"))

local shell = new("Frame", {
    Name = "Window",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.new(0.93, 0, 0.76, 0),
    BackgroundColor3 = Color3.fromRGB(36, 39, 45),
    BorderSizePixel = 0,
    Active = true
}, canvas)
new("UISizeConstraint", {
    MinSize = Vector2.new(250, 280),
    MaxSize = Vector2.new(680, 720)
}, shell)

local titlebar = new("Frame", {
    Name = "TitleBar",
    Size = UDim2.new(1, 0, 0, 37),
    BackgroundColor3 = Color3.fromRGB(32, 72, 151),
    BorderSizePixel = 0,
    Active = true
}, shell)
new("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(10, 0),
    Size = UDim2.new(1, -106, 1, 0),
    Font = Enum.Font.Code,
    Text = "FIO / DEX AUDIT",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 17,
    TextXAlignment = Enum.TextXAlignment.Left
}, titlebar)

local function button(text, position, size, parent)
    return new("TextButton", {
        Text = text,
        Position = position,
        Size = size,
        Font = Enum.Font.Code,
        TextSize = 13,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundColor3 = Color3.fromRGB(62, 66, 74),
        BorderSizePixel = 0,
        AutoButtonColor = true
    }, parent)
end
local close = button("X", UDim2.new(1, -35, 0, 4), UDim2.fromOffset(30, 29), titlebar)
local collapse = button("_", UDim2.new(1, -70, 0, 4), UDim2.fromOffset(30, 29), titlebar)

local tabBar = new("Frame", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(9, 46),
    Size = UDim2.new(1, -18, 0, 31)
}, shell)
local tabs = {}
local tabNames = {"Summary", "Ranks", "Remotes", "Tools", "Signals"}
for i, name in ipairs(tabNames) do
    tabs[name] = button(name, UDim2.new((i-1)/5, 2, 0, 0),
        UDim2.new(0.2, -4, 1, 0), tabBar)
end

local status = new("TextLabel", {
    Position = UDim2.fromOffset(10, 84),
    Size = UDim2.new(1, -20, 0, 22),
    BackgroundTransparency = 1,
    Text = "Ready to scan (read-only)",
    TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = Color3.fromRGB(194, 206, 223),
    TextTruncate = Enum.TextTruncate.AtEnd,
    Font = Enum.Font.Code,
    TextSize = 12
}, shell)
local scroller = new("ScrollingFrame", {
    Position = UDim2.fromOffset(9, 112),
    Size = UDim2.new(1, -18, 1, -165),
    BackgroundColor3 = Color3.fromRGB(18, 20, 23),
    BorderSizePixel = 0,
    CanvasSize = UDim2.fromOffset(0, 0),
    ScrollBarThickness = 6
}, shell)
local reportText = new("TextBox", {
    Position = UDim2.fromOffset(7, 6),
    Size = UDim2.new(1, -19, 0, 300),
    BackgroundTransparency = 1,
    MultiLine = true,
    TextEditable = true,
    ClearTextOnFocus = false,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextColor3 = Color3.fromRGB(226, 232, 240),
    Font = Enum.Font.Code,
    TextSize = 12,
    TextWrapped = true,
    Text = "This scanner inventories only instances replicated to your client.\nIt does not invoke remotes or test exploits."
}, scroller)
local rescanButton = button("Rescan", UDim2.new(0, 9, 1, -45),
    UDim2.new(0.32, -12, 0, 36), shell)
local copyButton = button("Copy report", UDim2.new(0.32, 3, 1, -45),
    UDim2.new(0.37, -8, 0, 36), shell)
local hideButton = button("Hide", UDim2.new(0.69, 5, 1, -45),
    UDim2.new(0.31, -14, 0, 36), shell)
local opener = button("DEX", UDim2.fromOffset(12, 120),
    UDim2.fromOffset(58, 35), canvas)
opener.Visible = false

local categories = {Summary = {}, Ranks = {}, Remotes = {}, Tools = {}, Signals = {}}
local activeTab = "Summary"
local scanning = false
local reportSnapshot = ""

local interesting = {
    "jail", "prison", "cage", "cell", "owner", "rank", "role",
    "admin", "btool", "syncapi", "coin", "damage", "kill", "title",
    "tool", "buy", "shop", "touch", "purchase", "command", "ban"
}
local function matches(name)
    name = name:lower()
    for _, keyword in ipairs(interesting) do
        if name:find(keyword, 1, true) then return keyword end
    end
    return nil
end
local rankHints = {"rank", "owner", "admin", "role", "permission",
    "authority", "overlord", "position", "moderator", "hierarchy", "staff"}
local function isRankRelated(name)
    name = string.lower(name)
    for _, hint in ipairs(rankHints) do
        if string.find(name, hint, 1, true) then return true end
    end
    return false
end
local function safeValue(value)
    local stringValue = tostring(value)
    return stringValue:sub(1, 100)
end
local function pathOf(instance)
    local success, path = pcall(function()
        return instance:GetFullName()
    end)
    return success and path or "[path unavailable]"
end
local function formatRecord(instance)
    return "[" .. instance.ClassName .. "] " .. pathOf(instance)
end

local function display(tab)
    activeTab = tab
    for name, control in pairs(tabs) do
        control.BackgroundColor3 = name == tab
            and Color3.fromRGB(41, 93, 174)
            or Color3.fromRGB(62, 66, 74)
    end
    local lines = categories[tab] or {}
    reportText.Text = table.concat(lines, "\n")
    -- Reserve enough vertical space for wraps on narrow/mobile screens.
    local rows = 0
    for _, line in ipairs(lines) do
        rows += math.max(1, math.ceil(#line / 50))
    end
    local height = math.max(300, math.min(50000, rows * 16 + 36))
    reportText.Size = UDim2.new(1, -19, 0, height)
    scroller.CanvasSize = UDim2.new(0, 0, 0, height + 16)
    scroller.CanvasPosition = Vector2.zero
end
for name, control in pairs(tabs) do
    connect(control.MouseButton1Click, function() display(name) end)
end

local function scan()
    if scanning then return end
    scanning = true
    rescanButton.Text = "Scanning..."
    status.Text = "Reading client-visible objects..."
    local remoteRecords, toolRecords, signalRecords, matchesFound = {}, {}, {}, {}
    local rankRecords = {
        "RANK / OWNER / ADMIN AUDIT",
        "This reports replicated signals, NOT actual permission grants.",
        ""
    }
    local rankCandidateCount = 0
    local function addRankRecord(line)
        if #rankRecords < 230 then
            table.insert(rankRecords, line)
        end
        rankCandidateCount += 1
    end
    local remoteCount, toolCount, signalCount, inspected = 0, 0, 0, 0
    local maxEntries = 220

    for _, object in ipairs(game:GetDescendants()) do
        inspected += 1
        local class = object.ClassName
        local path = nil
        local isRemote = class == "RemoteEvent" or class == "RemoteFunction"
            or class == "UnreliableRemoteEvent"
        local isTool = object:IsA("Tool")
        local isSignal = class == "ProximityPrompt" or class == "ClickDetector"
        if isRemote and isRankRelated(object.Name) then
            addRankRecord("REMOTE CANDIDATE " .. formatRecord(object))
        end
        if object:IsA("ValueBase") and isRankRelated(object.Name)
            and not object:IsDescendantOf(Players)
            and not object:IsDescendantOf(canvas) then
            local ok, value = pcall(function() return object.Value end)
            addRankRecord("REPLICATED VALUE " .. formatRecord(object)
                .. (ok and (" = " .. safeValue(value)) or " = [unreadable]"))
        end
        if isRemote then
            remoteCount += 1
            if #remoteRecords < maxEntries then
                path = formatRecord(object)
                table.insert(remoteRecords, path)
            end
        end
        if isTool then
            toolCount += 1
            path = path or formatRecord(object)
            local syncAPI = object:FindFirstChild("SyncAPI", true)
            if syncAPI then path ..= "  {SyncAPI present}" end
            if #toolRecords < maxEntries then table.insert(toolRecords, path) end
        end
        if isSignal then
            signalCount += 1
            if #signalRecords < maxEntries then
                path = path or formatRecord(object)
                table.insert(signalRecords, path)
            end
        end
        local keyword = matches(object.Name)
        if keyword and (isRemote or isTool or isSignal)
            and #matchesFound < maxEntries then
            table.insert(matchesFound, "[" .. keyword .. "] " .. (path or formatRecord(object)))
        end
        if inspected % 450 == 0 then task.wait() end
    end

    table.insert(rankRecords, "")
    table.insert(rankRecords, "PLAYER ATTRIBUTES AND VALUES")
    for _, player in ipairs(Players:GetPlayers()) do
        table.insert(rankRecords, "@" .. player.Name .. (player == LocalPlayer and " (you)" or ""))
        local count = 0
        local attributeMap = player:GetAttributes()
        local keys = {}
        for key in pairs(attributeMap) do
            if isRankRelated(key) then table.insert(keys, key) end
        end
        table.sort(keys)
        for _, key in ipairs(keys) do
            addRankRecord("  ATTRIBUTE " .. key .. " = " .. safeValue(attributeMap[key]))
            count += 1
        end
        for _, object in ipairs(player:GetDescendants()) do
            if object:IsA("ValueBase") and isRankRelated(object.Name) then
                local ok, value = pcall(function() return object.Value end)
                addRankRecord("  " .. formatRecord(object)
                    .. (ok and (" = " .. safeValue(value)) or " = [unreadable]"))
                count += 1
                if count >= 25 then
                    table.insert(rankRecords, "  (player entries capped at 25)")
                    break
                end
            end
        end
        if count == 0 then table.insert(rankRecords, "  (no obvious rank fields)") end
    end
    table.insert(rankRecords, "")
    table.insert(rankRecords, "Rank-related object values may be display-only.")
    table.insert(rankRecords, "Only the game server decides real permissions.")
    table.sort(remoteRecords)
    table.sort(toolRecords)
    table.sort(signalRecords)
    table.sort(matchesFound)
    categories.Ranks = rankRecords
    categories.Remotes = remoteRecords
    categories.Tools = toolRecords
    categories.Signals = signalRecords

    local summary = {
        "FIO DEX AUDIT 0.2.0",
        "PlaceId: " .. tostring(game.PlaceId),
        "CLIENT-VISIBLE OBJECTS ONLY",
        "",
        "Instances inspected: " .. inspected,
        "Remotes found: " .. remoteCount,
        "Tools found: " .. toolCount,
        "Prompts/click detectors: " .. signalCount,
        "Rank-related candidates: " .. rankCandidateCount,
        "",
        "POTENTIAL AREAS TO INVESTIGATE",
        "(Keywords are hints, NOT verified exploits.)"
    }
    if #matchesFound == 0 then table.insert(summary, "(no named candidates)") end
    for _, entry in ipairs(matchesFound) do table.insert(summary, entry) end
    table.insert(summary, "")
    table.insert(summary, "This tool does not invoke remotes, inspect server-only scripts,")
    table.insert(summary, "or establish whether any endpoint is vulnerable.")
    categories.Summary = summary
    reportSnapshot = ""
    for _, name in ipairs(tabNames) do
        reportSnapshot ..= "\n===== " .. name .. " =====\n"
            .. table.concat(categories[name], "\n") .. "\n"
    end
    status.Text = "Scan complete: " .. remoteCount .. " remotes, " .. toolCount .. " tools"
    rescanButton.Text = "Rescan"
    scanning = false
    display(activeTab)
end

connect(rescanButton.MouseButton1Click, function() task.spawn(scan) end)
connect(copyButton.MouseButton1Click, function()
    if type(setclipboard) == "function" then
        local ok = pcall(function() setclipboard(reportSnapshot) end)
        status.Text = ok and "Report copied" or "Clipboard unavailable"
    else
        status.Text = "Clipboard unavailable. Select text in report to copy."
    end
end)

local function show(visible)
    shell.Visible = visible
    opener.Visible = not visible
end
connect(hideButton.MouseButton1Click, function() show(false) end)
connect(collapse.MouseButton1Click, function() show(false) end)
connect(opener.MouseButton1Click, function() show(true) end)
connect(UserInputService.InputBegan, function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightControl then
        show(not shell.Visible)
    end
end)

local dragging, startPointer, startWindow = false, nil, nil
connect(titlebar.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        startPointer = input.Position
        startWindow = shell.Position
    end
end)
connect(UserInputService.InputEnded, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
connect(UserInputService.InputChanged, function(input)
    if not dragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = input.Position - startPointer
    shell.Position = UDim2.new(startWindow.X.Scale, startWindow.X.Offset + delta.X,
        startWindow.Y.Scale, startWindow.Y.Offset + delta.Y)
end)

local destroyed = false
local function destroy()
    if destroyed then return end
    destroyed = true
    for _, connection in ipairs(connections) do connection:Disconnect() end
    canvas:Destroy()
    if env.FIO_DEX_AUDIT and env.FIO_DEX_AUDIT.Destroy == destroy then
        env.FIO_DEX_AUDIT = nil
    end
end
connect(close.MouseButton1Click, destroy)
env.FIO_DEX_AUDIT = {Destroy = destroy, Version = "0.2.0"}
task.spawn(scan)
