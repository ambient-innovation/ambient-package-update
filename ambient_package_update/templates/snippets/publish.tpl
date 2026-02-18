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

### Publishing to PyPI

```bash
# One-time setup
keyring set https://test.pypi.org/legacy/ __token__
# paste TestPyPI token
keyring set https://upload.pypi.org/legacy/ __token__
# paste prod PyPI token
```

To publish to the production PyPI:

```bash
uv publish --username __token__
```

To publish to TestPyPI first (recommended for testing):

```bash
uv publish --publish-url https://test.pypi.org/legacy/ --username __token__
```

You can then test the installation from TestPyPI:

```bash
uv pip install --index-url https://test.pypi.org/simple/ ambient-package-update
```
