# 05 — Safe backup

This procedure uses only the **U2C Firmware Toolkit**'s `devices` and `backup` commands. We do not copy the Toolkit's code into this repo; download it yourself, pinned to a commit (see `docs/12-sources.md`).

> In the commit we reviewed, the backup path contained **no erase/write calls** `[CODE REVIEW, single commit]`. That is not a guarantee.

## Prerequisites
- Python ≥3.12. Download the Toolkit at a specific commit and **read the `backup` path yourself before running it**.
- Use a folder that is not synced to iCloud. A backup file contains **Bluetooth pairing keys, the MAC address and calibration**; do not share it.
- Use nothing but those commands: `patch`, `restore`, `--write`, `--accept-disclaimer`, `dongle-mode-test`, `--download` are FORBIDDEN.

## One-device rule
- **Controller backup:** only the controller is plugged in over USB-C; the dongle is **not** plugged in. `devices` should print a single line `cable 2dc8:310a`.
- **Dongle backup:** controller **fully off**, dongle alone. `devices` should print `dongle 2dc8:301c`. If you see `cable`/`dongle_paired`, STOP (a dongle looks like the controller while the controller is connected through it).

## Steps
1. Run `devices`; confirm the expected line above.
2. Run `backup`. Progress appears as "pass 1 / pass 2"; if no progress shows in the first ~3 seconds, press Ctrl-C.
3. When done: size must be 524288 bytes (controller) or 131072 bytes (dongle); verify with `shasum -a 256 -c` against SHA256SUMS.
4. Unplug the cable and fully power the controller off (Home ≈12 s), in case a read-protection state was left open `[GUESS, precaution]`.
5. Store the backup encrypted and in a separate place. Never delete the backup taken **before** an update.

## Stop conditions
More than one device listed · mode `boot` · exit code ≠ 0 · two passes differ · "firmware this app doesn't recognise" (the backup may still be real data but its version is unverified; keep it, **do not write**) · wrong size.

## Unknowns
When the Toolkit sends its `81 05 c1` command (claimed to lift flash write protection until restart) is not logged `[PER TOOLKIT, UNVERIFIED]`.
