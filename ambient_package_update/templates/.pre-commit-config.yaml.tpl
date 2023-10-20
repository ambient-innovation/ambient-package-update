# you find the full pre-commit-tools docu under:
# https://pre-commit.com/

repos:
  - repo: https://github.com/psf/black-pre-commit-mirror
    rev: 23.10.0
    hooks:
      - id: black
        args: [ --check, --diff, --config, ./pyproject.toml ]
        stages: [ push ]

  - repo: https://github.com/charliermarsh/ruff-pre-commit
    rev: 'v0.1.1'
    hooks:
      - id: ruff
        args: [ --fix, --unsafe-fixes, --exit-non-zero-on-fix ]

  - repo: https://github.com/asottile/pyupgrade
    rev: v3.15.0
    hooks:
      - id: pyupgrade
        args: [ --py{{ supported_python_versions.0|replace(".", "") }}-plus ]
        stages: [ push ]

  - repo: https://github.com/adamchainz/django-upgrade
    rev: 1.15.0
    hooks:
      - id: django-upgrade
        args: [--target-version, "{{ supported_django_versions.0 }}"]
        stages: [ push ]
