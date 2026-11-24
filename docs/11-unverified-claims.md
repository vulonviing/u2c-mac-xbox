# 11 — Unverified claims

| Claim | Source | Why unverified | How to verify |
|---|---|---|---|
| Model code 81HD06 | Early secondhand source | Never checked on the box | Read the label on the box |
| Initial firmware 1.06, dongle 1.00 | Header-byte guess | No official mapping | See the version in 8BitDo Ultimate Software V2 |
| `81 05 c1` does not change data and is undone by restart | Toolkit author | No independent test | Source/docs and hardware analysis |
| The Toolkit backup path is "safe" | Single-commit review | Not a guarantee | More reviews |
| All flash offsets | Toolkit docs | Only a consistency observation | Independent dump comparison |
| Magic-X works with the Brownie on Xbox | Vendor note | Not tested | Physical test |
| A Pico + Joypad OS/GP2040-CE route works | Project docs | Not tested | Physical test |
| Remote Play/Greenlight works with this controller | — | Not tried | Real game test |
| Greenlight macOS input bug | Secondhand PR | Not read | Your own test |
| D-Input exists via `B+USB`, `301D` | Toolkit/chat | Tried, no change | Another key combo / the manual |
| Boot mode `3208` | Toolkit | Not seen | — |
| `GCController` sees it in a GUI app | Guess | Returned 0 in a CLI | A GUI test app |
| Results hold outside macOS 26.6.2 | — | Measured on one version | Try another version |
| Dongle update is safe | — | Not done | — |
