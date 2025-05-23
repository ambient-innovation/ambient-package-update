[![PyPI release](https://img.shields.io/pypi/v/ambient-package-update.svg)](https://pypi.org/project/ambient-package-update/)
[![Downloads](https://static.pepy.tech/badge/ambient-package-update)](https://pepy.tech/project/ambient-package-update)
[![Linting](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/ruff/main/assets/badge/v2.json)](https://github.com/astral-sh/ruff)
[![Coding Style](https://img.shields.io/badge/code%20style-Ruff-000000.svg)](https://github.com/astral-sh/ruff)

# Ambient Package Update

This repository will help keep all Python packages following a certain basic structure tidy and up-to-date. It's being
maintained by [Ambient Digital](https://ambient.digital).

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
from ambient_package_update.metadata.constants import DEV_DEPENDENCIES
from ambient_package_update.metadata.package import PackageMetadata
from ambient_package_update.metadata.readme import ReadmeContent
from ambient_package_update.metadata.ruff_ignored_inspection import (
    RuffIgnoredInspection,
    RuffFilePatternIgnoredInspection,
)

METADATA = PackageMetadata(
    package_name="my_package_name",
    authors=[
        PackageAuthor(
            name="Ambient Digital",
            email="hello@ambient.digital",
        ),
    ],
    development_status="5 - Production/Stable",
    readme_content=ReadmeContent(
        tagline="A fancy tagline for your new package",
        content="""A multiline string containing specific things you want to have in your package readme.
""",
    ),
    dependencies=[
        "my_dependency>=1.0",
    ],
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

## Changelog

Can be found at [GitHub](https://github.com/ambient-innovation/ambient-package-update/blob/master/CHANGES.md).
