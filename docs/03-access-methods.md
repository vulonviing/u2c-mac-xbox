# 03 — Ways to access the controller

All of these are for **read-only** use. No method that writes to the device is recommended.

| Method | What it shows | Notes |
|---|---|---|
| `system_profiler SPUSBDataType` | USB device tree | Includes serial number; redact before sharing |
| `system_profiler SPBluetoothDataType -json` | Paired/connected BT devices | **Lists your other devices' names too**; keep only the 8BitDo row |
| `ioreg -p IOUSB -l -w0` (or `-a` for plist) | Interface class/subclass/protocol, `bcdDevice`, driver matching | Includes serial, registry id, location id; pipe through `scripts/redact.py` |
| `hidutil list` | HID devices, usage page/usage | Use `list` only; never `property --set` |
| IOKit / `IOHIDManager` (C/Swift) | Raw HID input reports | macOS may require "Input Monitoring" permission `[OBSERVED]`; without it the device opens but no data may arrive |
| Swift `GameController` (`GCController`) | Devices the system treats as gamepads | Can return 0 in a command-line program; behavior in a GUI app `[UNVERIFIED]` |
| Chromium Gamepad API (`navigator.getGamepads()`) | Axis/button values | `scripts/gamepad-test.html`. A headless browser may not see the device `[OBSERVED]` |
| Python `hid`/`hidapi` packages | Raw HID access | Sending output reports counts as writing; do not use |
| U2C Firmware Toolkit | Backup/read (+ write tools: **do not use**) | Python ≥3.12 `[PER TOOLKIT]`, GPL-3.0; see `docs/12-sources.md` |

You need: macOS, Python 3 (the standard library is enough for inventory/redact), a Chromium-based browser.
