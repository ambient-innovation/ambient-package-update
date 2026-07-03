name: CI jobs

on:
  workflow_call:

jobs:
  linting:
    runs-on: ubuntu-24.04
    steps:
      - uses: actions/checkout@v6

      - name: Set up Python {{ supported_python_versions|last }}
        uses: actions/setup-python@v6
        with:
          python-version: "{{ supported_python_versions|last }}"

      - name: Install required packages
        run: pip install pre-commit

      - name: Run pre-commit hooks
        run: pre-commit run --all-files
  {% if has_migrations %}
  validate_migrations:
    name: Validate migrations
    runs-on: ubuntu-24.04
    steps:
      - uses: actions/checkout@v6

      - uses: actions/setup-python@v6
        with:
          python-version: '{{ supported_python_versions|last }}'

      - name: Install dependencies
        run: python -m pip install -U uv && uv sync --frozen{% for area, dependency_list in optional_dependencies.items() %} --extra {{ area }}{% endfor %}

      - name: Validate migration integrity
        run: uv run python manage.py makemigrations --check --dry-run{% endif %}

  tests:
    name: Python {% raw %}${{ matrix.python-version }}{% endraw %}, django {% raw %}${{ matrix.django-version }}{% endraw %}
    runs-on: ubuntu-24.04
    strategy:
      matrix:
        python-version: [{% for python_version in supported_python_versions %}'{{ python_version }}', {% endfor %}]
        django-version: [{% for django_version in supported_django_versions %}'{{ django_version|replace(".", "") }}', {% endfor %}]

        # Exclude Python/Django combinations that are not supported upstream.
        # Django 4.2 supports Python <= 3.12, Django 5.2 supports Python <= 3.13,
        # Django 6.0 requires Python >= 3.12.
        exclude:
          - python-version: '3.11'
            django-version: 60
          - python-version: '3.13'
            django-version: 42
          - python-version: '3.14'
            django-version: 42
          - python-version: '3.14'
            django-version: 52

    steps:
      - uses: actions/checkout@v6
      - name: setup python
        uses: actions/setup-python@v6
        with:
          python-version: {% raw %}${{ matrix.python-version }}{% endraw %}
      - name: Install uv
        uses: astral-sh/setup-uv@v8.0.0
        with:
          cache-suffix: {% raw %}${{ github.ref_type }}{% endraw %}
      - name: Install tox
        run: uv pip install --system tox tox-uv
      - name: Run Tests
        env:
          TOXENV: django{% raw %}${{ matrix.django-version }}{% endraw %}
        run: tox
      - name: Upload coverage data
        uses: actions/upload-artifact@v7
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
      - uses: actions/checkout@v6

      - uses: actions/setup-python@v6
        with:
          python-version: '{{ supported_python_versions|last }}'

      - name: Install dependencies
        run: python -m pip install --upgrade coverage[toml]

      - name: Download data
        uses: actions/download-artifact@v8
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
