# 06 — Known official hashes

Hashes of **official, publicly available** files only. A hash of a per-unit full-flash backup is **useless for comparison** (it differs per device) and is not shared.

| Component | Version | File | SHA-256 | Label |
|---|---|---|---|---|
| Controller | 1.09 | 8BitDo's update `.dat` file | `87349e603bb92d6ae9ff6defb6f32b10de2f2d3252fe4e442fa7993f982f2a5a` | `[VERIFIED]` (matches both what the app downloaded and the Toolkit's documentation) |
| Controller | initial (probably 1.06) | — | — | `[GUESS]` no hash given |
| Dongle | 1.03 | — | see the Toolkit's documentation | `[PER TOOLKIT]` |
| Dongle | initial (probably 1.00) | — | — | `[GUESS]` |

Check: `bash scripts/verify-sha256.sh file.dat`.
