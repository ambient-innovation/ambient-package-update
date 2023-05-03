[![pypi](https://img.shields.io/pypi/v/ambient-package-update.svg)](https://pypi.python.org/pypi/ambient-package-update/)
[![Downloads](https://pepy.tech/badge/ambient-package-update)](https://pepy.tech/project/ambient-package-update)

# Ambient Package Update

This repository will help keep all Python packages maintained by 
[Ambient Digital](https://ambient.digital) tidy and up-to-date.

## Installation

1. Ensure you have installed Python >=3.10 and the binary is in your system path
2. Navigate into the project directory
3. Execute scripts/setup_venv.ps1 (on Windows) or rename the file to "setup_venv.sh" and execute it for macOS and UNIX

## Versioning

This project follows the CalVer versioning pattern: `YY.MM.[RELEASE]`

## Usage

todo:
- write usage paragraph
- package-readme hat dopplungen zu docs und enthält zeug, das nicht da drinstehen muss
- ambient-toolbox branch löschen und nur rest von core da ablegen

## Contribution

### Publish to PyPi

- Update documentation about new/changed functionality

- Update the `Changelog`

- Increment version in main `__init__.py`

- Create pull request / merge to master

- This project uses the flit package to publish to PyPI. Thus publishing should be as easy as running:
  ```
  flit publish
  ```

  To publish to TestPyPI use the following ensure that you have set up your .pypirc as
  shown [here](https://flit.readthedocs.io/en/latest/upload.html#using-pypirc) and use the following command:

  ```
  flit publish --repository testpypi
  ```

## Changelog

**23.5.2**
* Templates render a trailing newline (to conform with Python linting)

**23.5.1**
* Initial release