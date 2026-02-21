---
globs: "*.sh,fromdir"
---

# Shell Script Rules

- All `.sh` scripts must use `#!/bin/bash` shebang and `set -eu` for strict error handling
- Scripts must remain executable (`chmod +x`) -- if creating or modifying, verify the execute bit
- Hook scripts (`shellcheck.sh`, `trufflehog.sh`) must be self-bootstrapping: they auto-install their tool if not present on PATH
- The auto-install logic supports multiple package managers (brew, apt, yum for shellcheck; brew or direct download for trufflehog) -- maintain all paths
- `trufflehog.sh` pins a specific version via the `TAG` variable -- never change this casually; version bumps should be deliberate and tested
- `trufflehog.sh` includes vendored helper functions from [client9/shlib](https://github.com/client9/shlib) for portable download/checksum -- maintain these as a unit
- `fromdir` uses `#!/bin/sh` (POSIX sh, not bash) since it is designed to be copied into consuming repos with minimal dependencies
- All scripts must pass `shellcheck` (with SC1091 excluded via args in `.pre-commit-hooks.yaml`)
