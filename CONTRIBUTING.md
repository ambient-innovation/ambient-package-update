# Contribution

## Dependency updates

The dependencies of this package are being maintained with `pip-tools`.

> pip install -U pip-tools

To add/update/remove a package, please do so in the main `pyproject.toml`. Afterward, call the following command to
reflect your changes in the `requirements.txt`.

> pip-compile --extra dev -o requirements.txt pyproject.toml --resolver=backtracking

To install the packages, run:

> pip-sync

## Publish to PyPi

- Update documentation about new/changed functionality

- Update the `Changelog`

- Increment version in main `__init__.py`

- Increment version of this package in dependencies in `ambient_package_update/metadata/constants.py`

- Create pull request / merge to master

- This project uses the flit package to publish to PyPI. Thus, publishing should be as easy as running:

  ```
  flit publish
  ```

  To publish to TestPyPI use the following to ensure that you have set up your .pypirc as
  shown [here](https://flit.readthedocs.io/en/latest/upload.html#using-pypirc) and use the following command:

  ```
  flit publish --repository testpypi
  ```
