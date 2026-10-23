-- First Is Owner | visible diagnostic loader
-- Use this loader to show fetch, compile and execution errors on screen.
local Players = game:GetService("Players")
local player = Players.LocalPlayer
if not player then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    player = Players.LocalPlayer
end
if not player then
    warn("[FIO] LocalPlayer unavailable; start the loader in the Roblox client.")
    return
end

local playerGui = player:WaitForChild("PlayerGui", 20)
if not playerGui then
    warn("[FIO] PlayerGui unavailable after 20 seconds.")
    return
end

local previous = playerGui:FindFirstChild("FIO_Loader")
if previous then previous:Destroy() end

local function make(class, props, parent)
    local instance = Instance.new(class)
    for key, value in pairs(props) do instance[key] = value end
    instance.Parent = parent
    return instance
end

local gui = make("ScreenGui", {
    Name = "FIO_Loader",
    ResetOnSpawn = false,
    DisplayOrder = 10000,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)
local frame = make("Frame", {
    Name = "StatusPanel",
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0.08, 0),
    Size = UDim2.new(0.9, 0, 0, 154),
    BorderSizePixel = 1,
    BorderColor3 = Color3.fromRGB(85, 110, 160),
    BackgroundColor3 = Color3.fromRGB(26, 29, 35),
}, gui)
make("UISizeConstraint", {
    MinSize = Vector2.new(250, 154),
    MaxSize = Vector2.new(550, 154),
}, frame)
make("TextLabel", {
    Size = UDim2.new(1, -14, 0, 29),
    Position = UDim2.fromOffset(8, 5),
    BackgroundTransparency = 1,
    Text = "FIO HUB — DIAGNOSTIC LOADER",
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.Code,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(240, 240, 240),
}, frame)
local status = make("TextLabel", {
    Size = UDim2.new(1, -20, 0, 67),
    Position = UDim2.fromOffset(10, 38),
    BackgroundTransparency = 1,
    Text = "Preparing...",
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    Font = Enum.Font.Code,
    TextSize = 13,
    TextColor3 = Color3.fromRGB(230, 225, 190),
}, frame)
local retry = make("TextButton", {
    Position = UDim2.new(0, 10, 1, -40),
    Size = UDim2.new(0.58, -15, 0, 32),
    Text = "Retry",
    Font = Enum.Font.Code,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundColor3 = Color3.fromRGB(42, 85, 152),
    BorderSizePixel = 0,
}, frame)
local close = make("TextButton", {
    Position = UDim2.new(0.58, 0, 1, -40),
    Size = UDim2.new(0.42, -10, 0, 32),
    Text = "Dismiss",
    Font = Enum.Font.Code,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundColor3 = Color3.fromRGB(74, 77, 84),
    BorderSizePixel = 0,
}, frame)

local HUB_URL = "https://raw.githubusercontent.com/KoSmoXD/fio/feat/fio-hub-starter/fio.lua"
local busy = false
local function boot()
    if busy or not gui.Parent then return end
    busy = true
    retry.Text = "Loading..."
    status.Text = "Fetching fio.lua..."
    local ok, result = pcall(function()
        local source = game:HttpGet(HUB_URL)
        if type(source) ~= "string" or #source < 200 then
            error("GitHub returned empty or unexpected script content.")
        end
        status.Text = "Compiling fio.lua..."
        if type(loadstring) ~= "function" then
            error("This Lua environment does not provide loadstring.")
        end
        local chunk, compileError = loadstring(source)
        if not chunk then error("Luau compile error: " .. tostring(compileError)) end

        status.Text = "Running fio.lua..."
        chunk()
        local existing = playerGui:FindFirstChild("FIO_Hub")
        if not existing or not existing:FindFirstChild("Window") then
            error("fio.lua returned without creating the hub window.")
        end
        status.Text = "FIO Hub loaded successfully."
    end)
    busy = false
    retry.Text = "Retry"
    if ok then
        print("[FIO] Diagnostic loader: hub started")
        task.wait(1)
        if gui.Parent then gui:Destroy() end
    else
        status.TextColor3 = Color3.fromRGB(255, 150, 150)
        status.Text = tostring(result):sub(1, 400)
        warn("[FIO] " .. tostring(result))
    end
end

retry.MouseButton1Click:Connect(function()
    status.TextColor3 = Color3.fromRGB(230, 225, 190)
    task.spawn(boot)
end)
close.MouseButton1Click:Connect(function() gui:Destroy() end)
task.spawn(boot)
