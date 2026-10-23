# First Is Owner — FIO Hub

Initial client-side Luau utility hub for [First Is Owner](https://www.roblox.com/games/130496219537579/First-Is-Owner) (place ID `130496219537579`).

## Features (v0.1.0)

- Compact, draggable, retro-style window (mouse and touch)
- Right Shift to show/hide; floating FIO button to reopen on mobile
- Server population display
- Player selection, spectate, camera reset, and local teleport attempt
- Local fullbright toggle with lighting restoration on unload
- Local WalkSpeed buttons (16 / 32 / 50)
- Re-execution cleanup and full unload button
- No third-party libraries or network calls

## Usage

Run `fio.lua` as a client-side Luau script while playing the correct Roblox experience. In a Roblox Studio test place, it can be used as a `LocalScript` for UI testing, but the place-ID guard must match.

After merging this branch into `main`, the raw script URL will be:

`https://raw.githubusercontent.com/KoSmoXD/fio/main/fio.lua`

## Limitations

The game server controls owner position, ranks, admin permissions, and coin balances. This script does **not** grant those privileges. Client-side movement/teleport behavior can be overridden by the game. Roblox's game rules warn that exploit scripts can result in bans.

## Verification

Code committed for review. Not executed in a live Roblox session; in-game functionality is not yet verified.
