name: Unit tests

on:
  push:
    branches:
    - {{ main_branch }}
  pull_request:

jobs:
  linting:
    runs-on: ubuntu-24.04
    steps:
      - uses: actions/checkout@v4

      - name: Set up Python 3.13
        uses: actions/setup-python@v5
        with:
          python-version: "3.13"

      - name: Install required packages
        run: pip install pre-commit

      - name: Run pre-commit hooks
        run: pre-commit run --all-files
  {% if has_migrations %}
  validate_migrations:
    name: Validate migrations
    runs-on: ubuntu-24.04
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: '3.13'

      - name: Install dependencies
      # todo
        run: python -m pip install -U uv && uv sync --frozen {% for area, dependency_list in optional_dependencies.items() %}--group {{ area }}{% endfor %}

      - name: Validate migration integrity
        run: python manage.py makemigrations --check --dry-run{% endif %}

  tests:
    name: Python {% raw %}${{ matrix.python-version }}{% endraw %}, django {% raw %}${{ matrix.django-version }}{% endraw %}
    runs-on: ubuntu-24.04
    strategy:
      matrix:
        python-version: [{% for python_version in supported_python_versions %}'{{ python_version }}', {% endfor %}]
        django-version: [{% for django_version in supported_django_versions %}'{{ django_version|replace(".", "") }}', {% endfor %}]

        exclude:
          - python-version: '3.9'
            django-version: 52
          - python-version: '3.9'
            django-version: 51
          - python-version: "3.13"
            django-version: 42

    steps:
      - uses: actions/checkout@v4
      - name: setup python
        uses: actions/setup-python@v5
        with:
          python-version: {% raw %}${{ matrix.python-version }}{% endraw %}
      - name: Install uv
        uses: astral-sh/setup-uv@v5
      - name: Install tox
        run: uv tool install tox --with tox-uv
      - name: Run Tests
        env:
          TOXENV: django{% raw %}${{ matrix.django-version }}{% endraw %}
        run: tox
      - name: Upload coverage data
        uses: actions/upload-artifact@v4
        with:
          name: coverage-data-{% raw %}${{ matrix.python-version }}-${{ matrix.django-version }}{% endraw %}
          path: '{% raw %}${{ github.workspace }}{% endraw %}/.coverage'
          include-hidden-files: true
          if-no-files-found: error

  coverage:
    name: Coverage
    runs-on: ubuntu-24.04
    needs: tests
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: '3.13'

      - name: Install dependencies
        run: python -m pip install --upgrade coverage[toml]

      - name: Download data
        uses: actions/download-artifact@v4
        with:
          path: {% raw %}${{ github.workspace }}{% endraw %}/coverage-reports
          pattern: coverage-data-*
          merge-multiple: false

      - name: Combine coverage and fail if it's <{{ min_coverage }}%
        run: |
          python -m coverage combine coverage-reports/*/.coverage
          python -m coverage xml
          python -m coverage html --skip-covered --skip-empty
          python -m coverage report --fail-under={{ min_coverage }}
          echo "## Coverage summary" >> $GITHUB_STEP_SUMMARY
          python -m coverage report --format=markdown >> $GITHUB_STEP_SUMMARY
