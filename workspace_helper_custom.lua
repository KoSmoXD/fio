-- First Is Owner / Workspace Helper custom hook
-- This file is intentionally minimal and editable independently of fio.lua.
-- The toggle loads this module when you turn Workspace Helper ON.
-- On OFF and hub unload, Disable(context) is called.
local WorkspaceHelper = {}
local enabled = false

function WorkspaceHelper.Enable(context)
    if enabled then return end
    enabled = true
    print("[FIO] Workspace Helper enabled")
    if context and context.setStatus then
        context.setStatus("Workspace Helper ON — editable callbacks loaded")
    end
end

function WorkspaceHelper.Disable(context)
    if not enabled then return end
    enabled = false
    print("[FIO] Workspace Helper disabled")
    if context and context.setStatus then
        context.setStatus("Workspace Helper OFF")
    end
end

return WorkspaceHelper
