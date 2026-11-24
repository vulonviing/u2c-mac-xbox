#!/bin/bash
# READ-ONLY: never writes to the device, sends no HID output, uses no network.
# Lists 8BitDo (VID 0x2DC8) devices on macOS and prints a redacted Markdown table.
# Never prints serial numbers, MAC/BT addresses, location ids or the names of your other BT devices.
# Usage: bash scripts/inventory.sh
set -u
[ "${1:-}" = "--help" ] && { sed -n '2,5p' "$0"; exit 0; }
[ "$(uname)" = "Darwin" ] || { echo "macOS only" >&2; exit 2; }
HERE="$(cd "$(dirname "$0")" && pwd)"
{
python3 - <<'PY'
import json, plistlib, subprocess

VID = 0x2DC8


def run(cmd):
    return subprocess.run(cmd, capture_output=True, text=True, check=False).stdout


def walk(n, out):
    if isinstance(n, dict):
        if n.get("idVendor") == VID:
            out.append(n)
        for c in n.get("IORegistryEntryChildren", []):
            walk(c, out)
    elif isinstance(n, list):
        for c in n:
            walk(c, out)


print("## USB")
raw = subprocess.run(["ioreg", "-a", "-p", "IOUSB", "-l"], capture_output=True, check=False).stdout
devs = []
if raw:
    walk(plistlib.loads(raw), devs)
if not devs:
    print("(no 8BitDo USB device connected)")
else:
    print("| VID:PID | Product name | bcdDevice | Interfaces (n:class/subclass/protocol) |")
    print("|---|---|---|---|")
    for d in devs:
        ifs = []
        def find_if(n):
            if isinstance(n, dict):
                if "bInterfaceClass" in n:
                    ifs.append(f'{n.get("bInterfaceNumber")}:{n["bInterfaceClass"]}/{n.get("bInterfaceSubClass")}/{n.get("bInterfaceProtocol")}')
                for c in n.get("IORegistryEntryChildren", []):
                    find_if(c)
        find_if(d)
        print(f'| {d["idVendor"]:04X}:{d["idProduct"]:04X} | {d.get("USB Product Name", "?")} | 0x{d.get("bcdDevice", 0):04X} | {" ".join(ifs)} |')

print("\n## HID (hidutil list)")
rows = [l for l in run(["hidutil", "list"]).splitlines() if "0x2dc8" in l.lower()]
if not rows:
    print("(none)")
else:
    print("| ProductID | UsagePage | Usage | Transport |")
    print("|---|---|---|---|")
    seen = set()
    for l in rows:
        p = l.split()
        if len(p) >= 7:
            key = (p[1], p[3], p[4], " ".join(p[6:8]))
            if key not in seen:
                seen.add(key)
                print(f"| {p[1]} | {p[3]} | {p[4]} | {p[6]} {p[7] if p[7] in ('Low','Energy') else ''} |")

print("\n## Bluetooth (8BitDo entries only)")
try:
    bt = json.loads(run(["system_profiler", "SPBluetoothDataType", "-json"]))
    found = False
    for blk in bt.get("SPBluetoothDataType", []):
        for state in ("device_connected", "device_not_connected"):
            for entry in blk.get(state, []):
                for name, info in entry.items():
                    if "8bitdo" in name.lower():
                        found = True
                        print(f'- {name}: connected={state == "device_connected"}, vendor={info.get("device_vendorID")}, product={info.get("device_productID")}, type={info.get("device_minorType")}')
    if not found:
        print("(no paired 8BitDo)")
except Exception as e:  # noqa
    print("(could not read)")
PY
} | python3 "$HERE/redact.py"
