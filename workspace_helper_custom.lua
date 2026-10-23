-- FIO Hub / Workspace Helper custom feature
-- Edit ONLY this file to change what the toggle does.
-- This template creates no parts and makes no remote calls.
--
-- How it works:
--   Enable(context)  runs when the Workspace Helper toggle turns ON.
--   Disable(context) runs when it turns OFF or the hub unloads.
-- The hub reloads this file from GitHub each time it is switched ON.
--
-- context.setStatus(message) updates the footer inside FIO Hub.

local WorkspaceHelper = {}
local enabled = false

function WorkspaceHelper.Enable(context)
    if enabled then return end
    enabled = true

    -- BEGIN YOUR ENABLE CODE
    print("[FIO] Workspace Helper enabled")
    context.setStatus("Workspace Helper ON — custom code ready")
    -- END YOUR ENABLE CODE
end

function WorkspaceHelper.Disable(context)
    if not enabled then return end
    enabled = false

    -- BEGIN YOUR DISABLE / CLEANUP CODE
    print("[FIO] Workspace Helper disabled")
    context.setStatus("Workspace Helper OFF")
    -- END YOUR DISABLE / CLEANUP CODE
end

return WorkspaceHelper
