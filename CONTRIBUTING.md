# Contributing

1. Before adding device results, pipe the output through `scripts/redact.py`; `--check` must exit 0.
2. Put an evidence label on every technical claim (list in the README). Never present something unverified as verified.
3. Do not add binaries (`.bin`, `.dat`, `.zip`...), firmware, keys or certificates.
4. Before sending: `git add`, then run `bash scripts/precommit-scan.sh`; it must come out clean. If you don't have a personal pattern file (`.git/info/scan-private`), run it in generic mode on purpose with `U2C_SCAN_GENERIC_ONLY=1`.
5. Please do not propose scripts that write to the device; that is out of scope.
