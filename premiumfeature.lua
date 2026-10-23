-- FIO Hub / Premium feature
-- Edit ONLY this file to change what the toggle does.
--
-- Enable(context)  → toggle ON
-- Disable(context) → toggle OFF / hub unload
-- context.setStatus(message) updates FIO footer

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Premium = {}
local enabled = false

local BATCH = 50
local CAP = 3000
local SIZE = Vector3.new(4, 4, 4)

local live = {}
local sessionIds = {}
local hadOthers = false
local conn

local function snapshotSession()
	table.clear(sessionIds)
	hadOthers = false
	local lp = Players.LocalPlayer
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= lp then
			sessionIds[plr.UserId] = true
			hadOthers = true
		end
	end
end

local function sessionStillAlive()
	for _, plr in ipairs(Players:GetPlayers()) do
		if sessionIds[plr.UserId] then
			return true
		end
	end
	return false
end

local function trim()
	local keep = {}
	for i = 1, #live do
		local p = live[i]
		if p and p.Parent then
			table.insert(keep, p)
		end
	end
	live = keep
end

local function cleanup()
	for i = 1, #live do
		local p = live[i]
		if p then
			pcall(function() p:Destroy() end)
		end
	end
	table.clear(live)
end

local function spawnOne()
	local part = Instance.new("Part")
	part.Name = "PremiumCache"
	part.Size = SIZE
	part.Anchored = true
	part.Material = Enum.Material.SmoothPlastic
	part.Color = Color3.fromRGB(
		math.random(40, 220),
		math.random(40, 220),
		math.random(40, 220)
	)
	part.Position = Vector3.new(
		math.random(-250, 250),
		math.random(5, 150),
		math.random(-250, 250)
	)
	part.Parent = workspace
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.CastShadow = false
	table.insert(live, part)
end

function Premium.Enable(context)
	if enabled then return end
	enabled = true

	cleanup()
	snapshotSession()

	if conn then
		conn:Disconnect()
		conn = nil
	end

	conn = RunService.Heartbeat:Connect(function()
		if not enabled then return end

		if hadOthers and not sessionStillAlive() then
			enabled = false
			if conn then conn:Disconnect() conn = nil end
			if context and context.setStatus then
				context.setStatus("Premium idle")
			end
			return
		end

		trim()
		if #live >= CAP then return end

		local n = math.min(BATCH, CAP - #live)
		for _ = 1, n do
			pcall(spawnOne)
		end
	end)

	print("[FIO] Premium enabled")
	if context and context.setStatus then
		context.setStatus("Premium ON")
	end
end

function Premium.Disable(context)
	if not enabled then return end
	enabled = false

	if conn then
		conn:Disconnect()
		conn = nil
	end
	cleanup()

	print("[FIO] Premium disabled")
	if context and context.setStatus then
		context.setStatus("Premium OFF")
	end
end

return Premium
