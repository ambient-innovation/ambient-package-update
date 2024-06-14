name: Unit tests

on:
  push:
    branches: [ '**' ]

jobs:
  linting:
    runs-on: ubuntu-22.04
    steps:
      - uses: actions/checkout@v4

      - name: Set up Python 3.12
        uses: actions/setup-python@v5
        with:
          python-version: "3.12"

      - name: Install required packages
        run: pip install pre-commit

      - name: Run pre-commit hooks
        run: pre-commit run --all-files --hook-stage push
  {% if has_migrations %}
  validate_migrations:
    name: Validate migrations
    runs-on: ubuntu-22.04
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: '3.12'

      - name: Install dependencies
        run: python -m pip install -U pip-tools && pip-compile --extra {% for area, dependency_list in optional_dependencies.items() %}{{ area }},{% endfor %} -o requirements.txt pyproject.toml --resolver=backtracking && pip-sync

      - name: Validate migration integrity
        run: python manage.py makemigrations --check --dry-run{% endif %}

  tests:
    name: Python ${% raw %}{{ matrix.python-version }}{% endraw %}, django ${% raw %}{{ matrix.django-version }}{% endraw %}
    runs-on: ubuntu-22.04
    strategy:
      matrix:
        python-version: [{% for python_version in supported_python_versions %}'{{ python_version }}', {% endfor %}]
        django-version: [{% for django_version in supported_django_versions %}'{{ django_version|replace(".", "") }}', {% endfor %}]

        exclude:
          - python-version: '3.8'
            django-version: 50
          - python-version: '3.9'
            django-version: 50

    steps:
      - uses: actions/checkout@v4
      - name: setup python
        uses: actions/setup-python@v5
        with:
          python-version: ${% raw %}{{ matrix.python-version }}{% endraw %}
      - name: Install tox
        run: pip install tox
      - name: Run Tests
        env:
          TOXENV: django${% raw %}{{ matrix.django-version }}{% endraw %}
        run: tox
      - name: Upload coverage data
        uses: actions/upload-artifact@v3
        with:
          name: coverage-data
          path: '.coverage*'

  coverage:
    name: Coverage
    runs-on: ubuntu-22.04
    needs: tests
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: '3.12'

      - name: Install dependencies
        run: python -m pip install --upgrade coverage[toml]

      - name: Download data
        uses: actions/download-artifact@v3
        with:
          name: coverage-data

      - name: Combine coverage and fail if it's <100%
        run: |
          python -m coverage html --skip-covered --skip-empty
          python -m coverage report --fail-under={{ min_coverage }}
