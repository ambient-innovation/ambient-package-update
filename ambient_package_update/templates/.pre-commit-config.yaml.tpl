# you find the full pre-commit-tools docu under:
# https://pre-commit.com/

repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.11.11
    hooks:
      # Run the Ruff formatter.
      - id: ruff-format
      # Run the Ruff linter.
      - id: ruff-check
        args: [--fix, --exit-non-zero-on-fix]

  - repo: https://github.com/adamchainz/blacken-docs
    rev: 1.19.1
    hooks:
      - id: blacken-docs
        additional_dependencies:
        - black==25.1.0
        files: '(?:README\.md|\.ambient-package-update\/templates\/snippets\/.*\.tpl|docs\/.*\.(?:md|rst))'

  - repo: https://github.com/asottile/pyupgrade
    rev: v3.20.0
    hooks:
      - id: pyupgrade
        args: [ --py{{ supported_python_versions.0|replace(".", "") }}-plus ]

  - repo: https://github.com/adamchainz/django-upgrade
    rev: 1.25.0
    hooks:
      - id: django-upgrade
        args: [--target-version, "{{ supported_django_versions.0 }}"]

  - repo: https://github.com/adamchainz/djade-pre-commit
    rev: 1.4.0
    hooks:
    -   id: djade
        args: [--target-version, "4.2"]
        exclude: |
          (?x)^(
            charts/.*
            |.*\.py
          )$

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: check-ast
      - id: check-builtin-literals
      - id: check-case-conflict
      - id: check-docstring-first
      - id: check-executables-have-shebangs
      - id: check-json
      - id: check-merge-conflict
      - id: check-toml
      - id: end-of-file-fixer
      - id: fix-byte-order-marker
      - id: mixed-line-ending
      - id: trailing-whitespace
