# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Project Does

`ambient-package-update` is a CLI tool that renders Jinja2 templates to maintain consistent structure, configuration,
and best practices across multiple Python packages. Target packages create a `.ambient-package-update/metadata.py` file
describing their package, then run this tool to regenerate all boilerplate files (pyproject.toml, README.md, CI
workflows, etc.).

## Commands

```bash
# Install dependencies (including dev extras)
uv sync --frozen --extra dev

# Lint and format
ruff format .
ruff check --fix .

# Run pre-commit hooks on all files
pre-commit run --all-files

# Build distribution
uv build
```

This project has **no test suite** — it is intentionally untested in CI (only linting runs). The CI workflow (
`.github/workflows/ci.yml`) only runs pre-commit.

## Architecture

```
ambient_package_update/
├── cli.py              # Typer CLI: render_templates, eject_template, run_tests, build_docs
├── metadata/           # Dataclass models for package configuration
│   ├── package.py      # PackageMetadata — central config object
│   ├── constants.py    # Supported Python/Django versions, license enums, dev deps
│   └── ...             # author, maintainer, readme, executables, ruff rules
└── templates/          # Jinja2 templates (.tpl files) rendered into target packages
    ├── pyproject.toml.tpl
    ├── .github/workflows/
    ├── docs/
    └── snippets/       # Reusable template blocks (badges, licenses, etc.)
```

**Template rendering flow** (`render_templates` command):

1. Load `PackageMetadata` from the target package's `.ambient-package-update/metadata.py`
2. Extract the current version from the target module's `__init__.py`
3. Build a Jinja2 environment with two template search paths: `.ambient-package-update/templates/` (project overrides)
   then `ambient_package_update/templates/` (defaults)
4. Render each template with the metadata as context, post-process whitespace, and write output files

**Versioning**: CalVer format `YY.MM.RELEASE` (e.g., `26.2.1`). Version is stored in
`ambient_package_update/__init__.py` and managed by hatchling.

## Code Style

- Line length: 120 characters (configured in `pyproject.toml` under `[tool.ruff]`)
- Ruff is the sole formatter and linter — no Black, no isort separately
- Python ≥ 3.10 required; target version for ruff is 3.13
