WARNING: Don't merge to the default branch when this line is present.

# devprod-pre-commit

Starter repo for pre-commit hooks for DevProd.

## How to use this

### Step 1

Install [pre-commit](https://pre-commit.com/).

```
brew install pre-commit
```

### Step 2

Follow [these directions](https://pre-commit.com/#automatically-enabling-pre-commit-on-repositories)
to ensure that your laptop will run the pre-commit hooks automatically whenever you
push a commit to repos with a pre-commit configuration.

### Step 3

Drop the following into `.pre-commit-config.yaml` at the top of the repo (and
tune to taste; find more at [pre-commit hooks](https://pre-commit.com/hooks.html)):

```
exclude: ^mk-include/
fail_fast: false

repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: check-json
      - id: check-merge-conflict
        args: [--assume-in-merge]
      - id: check-yaml
        args: [--unsafe]
      - id: end-of-file-fixer
      - id: name-tests-test
      - id: trailing-whitespace

  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.9.7
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format

  - repo: https://github.com/confluentinc/gitleaks
    rev: v7.6.1.1
    hooks:
      - id: gitleaks
        args: [--verbose]

  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.17.0
    hooks:
      - id: terraform_fmt
      - id: terraform_validate

  - repo: https://github.com/syntaqx/git-hooks
    rev: v0.0.16
    hooks:
      - id: go-fmt
        always_run: false
      - id: go-generate
        always_run: false
      - id: go-mod-tidy
        always_run: false
      - id: go-test
        always_run: false

  - repo: https://github.com/confluentinc/devprod-pre-commit
    rev: v0.1.0
    hooks:
      - id: shellcheck
```

Then run `pre-commit install` in the repo.

### Step 4

Strongly consider adding a top-level `ruff.toml` or `.ruff.toml` to make the
default linter more strict.  Please note that selecting "ISC" and configuring
implicit-str-concat is particularly important, as that setting would have prevented
[this incident](https://confluentinc.atlassian.net/browse/RCCA-24386):

```
[lint]
extend-select = ["ISC"]
unfixable = ["ISC001"]

[lint.flake8-implicit-str-concat]
allow-multiline = false
```

### Bonus Step

If you have multiple projects organized by subdirectory, and you want to
execute linters or the like in each subdirectory, you'll need to commit the
fromdir script from this devprod-pre-commit repo to your own repo... And then
you can use the fromdir tool to run subdirectory project checks as follows:

```
  - repo: local
    hooks:
      - id: deployment-settings-pytest-check
        name: deployment-settings pytest check
        stages:
          - pre-commit
        types:
          - python
        entry: script/fromdir
        args:
          - deployment-settings/
          - pipenv
          - run
          - pytest
          - tests
        language: system
        pass_filenames: false
        always_run: true
      - id: validation-pytest-check
        name: validation pytest check
        stages:
          - pre-commit
        types:
          - python
        entry: script/fromdir
        args:
          - validation/
          - pipenv
          - run
          - pytest
          - tests
        language: system
        pass_filenames: false
        always_run: true
```

Otherwise, adding pre-commit hooks to execute pytest and mypy for the entire
repository can be configured as follows:

```
  - repo: local
    hooks:
      - id: pytest-check
        name: pytest check
        stages:
          - pre-commit
        types:
          - python
        entry: pipenv
        args:
          - run
          - pytest
          - tests
        language: system
        pass_filenames: false
        always_run: true
      - id: mypy-types-check
        name: mypy types check
        stages:
          - pre-commit
        types:
          - python
        entry: pipenv
        args:
          - run
          - mypy
          - .
          - --strict
          - --install-types
          - --non-interactive
        language: system
        pass_filenames: false
        always_run: true
```
