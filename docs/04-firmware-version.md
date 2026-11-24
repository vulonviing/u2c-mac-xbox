# 04 — Finding the firmware version

1. **8BitDo Ultimate Software V2** (macOS, tried with app 1.0.22): shows the controller's version `[OBSERVED]`. ⚠️ The same app's "Update" button changes firmware **irreversibly**. When we pressed it, the controller was updated to stock 1.09 (a backup had been taken beforehand) `[OBSERVED]`.
2. **Toolkit** `devices`/`report`/`backup`: names only the versions it knows (controller 1.09, dongle 1.03). Otherwise it says "firmware this app doesn't recognise" `[PER TOOLKIT]`.
3. **Reading from a backup**: the update record (`0x3F000`, +0x0C = version×100; `0x6D` = 1.09) `[PER TOOLKIT]`. The update record was blank in our first backup.

Limits
- `bcdDevice` is not a version.
- Guessing from the header byte of the running firmware: `0x6A` (→1.06?) on our controller, `0x64` (→1.00?) on our dongle `[GUESS, UNVERIFIED]`.
- We found no official version history page; forums mention 1.06 beta / 1.09 beta `[SECONDHAND]`.
