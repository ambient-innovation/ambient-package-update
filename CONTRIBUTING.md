# Contribution

## Dependency updates

The dependencies of this package are being maintained with `uv`.

> pip install -U uv

To add/update/remove a package, please do so in the main `pyproject.toml`. Afterward, call the following command to
create a lockfile

> uv lock

To install the packages, run:

> uv sync --frozen --extra dev

### Preparation and building

This package uses [uv](https://github.com/astral-sh/uv) for dependency management and building.

- Update documentation about new/changed functionality

- Update the `CHANGES.md`

- Increment version in main `__init__.py`

- Create pull request / merge to "{{ main_branch }}"

- This project uses uv to publish to PyPI. This will create distribution files in the `dist/` directory.

  ```bash
  uv build
  ```

### Publishing to PyPI

To publish to the production PyPI:

```bash
uv publish
```

To publish to TestPyPI first (recommended for testing):

```bash
uv publish --publish-url https://test.pypi.org/legacy/
```

You can then test the installation from TestPyPI:

```bash
uv pip install --index-url https://test.pypi.org/simple/ ambient-package-update
```
