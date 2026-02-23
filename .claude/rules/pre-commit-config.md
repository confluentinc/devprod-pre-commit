---
globs: ".pre-commit-hooks.yaml,.pre-commit-config.yaml"
---

# Pre-commit Configuration Rules

## `.pre-commit-hooks.yaml` (public interface)
- This file defines hooks consumed by other Confluent repos -- treat changes as potentially breaking
- Never rename or remove hook `id` fields (`shellcheck`, `trufflehog`)
- The `entry` field must match the actual script filename
- `language: script` means pre-commit runs the entry point directly -- the script must be executable

## `.pre-commit-config.yaml` (self-linting)
- Sections between `# ### SERVICEBOT BEGIN` and `# ### SERVICEBOT END` are auto-managed by Servicebot -- never edit manually
- The `local` repo section at the bottom defines hooks that run on this repo itself
- Uses `exclude_types` in shellcheck hook to avoid running on non-bash shell variants
