# 01 — Modes and identifiers

Environment: macOS 26.6.2, Apple Silicon. Every row is `[VERIFIED]` on one unit unless marked otherwise.

| Mode | How to enter | VID:PID | Transport | What macOS shows |
|---|---|---|---|---|
| Wired USB-C | USB-C data cable | `2DC8:310A` | USB | If0 XInput (`0xFF/0x5D/0x01`) with no driver; If1 HID keyboard (1/6); If2 vendor page `0xFF7A` `[VERIFIED]` |
| Dongle, idle | Dongle alone, controller off | `2DC8:301C` ("IDLE") | USB | No gamepad `[VERIFIED]` |
| Dongle, controller connected | Controller linked over 2.4G | `2DC8:310A` | USB | **Same ID as the wired controller**, easy to confuse `[VERIFIED]` |
| Bluetooth | Back switch in BT position; pair from macOS | `2DC8:301B` | BLE | Shows up as "Gamepad" `[VERIFIED]` |
| D-Input via "hold B + plug USB" | Hold `B` while plugging in | `301D` was expected, **no change** (310A) | USB | `[TRIED-FAILED]` |
| Update/boot mode | — | `2DC8:3208` | USB | `[PER TOOLKIT]`, we did not see it |

Notes
- `bcdDevice` (e.g. 0x0114) is **not the firmware version**, it is the USB descriptor version `[OBSERVED]`.
- A safe way to tell controller and dongle apart: plug in **only one at a time** and check the serial/`301C`. Do not share serial numbers.
- The model code `81HD06` (Brownie edition) came from an early secondhand source `[SECONDHAND, UNVERIFIED]`.
