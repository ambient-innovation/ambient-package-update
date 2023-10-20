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
        uses: actions/setup-python@v4
        with:
          python-version: "3.12"

      - name: Install required packages
        run: pip install pre-commit

      - name: Run pre-commit hooks
        run: pre-commit run --all-files --hook-stage push

  tests:
    name: Python ${% raw %}{{ matrix.python-version }}{% endraw %}, django ${% raw %}{{ matrix.django-version }}{% endraw %}
    runs-on: ubuntu-22.04
    strategy:
      matrix:
        python-version: [{% for python_version in supported_python_versions %}'{{ python_version }}', {% endfor %}]
        django-version: [{% for django_version in supported_django_versions %}'{{ django_version|replace(".", "") }}', {% endfor %}]

        exclude:
          - python-version: '3.12'
            django-version: 32
          - python-version: '3.11'
            django-version: 32
          - python-version: '3.10'
            django-version: 32

    steps:
      - uses: actions/checkout@v4
      - name: setup python
        uses: actions/setup-python@v4
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

      - uses: actions/setup-python@v4
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
          # python -m coverage combine
          python -m coverage html --skip-covered --skip-empty
          python -m coverage report --fail-under=100

      - name: Upload HTML report
        if: ${% raw %}{{ failure() }}{% endraw %}
        uses: actions/upload-artifact@v3
        with:
          name: html-report
          path: htmlcov
