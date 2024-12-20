# you find the full pre-commit-tools docu under:
# https://pre-commit.com/

repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.7.4
    hooks:
      # Run the Ruff linter.
      - id: ruff
        args: [--fix, --exit-non-zero-on-fix]
      # Run the Ruff formatter.
      - id: ruff-format

  - repo: https://github.com/adamchainz/blacken-docs
    rev: 1.19.1
    hooks:
      - id: blacken-docs
        additional_dependencies:
        - black==24.10.0
        files: '(?:README\.md|docs\/.*\.(?:md|rst))'

  - repo: https://github.com/asottile/pyupgrade
    rev: v3.19.0
    hooks:
      - id: pyupgrade
        args: [ --py{{ supported_python_versions.0|replace(".", "") }}-plus ]
        stages: [ pre-push ]

  - repo: https://github.com/adamchainz/django-upgrade
    rev: 1.22.1
    hooks:
      - id: django-upgrade
        args: [--target-version, "{{ supported_django_versions.0 }}"]
        stages: [ pre-push ]

  - repo: https://github.com/adamchainz/djade-pre-commit
    rev: 1.3.2
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
      - id: no-commit-to-branch
        args:
          [
            "--pattern",
            '^^(?!(?:feature|hotfix|bugfix|refactor|maintenance)/[\w\d\-_#]+).*$',
          ]
        stages: [ pre-commit ]
