# Changelog

**24.11.7 (2024-11-20)**
* Added possibility to add script executables
* Added flag for non-django packages
* Fixed a "None" value on empty Readme content template

**24.11.6 (2024-11-20)**
* Fixed a bug in ".gitignore" template

**24.11.5 (2024-11-20)**
* Improved usage of `blacken-docs`
* Fixed a naming issue with security template

**24.11.4 (2024-11-19)**
* Added .gitignore template

**24.11.3 (2024-11-19)**
* Fixed a bug with switched `package_name` and `module_name` variables in templates
* Updated linters
* Improved some readme texts

**24.11.2 (2024-11-15)**
* Updated Ubuntu images to latest 24.04 from 22.04

**24.11.1 (2024-11-12)**
* Added branch naming convention checker via pre-commit

**24.10.1 (2024-10-08)**
* Added Python 3.13 support
* Added Djade linter to pre-commit
* Improved GitHub action triggers
* Updated dev dependencies and linters

**24.9.4 (2024-09-11)**
* Added `lstrip_blocks` to Jinja renderer
* Set package stability to "production"

**24.9.3 (2024-09-11)**
* Added GitHub action trigger for PRs

**24.9.2 (2024-09-11)**
* Fixed coverage setup in pipeline

**24.9.1 (2024-09-11)**
* Fixed issue with package name having underscores instead of hyphens
* Linter updates

**24.8.2 (2024-08-12)**
* Added test matrix exception for Python 3.9 and Django 5.1

**24.8.1 (2024-08-12)**
* Added Django 5.1 support
* Linter updates

**24.7.8 (2024-07-18)**
* Fixed a bug with dependency to this package

**24.7.7 (2024-07-18)**
* Added SECURITY.md to templates
* Added new meta variable `github_package_group` to enable package maintenance not by Ambient
* Replaced fixed updater dependency version with asterisk import to avoid crashing pipelines due to pip caching in
  GitHub actions
* Updated linters

**24.7.6 (2024-07-16)**
* Bugfix with GitHub actions

**24.7.5 (2024-07-16)**
* Bugfix with GitHub action runner variable

**24.7.4 (2024-07-16)**
* Updated GitHub actions for coverage jobs

**24.7.3 (2024-07-15)**
* Removed Pydocstyle linting rules

**24.7.2 (2024-07-15)**
* Text change in coverage action
* Removed deprecated tox configuration

**24.7.1 (2024-07-15)**
* Dropped Python 3.8 support
* Added loads of Ruff linting rules

**24.6.5 (2024-06-24)**
* Added `eject-templates` command
* Fixed issue with `module_name`
* Updated dev dependencies in template toml

**24.6.4 (2024-06-21)**
* Added linter `blacken-docs` to pre-commit template

**24.6.3 (2024-06-20)**
* Removed `custom_installation` and `additional_installation` from class `ReadmeContent`

**24.6.2 (2024-06-20)**
* Added new feature of customizable templates

**24.6.1 (2024-06-14)**
* Added `module_name` variable to Package metadata
* Added opt-out for internationalisation content in Readme-file
* Removed fixed links to Ambient as a maintainer in templates
* Updated linters
* Removed Django 3.2 from test matrix

**24.4.4 (2024-04-11)**
* Updated ruff configuration

**24.4.3 (2024-04-11)**
* Linting fixes 😎

**24.4.2 (2024-04-11)**
* Updated Changelog.md

**24.4.1 (2024-04-11)**
* Dropped Django 3.2 & 4.1
* Updated linters
* Updated some GitHub actions
* Moved pytest config to pyproject.toml

**23.12.4 (2023-12-05)**
* Added optional GitHub package name
* Added "flit" to package dev dependencies

**23.12.3 (2023-12-05)**
* Dependency-Constants updated

**23.12.2 (2023-12-04)**
* Fixed test pipeline configuration

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
