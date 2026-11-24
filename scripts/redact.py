#!/usr/bin/env python3
"""READ-ONLY: stdin -> stdout. Never touches a device, no network, standard library only.

Masks personal / per-device data in raw output before you share it.
  python3 redact.py < raw.md > clean.md
  python3 redact.py --check < file   # exit code 1 if anything needs masking

Per-unit hashes (64 hex chars) are masked on purpose; the official 1.09 .dat hash is allow-listed.
"""
import re
import sys

RULES = [
    # line based: serial-number fields
    (re.compile(r'(?im)^.*(kUSBSerialNumberString|USB Serial Number|iSerialNumber|SerialNumber|IOPlatformSerialNumber).*$'), '<SERIAL-LINE>'),
    (re.compile(r'(?im)^.*(IOConsoleUsers|kCGSSession|CGSSession|kSCSecuritySessionID).*$'), '<SESSION-LINE>'),
    (re.compile(r'(?i)(link ?key|LTK|IRK|bond(ing)? ?(key|data))\s*[:=]\s*\S+'), '<BT-KEY>'),
    (re.compile(r'(?<![0-9A-Fa-f:])(?:[0-9A-Fa-f]{2}[:-]){5}[0-9A-Fa-f]{2}(?![0-9A-Fa-f:])'), '<MAC>'),
    # separator-less 12 hex (aabbccddeeff) and dotted form (aabb.ccdd.eeff)
    (re.compile(r'(?<![0-9A-Za-z])(?:[0-9A-Fa-f]{4}\.){2}[0-9A-Fa-f]{4}(?![0-9A-Za-z])'), '<MAC>'),
    (re.compile(r'\b[0-9a-fA-F]{8}-(?:[0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}\b'), '<UUID>'),
    (re.compile(r'(?i)\bid 0x[0-9a-f]{6,}\b'), '<REGID>'),
    (re.compile(r'(?i)\b(locationID|UniqueID|IORegistryEntryID)\b\s*[=:]?\s*\S+'), '<LOCID>'),
    (re.compile(r'/Users/[^/\s"\']+'), '/Users/<USER>'),
    (re.compile(r'(?i)\b[\w.-]+\.local\b'), '<HOST>'),
    (re.compile(r'[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'), '<EMAIL>'),
    (re.compile(r'\b(?:\d{1,3}\.){3}\d{1,3}\b'), '<IP>'),
    (re.compile(r"(?i)[^\n\"']*\b(AirPods|iPhone|iPad|Apple Watch|Magic (Keyboard|Mouse|Trackpad))[^\n\"']*"), '<BT-NAME>'),
    (re.compile(r'(?<![0-9A-Za-z])[0-9A-Fa-f]{12}(?![0-9A-Za-z])'), '<MAC>'),
    # 12+ consecutive hex bytes (flash dumps, bond data, ...)
    (re.compile(r'(?:\b[0-9A-Fa-f]{2}\b[ ,]+){11,}\b[0-9A-Fa-f]{2}\b'), '<HEXDUMP>'),
    # 10+ char mixed hex (serial-number-like, any case); 0x-prefixed values are skipped
    (re.compile(r'(?i)(?<![0-9A-Za-z])(?!0x)(?=[0-9A-F]*\d)(?=[0-9A-F]*[A-F])[0-9A-F]{10,}(?![0-9A-Za-z])'), '<SERIAL>'),
]


ALLOW = {"87349e603bb92d6ae9ff6defb6f32b10de2f2d3252fe4e442fa7993f982f2a5a"}   # official controller 1.09 .dat


def redact(text: str) -> str:
    keep = {}
    for i, h in enumerate(ALLOW):
        token = f"\x00KEEP{i}\x00"
        keep[token] = h
        text = text.replace(h, token)
    for pattern, repl in RULES:
        text = pattern.sub(repl, text)
    for token, h in keep.items():
        text = text.replace(token, h)
    return text


def main(argv):
    if "-h" in argv or "--help" in argv:
        print(__doc__)
        return 0
    data = sys.stdin.read()
    out = redact(data)
    if "--check" in argv:
        if out != data:
            print("redact.py: data that needs masking was found", file=sys.stderr)
            return 1
        return 0
    sys.stdout.write(out)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
