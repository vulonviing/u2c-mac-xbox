#!/bin/bash
# READ-ONLY: scans tracked content for personal / per-device data. Exit code 1 if anything is found.
# Usage: bash scripts/precommit-scan.sh        (scans the STAGED content/index; git add first)
# As a hook: cp scripts/precommit-scan.sh .git/hooks/pre-commit
set -u
cd "$(git rev-parse --show-toplevel)"
FAIL=0
EX=(':!scripts/redact.py' ':!scripts/precommit-scan.sh')   # only the two files that carry pattern text
chk() { # description, pattern, [-i], pathspec...
  local d="$1" p="$2"; shift 2
  local opts=(--cached -nIE); [ "${1:-}" = "-i" ] && { opts=(--cached -nIEi); shift; }
  local out; out=$(git grep "${opts[@]}" -e "$p" -- . "$@" 2>/dev/null || true)
  [ -n "$out" ] && { echo "✗ $d"; echo "$out" | head -5; FAIL=1; }
}
# Personal patterns (your serial numbers, name, e-mail) are NOT kept in the repo: put them in
# .git/info/scan-private, one ERE pattern per line. That file is untracked and never pushed.
if [ -f .git/info/scan-private ]; then
  while IFS= read -r pat; do [ -n "$pat" ] && chk "personal pattern" "$pat" -i "${EX[@]}"; done < .git/info/scan-private
elif [ "${U2C_SCAN_GENERIC_ONLY:-}" = "1" ]; then
  echo "! personal patterns were not scanned (U2C_SCAN_GENERIC_ONLY=1)" >&2
else
  echo "✗ .git/info/scan-private is missing: personal patterns (serial no, name) cannot be scanned." >&2
  echo "  Create it (one pattern per line) or deliberately set U2C_SCAN_GENERIC_ONLY=1." >&2
  FAIL=1
fi
chk "MAC/BT address" '([0-9A-Fa-f]{2}[:-]){5}[0-9A-Fa-f]{2}' "${EX[@]}"
chk "long hex byte run" '([0-9A-Fa-f]{2}[ ,]){12,}' "${EX[@]}"
chk "user / local path" '/Users/[^<]' -i "${EX[@]}"
chk "e-mail" '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' ':!.git' ':!LICENSE*' ':!scripts/redact.py' ':!scripts/precommit-scan.sh'
chk "serial / session keys" 'IOConsoleUsers|kCGSSession|CGSSession|kSCSecuritySessionID|kUSBSerialNumberString|USB Serial Number|IOPlatform' "${EX[@]}"
chk "registry / location id" 'id 0x[0-9a-f]{6,}|locationID|UniqueID|IORegistryEntryID' -i "${EX[@]}"
chk "UUID" '[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}' "${EX[@]}"
chk "machine name / model" 'MacBook|Mac[0-9]+,[0-9]+|T81[0-9]{2}|\.local\b|Computer Name|Host ?Name|Model Identifier' "${EX[@]}"
chk "other BT device names" 'AirPods|iPhone|iPad|Apple Watch|Magic (Keyboard|Mouse|Trackpad)' "${EX[@]}"
chk "token / secret key" 'gh[pousr]_[A-Za-z0-9]{30,}|github_pat_|sk-[A-Za-z0-9_-]{20,}|AKIA[0-9A-Z]{16}|xox[bp]-|-----BEGIN' ':!scripts/precommit-scan.sh'
chk "session / network name" 'cookie|__Secure-|Authorization:|SSID' -i "${EX[@]}"
chk "ChatGPT link" 'chatgpt\.com|chat\.openai\.com' -i "${EX[@]}"
chk "timestamped file name" '20[0-9]{6}-[0-9]{6}' "${EX[@]}"
IP=$(git grep --cached -nIE '([0-9]{1,3}[.]){3}[0-9]{1,3}' -- . "${EX[@]}" 2>/dev/null | grep -v '127\.0\.0\.1' || true)
[ -n "$IP" ] && { echo "✗ IP address"; echo "$IP" | head -3; FAIL=1; }
H=$(git grep --cached -nIE '[0-9a-f]{64}' -- . ':!docs/06-firmware-hashes.md' ':!scripts/verify-sha256.sh' ':!scripts/redact.py' ':!scripts/precommit-scan.sh' 2>/dev/null || true)
[ -n "$H" ] && { echo "✗ 64-char hex (allowed only in docs/06, verify-sha256.sh, redact.py)"; echo "$H" | head -3; FAIL=1; }
B=$(git ls-files | grep -Ei '\.(bin|dat|hex|uf2|img|elf|zip|7z|pem|der|crt|cer|key|p12|txt|log)$' || true)
[ -n "$B" ] && { echo "✗ forbidden file type:"; echo "$B"; FAIL=1; }
[ $FAIL -eq 0 ] && echo "✓ clean" || echo "FINDINGS"
exit $FAIL
