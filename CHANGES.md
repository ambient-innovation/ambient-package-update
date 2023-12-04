# Changelog

**23.12.1 (2023-12-04)**
* Added Django 5.0 support
* Updated Ruff version

**23.11.2 (2023-11-20)**
* Added typer as package dev dependency
* Improved Readme template

**23.11.1 (2023-11-17)**
* Improved Readme template

* **23.10.8 (2023-11-06)**
* Minimum coverage new configurable
* Added `flake8-todo` to Ruff rules

**23.10.7 (2023-11-03)**
* Fixed bug in coverage configuration

**23.10.6 (2023-11-03)**
* Replaced `black` formatter with `ruff format`
* Improved coverage configuration

**23.10.5 (2023-10-26)**
* Fixed RTD build

**23.10.4 (2023-10-26)**
* Fixed migration validator to GitHub actions

**23.10.3 (2023-10-26)**
* Added custom_installation metadata (renamed from `installation`)
* Added additional_information metadata
* Added flag for rendering migration related things in metadata
* Added migration validator to GitHub actions
* Removed HTML coverage report in GitHub actions
* Updated readthedocs.yml template

**23.10.2 (2023-10-20)**
* Add coverage check to CI pipeline
* Enforced 100% coverage and added badge
* Updated dependencies and linters
* Made supported Django and Python versions compatible
* Added pip-tools script to install all dependencies
* Added "PL" and "PERF" rules for ruff

**23.10.1 (2023-10-04)**
* Added Python 3.12 support
* Updated linting packages

**23.9.5 (2023-09-08)**
* Adjusted scripts directory structure (by OS)

**23.9.4 (2023-09-08)**
* Fixed configuration bug for GitHub actions

**23.9.3 (2023-09-08)**
* Used improved black mirror for pre-commit

**23.9.2 (2023-09-08)**
* Added license label to pyproject.toml dynamically

**23.9.1 (2023-09-08)**
* Added black badge for Readme files

**23.8.5 (2023-08-31)**
* Fixed a bug with the URL of the download badge in the Readme template

**23.8.4 (2023-08-28)**
* **Breaking change:** Added company field in package metadata
* Licenses can now be chosen (MIT or GPL)
* Integrated PyUpgrade linter via ruff for updater-package
* Updated linter packages

**23.8.3 (2023-08-14)**
* Fixed linting bug in Sphinx config

**23.8.1 (2023-08-14)**
* Extended ruff linting
* Updated linter packages

**23.7.4 (2023-08-02)**
* Removed duplicated badges

**23.7.3 (2023-08-02)**
* Updated linters
* Updated readme to show that this is a general purpose package
* Added PyPI badge to rendered readme

* **23.7.2 (2023-07-25)**
* Bugfix with supported Django versions

**23.7.1 (2023-07-25)**
* Dropped Django version 2.2, 3.0, 3.1, 4.0 due to deprecation
* Updated pre-commit linter versions
* Updated versions for meta package
* Added installation docs to Readme file

**23.5.12 (2023-05-10)**
* Added docs about adding documentation to your package
* Removed deprecated shell scripts for local development

**23.5.11 (2023-05-10)**
* Improved templating and add more possible meta information
* Updated flit base version
* Improved CLI and documentation

**23.5.10 (2023-05-10)**
* Sorted shell scripts in by OS
* Added script to update all supported target packages
* Updated linting

**23.5.9 (2023-05-09)**
* Dynamically imported package dependency version of this package to avoid forgetting to update it

**23.5.8 (2023-05-09)**
* Improved UX of template rendering command
* Updated meta docs how to create a new package

**23.5.7 (2023-05-09)**
* Updated docs about package dependency to updater

**23.5.6 (2023-05-09)**
* Updated project readme
* Updated package readme template
* Added UNIX script for local setup

**23.5.5 (2023-05-04)**
* Django 4.2
* Linter updates

**23.5.4 (2023-05-04)**
* Improved documentation
* Added further code quality templates

**23.5.3 (2023-05-04)**
* Improved rendered readme file

**23.5.2 (2023-05-03)**
* Templates render a trailing newline (to conform with Python linting)

**23.5.1 (2023-05-03)**
* Initial release
