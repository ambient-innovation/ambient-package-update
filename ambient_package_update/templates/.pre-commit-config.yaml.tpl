# you find the full pre-commit-tools docu under:
# https://pre-commit.com/

repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.6.4
    hooks:
      # Run the Ruff linter.
      - id: ruff
        args: [--fix, --exit-non-zero-on-fix]
      # Run the Ruff formatter.
      - id: ruff-format

  - repo: https://github.com/adamchainz/blacken-docs
    rev: 1.18.0
    hooks:
      - id: blacken-docs
        additional_dependencies:
        - black==24.4.2
        files: '(?:README\.md|docs\/.*\.(?:md|rst))'

  - repo: https://github.com/asottile/pyupgrade
    rev: v3.17.0
    hooks:
      - id: pyupgrade
        args: [ --py{{ supported_python_versions.0|replace(".", "") }}-plus ]
        stages: [ push ]

  - repo: https://github.com/adamchainz/django-upgrade
    rev: 1.21.0
    hooks:
      - id: django-upgrade
        args: [--target-version, "{{ supported_django_versions.0 }}"]
        stages: [ push ]
