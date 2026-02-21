---
globs: ".semaphore/*.yml"
---

# Semaphore Pipeline Rules

- The pipeline runs on `s1-prod-ubuntu24-04-arm64-1` (ARM64 Ubuntu) -- ensure scripts are compatible with this environment
- CI installs `pre-commit` via `pip install pre-commit` (not brew)
- The entire CI job is just `pre-commit run --all-files` -- no separate build/test/deploy stages
- `auto_cancel` is set to cancel running pipelines on non-master branches when new pushes arrive
- Pipeline has a `change_in` filter that skips runs for changes only in `/.deployed-versions/` or `.github/`
