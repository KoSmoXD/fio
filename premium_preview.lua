-- FIO Premium Feature: bounded, client-only preview
-- Does not call BTools/remotes or create server-replicated parts.
-- Leave premiumfeature.lua unchanged; this is the module loaded by the UI.

local RunService = game:GetService("RunService")
local Premium = {}

local connection = nil
local folder = nil
local enabled = false
local elapsed = 0
local spawned = 0

local MAX_PARTS = 24
local SPAWN_INTERVAL = 0.45

local function cleanup()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    if folder then
        folder:Destroy()
        folder = nil
    end
    elapsed = 0
    spawned = 0
end

function Premium.Enable(context)
    if enabled then return end
    cleanup()

    enabled = true
    folder = Instance.new("Folder")
    folder.Name = "FIO_Premium_LocalPreview"
    folder.Parent = workspace

    connection = RunService.Heartbeat:Connect(function(dt)
        if not enabled or not folder then return end
        elapsed += dt
        if elapsed < SPAWN_INTERVAL or spawned >= MAX_PARTS then return end
        elapsed = 0

        local node = Instance.new("Part")
        node.Name = "FIO_Premium_LocalNode"
        node.Size = Vector3.new(4, 4, 4)
        node.Anchored = true
        node.Transparency = 1
        node.CanCollide = false
        node.CanTouch = false
        node.CanQuery = false
        node.CastShadow = false
        node.Position = Vector3.new(
            math.random(-180, 180),
            math.random(15, 100),
            math.random(-180, 180)
        )
        node.Parent = folder
        spawned += 1
    end)

    if context and context.setStatus then
        context.setStatus("Premium preview ON (client-only; 24 nodes maximum)")
    end
end

function Premium.Disable(context)
    enabled = false
    cleanup()
    if context and context.setStatus then
        context.setStatus("Premium preview OFF; local nodes cleared")
    end
end

return Premium
