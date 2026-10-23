# First Is Owner — FIO Hub

Luau script for [First Is Owner](https://www.roblox.com/games/130496219537579/First-Is-Owner) (place ID `130496219537579`).

## Features (v0.3.0)

- Draggable retro window, mobile reopen button, Right Shift toggle, unload cleanup
- Home: server population and status
- Players: player selector, spectate, local teleport, camera reset
- Visuals: fullbright and WalkSpeed (16 / 32 / 50)
- Exploits: fly, noclip, infinite jump, Player ESP, click teleport, anti-fling
- BTools: Anti Jail, Kill Touch, Glitchy Title

### BTools tab — experimental

BTools features require an **equipped F3X-compatible Tool** with `SyncAPI.ServerEndpoint`. A successful request does not guarantee that the server accepts the edit. The script does not grant BTools or bypass the game's server permission checks.

**Anti Jail** scans within 22 studs of your character for parts whose names or ancestors contain `jail`, `prison`, `cage`, or `cell`. While enabled it attempts to remove up to 30 of those parts via BTools approximately every 1.7 seconds. Player character parts are excluded. Unnamed or server-protected jail objects may not be removed.

**Kill Touch** attaches touch listeners to your character's body parts. When you touch another player's character, it attempts to remove that character's Head using the equipped BTools. Per-target requests are limited to once every four seconds. If the server denies the edit, it will not kill them; check the status message.

**Glitchy Title** displays an animated, distorted OWNER title above your character. It is a **local visual effect only**, not a change to your actual owner/admin role and not visible to others. It is gated behind the BTools check as requested, but does not send title mutations to the game server.

All three toggles clean up when disabled or when the hub unloads. Touch listeners rebind after respawn; the title effect must be re-enabled after respawn.

## Development loader

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/KoSmoXD/fio/feat/fio-hub-starter/fio.lua"))()
```

After the PR merges, change `feat/fio-hub-starter` to `main`.

## Dex Audit (read-only diagnostic)

Run the separate scanner in First Is Owner:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/KoSmoXD/fio/feat/fio-hub-starter/dex_scanner.lua"))()
```

The scanner displays the **client-replicated** RemoteEvents, RemoteFunctions, Tools, ProximityPrompts, and ClickDetectors. It highlights names mentioning jail, F3X/BTools, owner, rank, admin, coin, commands, kill, title, and other relevant mechanics. It reports object paths without invoking any remotes, executing remote commands, or attempting privilege escalation.

Use the **Copy report** button to collect the inventory for review. If a clipboard function is unavailable, select and copy the report text manually. The UI is draggable, works on touch screens, and toggles with Right Control or its floating DEX button. The generated paths may include player names; review before sharing publicly.

This inventory is exploratory, not a vulnerability report. Client-visible names don't prove what server-side permission checks do.

## Limitations and verification

The game's owner positions, ranks, permissions and coins are server controlled. Game rules explicitly warn that exploitation can lead to permanent bans.

Code committed and readable through GitHub. **No in-game test or Luau compiler run has been performed**, and effects depending on this particular game's BTools have not been verified.
