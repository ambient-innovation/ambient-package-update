### Publish to ReadTheDocs.io

- Fetch the latest changes in GitHub mirror and push them
- Trigger new build at ReadTheDocs.io (follow instructions in admin panel at RTD) if the GitHub webhook is not yet set
  up.

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

  - To publish to TestPyPI use the following to ensure that you have set up your .pypirc as
  shown [here](https://flit.readthedocs.io/en/latest/upload.html#using-pypirc) and use the following command:

  ```bash
  uv publish --repository testpypi
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
