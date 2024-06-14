[build-system]
requires = ["flit_core>=3.4"]
build-backend = "flit_core.buildapi"

[project]
name = "{{ package_name|replace("_", "-") }}"
authors = [{% for author in authors %}
    {'name' = '{{ author.name }}', 'email' = '{{ author.email }}'},{% endfor %}
]
readme = "README.md"
classifiers = [
    "Development Status :: {{ development_status }}",
    "Environment :: Web Environment",
    "Framework :: Django",{% for django_version in supported_django_versions %}
    "Framework :: Django :: {{ django_version }}",{% endfor %}
    "Intended Audience :: Developers",
    "License :: OSI Approved :: {{ license_label }}",
    "Natural Language :: English",
    "Operating System :: OS Independent",
    "Programming Language :: Python",
    "Programming Language :: Python :: 3",{% for python_version in supported_python_versions %}
    "Programming Language :: Python :: {{ python_version }}",{% endfor %}
    "Topic :: Utilities",
]
dynamic = ["version", "description"]
license = {"file" = "LICENSE.md"}
dependencies = [{% for dependency in dependencies %}
    '{{ dependency }}',{% endfor %}
]

{% if optional_dependencies %}
[project.optional-dependencies]{% for area, dependency_list in optional_dependencies.items() %}
{{ area }} = [{% for dependency in dependency_list %}
   '{{ dependency }}',{% endfor %}
]{% endfor %}{% endif %}

[tool.flit.module]
name = "{{ package_name }}"

[project.urls]
'Homepage' = 'https://github.com/ambient-innovation/{{ github_package_name|replace("_", "-") }}/'
'Documentation' = 'https://{{ package_name|replace("_", "-") }}.readthedocs.io/en/latest/index.html'
'Maintained by' = '{{ maintainer.url }}'
'Bugtracker' = 'https://github.com/ambient-innovation/{{ github_package_name|replace("_", "-") }}/issues'
'Changelog' = 'https://{{ package_name|replace("_", "-") }}.readthedocs.io/en/latest/features/changelog.html'

[tool.ruff]
lint.select = [
    "E",       # pycodestyle errors
    "W",       # pycodestyle warnings
    "F",       # Pyflakes
    "N",       # pep8-naming
    "I",       # isort
    "B",       # flake8-bugbear
    "A",       # flake8-builtins
    "DTZ",     # flake8-datetimez
    "DJ",      # flake8-django
    "TD",      # flake8-to-do
    "RUF100",  # Removes unnecessary "#noqa" comments
    "YTT",     # Avoid non-future-prove usages of "sys"
    # "FBT",     # Protects you from the "boolean trap bug"
    "C4",      # Checks for unnecessary conversions
    "PIE",     # Bunch of useful rules
    # "SIM",     # Simplifies your code
    "INT",     # Validates your gettext translation strings
    "PERF",    # PerfLint
    "PGH",     # No all-purpose "# noqa" and eval validation
    "PL",      # PyLint
]
lint.ignore = [{% for ruff_ignore in ruff_ignore_list %}
    '{{ ruff_ignore.key }}', # {{ ruff_ignore.comment }}{% endfor %}
]

# Allow autofix for all enabled rules (when `--fix`) is provided.
lint.fixable = [
    "E",       # pycodestyle errors
    "W",       # pycodestyle warnings
    "F",       # Pyflakes
    "N",       # pep8-naming
    "I",       # isort
    "B",       # flake8-bugbear
    "A",       # flake8-builtins
    "DTZ",     # flake8-datetimez
    "DJ",      # flake8-django
    "TD",      # flake8-to-do
    "RUF100",  # Removes unnecessary "#noqa" comments
    "YTT",     # Avoid non-future-prove usages of "sys"
    # "FBT",     # Protects you from the "boolean trap bug"
    "C4",      # Checks for unnecessary conversions
    "PIE",     # Bunch of useful rules
    # "SIM",     # Simplifies your code
    "INT",     # Validates your gettext translation strings
    "PERF",    # PerfLint
    "PGH",     # No all-purpose "# noqa" and eval validation
    "PL",      # PyLint
]
lint.unfixable = []

exclude = [
    ".bzr",
    ".direnv",
    ".eggs",
    ".git",
    ".hg",
    ".mypy_cache",
    ".nox",
    ".pants.d",
    ".pytype",
    ".ruff_cache",
    ".svn",
    ".tox",
    ".venv",
    "__pypackages__",
    "_build",
    "buck-out",
    "build",
    "dist",
    "node_modules",
    "venv",
    "*/migrations/*"
]

# Same as Black.
line-length = 120

# Allow unused variables when underscore-prefixed.
dummy-variable-rgx = "^(_+|(_+[a-zA-Z0-9_]*[a-zA-Z0-9]+?))$"

# Assume Python 3.12
target-version = "py312"

[tool.ruff.format]
# Like Black, use double quotes for strings.
quote-style = "double"

# Like Black, indent with spaces, rather than tabs.
indent-style = "space"

# Like Black, respect magic trailing commas.
skip-magic-trailing-comma = false

# Like Black, automatically detect the appropriate line ending.
line-ending = "auto"

[tool.tox]
legacy_tox_ini = """
[tox]
envlist = py{38,39,310,311}-django{32,41,42}
isolated_build = True

[testenv]
# Django deprecation overview: https://www.djangoproject.com/download/
deps ={% for django_version in supported_django_versions %}
    django{{ django_version|replace(".", "") }}: Django=={{ django_version }}.*{% endfor %}
extras = {% for area, dependency_list in optional_dependencies.items() %}{{ area }},{% endfor %}
commands =
    coverage run -m pytest --ds settings tests

[gh-actions]
python ={% for python_version in supported_python_versions %}
    {{ python_version }}: py{{ python_version|replace(".", "") }}{% endfor %}
"""

[tool.pytest.ini_options]
python_files = [
    "tests.py",
    "test_*.py",
    "*_tests.py",
]
