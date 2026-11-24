# 02 — macOS status

Measured on macOS 26.6.2 with the browser Gamepad API (same logic as `scripts/gamepad-test.html`).

| Connection | System driver | Chromium Gamepad API | Usable for games |
|---|---|---|---|
| Bluetooth | present | `standard` mapping, 4 axes, 17 buttons | ✅ `[VERIFIED]` |
| Wired USB-C | none for the XInput interface; present for auxiliary HID interfaces | not shown | ❌ `[VERIFIED]` |
| Dongle | same | not shown | ❌ `[VERIFIED]` |

Bluetooth measurements (`[VERIFIED]`, scope: macOS 26.6.2, one unit):
- At rest all four axes read exactly 0; no drift or jitter seen.
- LX, LY, RX, RY: full −1…+1 range.
- LT/RT: up to 1.0.
- All 17 buttons (A B X Y LB RB LT RT Back Start L3 R3, four d-pad directions, Home) were pressed and detected.
- **No firmware patch was needed.**

A small Swift program calling `GCController.controllers()` from the command line returned 0; we could not tell whether that is a command-line limitation or real `[UNVERIFIED]`.

Real game input through Greenlight/Remote Play was **not tried**.
