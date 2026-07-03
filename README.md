[![PyPI release](https://img.shields.io/pypi/v/ambient-package-update.svg)](https://pypi.org/project/ambient-package-update/)
[![Downloads](https://static.pepy.tech/badge/ambient-package-update)](https://pepy.tech/project/ambient-package-update)
[![Linting](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/ruff/main/assets/badge/v2.json)](https://github.com/astral-sh/ruff)
[![Coding Style](https://img.shields.io/badge/code%20style-Ruff-000000.svg)](https://github.com/astral-sh/ruff)

# Ambient Package Update

This repository will help keep all Python packages following a certain basic structure tidy and up-to-date. It's being
maintained by [Beyonder Deutschland](https://beyonder.de).

This package will render all required configuration and installation files for your target package.

Typical use-cases:

- A new Python or Django version was released
- A Python or Django version was deprecated
- You want to update the Sphinx documentation builder
- You want to update the linter versions
- You want to add the third-party dependencies

## Versioning

This project follows the CalVer versioning pattern: `YY.MM.[RELEASE]`

## How to update a package

These steps will tell you how to update a package which was created by using this updater.

- Navigate to the main directory of **your** package
- Activate your virtualenv
- Run `python -m ambient_package_update.cli render-templates`
- Validate the changes and increment the version accordingly
- Release a new version of your target package

## How to create a new package

Just follow these steps if you want to create a new package and maintain it using this updater.

- Create a new repo at GitHub
- Check out the new repository in the same directory this updater lives in (not inside the updater!)
- Create a directory ".ambient-package-update" and create a file "metadata.py" inside.

```python
from ambient_package_update.metadata.author import PackageAuthor
from ambient_package_update.metadata.constants import (
    DEV_DEPENDENCIES,
    DEPLOYMENT_STATUS_STABLE,
    LICENSE_MIT,
    SUPPORTED_DJANGO_VERSIONS,
    SUPPORTED_PYTHON_VERSIONS,
)
from ambient_package_update.metadata.maintainer import PackageMaintainer
from ambient_package_update.metadata.package import PackageMetadata
from ambient_package_update.metadata.readme import ReadmeContent
from ambient_package_update.metadata.ruff_ignored_inspection import (
    RuffIgnoredInspection,
    RuffFilePatternIgnoredInspection,
)

METADATA = PackageMetadata(
    package_name="my_package_name",
    github_package_group="ambient-innovation",
    licenser="Beyonder Deutschland",
    license=LICENSE_MIT,
    development_status=DEPLOYMENT_STATUS_STABLE,
    claim="A short one-line description of what your package does.",
    authors=[
        PackageAuthor(
            name="Beyonder Deutschland",
            email="hello@beyonder.de",
        ),
    ],
    maintainer=PackageMaintainer(
        name="Beyonder Deutschland",
        url="https://beyonder.de/",
        email="hello@beyonder.de",
    ),
    readme_content=ReadmeContent(
        tagline="A fancy tagline for your new package",
        content="""A multiline string containing specific things you want to have in your package readme.
""",
    ),
    dependencies=[
        "my_dependency>=1.0",
    ],
    supported_python_versions=SUPPORTED_PYTHON_VERSIONS,
    supported_django_versions=SUPPORTED_DJANGO_VERSIONS,
    has_migrations=False,
    optional_dependencies={
        "dev": [
            *DEV_DEPENDENCIES,
        ],
        # you might add further extras here
    },
    # Example of a global ruff ignore
    ruff_ignore_list=[
        RuffIgnoredInspection(key="XYZ", comment="Reason why we need this exception"),
    ],
    # Example of a file-based ruff ignore
    ruff_file_based_ignore_list=[
        RuffFilePatternIgnoredInspection(
            pattern="**/tests/missing_init/*.py",
            rules=[
                RuffIgnoredInspection(
                    key="INP001", comment="Missing by design for a test case"
                ),
            ],
        ),
    ],
)
```

### Metadata reference

`PackageMetadata` (in `ambient_package_update.metadata.package`) is the single configuration object that drives
all rendered files. The following fields are **required** (no default value):

| Field | Type | Description |
|-------|------|-------------|
| `package_name` | `str` | The distribution/module name, e.g. `django_pony_express`. Underscores are converted to hyphens for the GitHub/PyPI name. |
| `github_package_group` | `str` | The GitHub owner/organization the repo lives under, e.g. `ambient-innovation`. Used for repo, issue and security-advisory URLs. |
| `licenser` | `str` | The copyright holder written into the `LICENSE.md` file. |
| `authors` | `list[PackageAuthor]` | One or more `PackageAuthor(name, email)` entries; rendered into `pyproject.toml`. |
| `maintainer` | `PackageMaintainer` | A single `PackageMaintainer(name, url, email)`. The email is used as the Code-of-Conduct contact. |
| `development_status` | `str` | A trove classifier such as `DEPLOYMENT_STATUS_STABLE`. See `metadata.constants` for the presets. |
| `readme_content` | `ReadmeContent` | Controls the generated `README.md` (see below). |
| `claim` | `str` | One-line package description. Used as the `pyproject.toml` description and the `__init__.py` docstring. |
| `has_migrations` | `bool` | Whether the package ships Django migrations. Enables the migration-integrity CI job when `True`. |
| `dependencies` | `list[str]` | Runtime dependencies (PEP 508 specifiers). |
| `supported_python_versions` | `list[str]` | Python versions for the CI test matrix, e.g. `SUPPORTED_PYTHON_VERSIONS`. |
| `supported_django_versions` | `list[str]` | Django versions for the CI test matrix, e.g. `SUPPORTED_DJANGO_VERSIONS`. |

The following fields are **optional** (defaults shown):

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `min_coverage` | `float` | `100.0` | Coverage threshold the CI coverage job enforces. |
| `license` | `str` | `LICENSE_MIT` | `LICENSE_MIT` or `LICENSE_GPL`; selects the rendered license file. |
| `license_year` | `int` | current year | Copyright year in the license file. |
| `main_branch` | `str` | `"master"` | Default branch name used in CI triggers and docs links. |
| `tests_require_django` | `bool` | `True` | Whether the test setup needs a Django settings module. |
| `github_package_name` | `str` | derived | Overrides the GitHub repo name (defaults to `package_name` with hyphens). |
| `module_name` | `str` | derived | Overrides the importable module name (defaults to `package_name` with underscores). |
| `optional_dependencies` | `dict[str, list[str]]` | `None` | Extras, e.g. `{"dev": [*DEV_DEPENDENCIES]}`. The `dev` extra is what CI and Read the Docs install. |
| `ruff_ignore_list` | `list[RuffIgnoredInspection]` | `None` | Global ruff rule ignores. |
| `ruff_file_based_ignore_list` | `list[RuffFilePatternIgnoredInspection]` | `None` | Per-file-pattern ruff ignores. |
| `script_executables` | `list[ScriptExecutable]` | `[]` | Console entry points, each `ScriptExecutable(name, import_path)`. |
| `gitignore_list` | `list[str]` | `[]` | Extra `.gitignore` entries appended to the defaults. |

`ReadmeContent(tagline, content, uses_internationalisation=True)` controls the generated README: `tagline` is the
short headline, `content` is the free-form body, and `uses_internationalisation` toggles the translation-workflow
section in `CONTRIBUTING.md`.

Useful presets live in `ambient_package_update.metadata.constants`: `DEV_DEPENDENCIES`, `SUPPORTED_PYTHON_VERSIONS`,
`SUPPORTED_DJANGO_VERSIONS`, the `LICENSE_*` values, and the `DEPLOYMENT_STATUS_*` classifiers.

- Install the `ambient_package_update` package
  ```
  # ideally in a virtual environment
  pip install ambient-package-update
  ```
- Add `docs/index.rst` and link your readme and changelog to have a basic documentation (surely, you can add or write
  more custom docs if you want!)
- Enable the readthedocs hook in your GitHub repo to update your documentation on a commit basis
- Finally, follow the steps of the section above (`How to update a package`).

### Customizing the templates

To customize the templates, you can use the `eject-template` command.
Simply run

```bash
python -m ambient_package_update.cli eject-template
```

from the root of your project and select the template you want to eject.
The chosen template will be copied to `.ambient-package-update/templates`, ready to be customized.

If you want to overwrite template manually, you can find the default templates in the `ambient_package_update/templates` directory.
You can overwrite them by creating a `.ambient-package-update/templates` directory in your project
and create a new file with the same name as the template you want to overwrite.

## Releasing a new version

Releases are fully automated. Push a version tag and the pipeline will build, sign with
[Sigstore](https://www.sigstore.dev/), publish to PyPI via
[Trusted Publishing](https://docs.pypi.org/trusted-publishers/), and create a GitHub Release —
no API tokens needed.

```bash
git tag v<version>          # e.g. git tag v26.3.1
git push origin v<version>
```

Tags **must** start with `v`. Tags without the prefix won't trigger the pipeline.

### First-time setup

Before the pipeline can run for the first time, an admin must:

1. **Create GitHub Environment `pypi`**
   - Go to *Settings → Environments → New environment*, name it exactly `pypi`
   - Under *Deployment branches and tags*, add a tag rule with pattern `v*`
   - Optionally add required reviewers for a manual approval gate

2. **Configure PyPI Trusted Publisher**
   - Go to *PyPI → Project settings → Publishing → Add a new publisher*
   - Fill in: Owner `ambient-innovation`, Repository `ambient-package-update`,
     Workflow `release.yml`, Environment `pypi`

## Changelog

Can be found at [GitHub](https://github.com/ambient-innovation/ambient-package-update/blob/master/CHANGES.md).
