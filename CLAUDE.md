# devprod-pre-commit

## Repository Overview

A pre-commit hooks repository maintained by the DevProd team at Confluent. It provides reusable [pre-commit](https://pre-commit.com/) hooks (`shellcheck`, `trufflehog`) that other Confluent repositories consume via `.pre-commit-config.yaml`. This repo does NOT contain application code -- it is purely infrastructure for git hook distribution.

### Hooks Provided

| Hook | Script | Purpose |
|------|--------|---------|
| `shellcheck` | `shellcheck.sh` | Lints shell scripts via shellcheck (auto-installs if missing) |
| `trufflehog` | `trufflehog.sh` | Scans for verified secrets using TruffleHog (auto-installs if missing) |

The `fromdir` utility script is meant to be copied into consuming repos, not used as a hook directly.

## Architecture

- Hook entry points are defined in `.pre-commit-hooks.yaml` (consumed by external repos referencing this repo)
- `.pre-commit-config.yaml` defines hooks that run on THIS repo itself (self-linting)
- `service.yml` is a Servicebot configuration that manages CODEOWNERS, Renovatebot, and Semaphore CI
- Sections between `SERVICEBOT BEGIN` and `SERVICEBOT END` comments in `.pre-commit-config.yaml` are auto-managed -- do not edit them manually

## CI/CD

- Semaphore CI (`.semaphore/semaphore.yml`) runs `pre-commit run --all-files` on every push
- Default branch is `master`
- Pipeline skips runs for changes only in `/.deployed-versions/` or `.github/`

## Common Development Commands

```bash
# Run all hooks locally
pre-commit run --all-files

# Run a specific hook
pre-commit run shellcheck --all-files
pre-commit run trufflehog --all-files
```

**Prerequisites**: `pre-commit` installed (`brew install pre-commit`).

## Critical Invariants

- `trufflehog.sh` pins a specific TruffleHog version via the `TAG` variable (currently `v3.90.2`) -- update deliberately and test after changes
- `shellcheck.sh` and `trufflehog.sh` must remain executable (`chmod +x`) and use `#!/bin/bash`
- Hook definitions in `.pre-commit-hooks.yaml` are a **public interface** consumed by many Confluent repos -- changes here are breaking for all consumers
- Both hook scripts are self-bootstrapping: they auto-install their tool if not found on PATH

## Do Not Do

- Do not edit sections between `SERVICEBOT BEGIN` and `SERVICEBOT END` in `.pre-commit-config.yaml`
- Do not change hook IDs in `.pre-commit-hooks.yaml` (breaking change for all consumers)
- Do not remove the auto-install logic from `shellcheck.sh` or `trufflehog.sh` -- hooks must be self-bootstrapping
- Do not change `entry` fields in `.pre-commit-hooks.yaml` without updating the corresponding script filenames
