# 07 — Flash map

Source: Toolkit documentation `[PER TOOLKIT]`; the filled/blank state of the regions in our backups is **consistent** with this map `[OBSERVED]`. Byte contents are not shared.

**Controller (512 KiB)**
| Range | Contents |
|---|---|
| `0x0000–0x6000` | Bootloader |
| `0x6000–` | Bank A, the running firmware (1.09 payload is `0x12400` bytes) |
| `0x3F000` | Update record (+0x0C version×100) |
| `0x40000–` | Bank B, second copy / update staging |
| `0x73000–` | Settings |
| `0x76000` | MAC sector (calibration, BT pairings) |

**Dongle (128 KiB):** bootloader `0x0–0x6000`, application `0x6000–0x10000`, plus a calibration region (exact offset is in the Toolkit source).

**Observations**
- The processor is a Telink B80 (TC32); the firmware contains an SDK version string and the device name in plain text → firmware is **not encrypted** `[OBSERVED]`.
- When updating to 1.09 with 8BitDo's app, the bootloader, settings, MAC sector and calibration regions did **not change**; bank A, bank B and the update record did `[OBSERVED, one unit]`.
