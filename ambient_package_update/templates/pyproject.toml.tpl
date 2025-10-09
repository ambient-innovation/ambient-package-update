[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[project]
name = "{{ module_name }}"
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
dynamic = ["version"]
description = "{{ claim }}"
license = {"file" = "LICENSE.md"}
requires-python = ">={{ supported_python_versions.0 }}"
dependencies = [{% for dependency in dependencies %}
    '{{ dependency }}',{% endfor %}
]

{% for script_executable in script_executables %}
scripts.{{ script_executable.name }} = "{{ script_executable.import_path }}"{% endfor %}

{% if optional_dependencies %}
[dependency-groups]{% for area, dependency_list in optional_dependencies.items() %}
{{ area }} = [{% for dependency in dependency_list %}
   '{{ dependency }}',{% endfor %}
]{% endfor %}{% endif %}

[project.urls]
'Homepage' = 'https://github.com/{{ github_package_group|replace("_", "-") }}/{{ github_package_name|replace("_", "-") }}/'
'Documentation' = 'https://{{ package_name|replace("_", "-") }}.readthedocs.io/en/latest/index.html'
'Maintained by' = '{{ maintainer.url }}'
'Bugtracker' = 'https://github.com/{{ github_package_group|replace("_", "-") }}/{{ github_package_name|replace("_", "-") }}/issues'
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
    "RUF",     # Ruff-specific rules
    "YTT",     # Avoid non-future-prove usages of "sys"
    "C4",      # Checks for unnecessary conversions
    "PIE",     # Bunch of useful rules
    "INT",     # Validates your gettext translation strings
    "PERF",    # PerfLint
    "PGH",     # No all-purpose "# noqa" and eval validation
    "PL",      # PyLint
    "LOG",     # flake8-logging
    "TID",     # flake8-tidy-imports
    "PLR2004", # Magic numbers
    "BLE",     # Checks for except clauses that catch all exceptions
    "ANN401",  # Checks that function arguments are annotated with a more specific type than Any
    "TRY",     # Clean try/except
    "ERA",     # Commented out code
    "INP",     # Ban PEP-420 implicit namespace packages
    "C90",     # McCabe code complexity
    "FURB",    # Refurbish Python code
]
lint.ignore = [{% for ruff_ignore in ruff_ignore_list %}
    "{{ ruff_ignore.key }}", # {{ ruff_ignore.comment }}{% endfor %}
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
    "RUF",     # Ruff-specific rules
    "YTT",     # Avoid non-future-prove usages of "sys"
    "C4",      # Checks for unnecessary conversions
    "PIE",     # Bunch of useful rules
    "INT",     # Validates your gettext translation strings
    "PERF",    # PerfLint
    "PGH",     # No all-purpose "# noqa" and eval validation
    "PL",      # PyLint
    "LOG",     # flake8-logging
    "TID",     # flake8-tidy-imports
    "PLR2004", # Magic numbers
    "BLE",     # Checks for except clauses that catch all exceptions
    "ANN401",  # Checks that function arguments are annotated with a more specific type than Any
    "TRY",     # Clean try/except
    "ERA",     # Commented out code
    "INP",     # Ban PEP-420 implicit namespace packages
    "C90",     # McCabe code complexity
    "FURB",    # Refurbish Python code
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
lint.dummy-variable-rgx = "^(_+|(_+[a-zA-Z0-9_]*[a-zA-Z0-9]+?))$"

# Assume Python 3.13
target-version = "py313"

[tool.ruff.format]
# Like Black, use double quotes for strings.
quote-style = "double"

# Like Black, indent with spaces, rather than tabs.
indent-style = "space"

# Like Black, respect magic trailing commas.
skip-magic-trailing-comma = false

# Like Black, automatically detect the appropriate line ending.
line-ending = "auto"

[tool.ruff.lint.per-file-ignores]
"**/__init__.py" = [
  # Allow seemingly unused imports
  "F401",
]
"**/tests/**/test_*.py" = [
  # Allow boolean positional params in tests (for assertIs())
  "FBT003",
]
"scripts/*.py" = [
  # Checks for packages that are missing an __init__.py file
  "INP001",
]
".ambient-package-update/*.py" = [
  # Checks for packages that are missing an __init__.py file
  "INP001",
]
"docs/*.py" = [
  # Checks for packages that are missing an __init__.py file
  "INP001",
]
{% if ruff_file_based_ignore_list %}{% for ruff_file_ignore in ruff_file_based_ignore_list %}"{{ ruff_file_ignore.pattern }}" = [{% for ruff_rule in ruff_file_ignore.rules %}
  # {{ ruff_rule.comment }}
  "{{ ruff_rule.key }}",{% endfor %}
]{% endfor %}
{% endif %}
[tool.tox]
requires = ["tox>=4", "tox-uv>=1.0.0"]
env_list = [{% for django_version in supported_django_versions %}"django{{ django_version|replace(".", "") }}", {% endfor %}]

[tool.tox.env_run_base]
# Django deprecation overview: https://www.djangoproject.com/download/
package = "wheel"
wheel_build_env = ".pkg"
runner = "uv-venv-lock-runner"
dependency_groups = [{% for area, dependency_list in optional_dependencies.items() %}"{{ area }}", {% endfor %}]
commands = [
    ["pytest", "--cov={{ module_name }}", "--cov-report=term", "--cov-report=xml", {% if tests_require_django %}"--ds", "settings", {% endif %}"tests"]
]

{% for django_version in supported_django_versions %}[tool.tox.env.django{{ django_version|replace(".", "") }}]
deps = ["Django=={{ django_version }}.*"]

{% endfor %}

[tool.tox.gh_actions.python]{% for python_version in supported_python_versions %}
"{{ python_version }}" = "py{{ python_version|replace(".", "") }}"{% endfor %}

[tool.pytest.ini_options]
python_files = [
    "tests.py",
    "test_*.py",
    "*_tests.py",
]

[tool.coverage.run]
branch = true
parallel = true
source = [
    "{{ module_name }}",
    "tests",
]
omit = [
  "setup.py",
  "*_test.py",
  "tests.py",
  "testapp/*",
  "tests/*",
]

[tool.coverage.report]
precision = 2
show_missing = true
# Regexes for lines to exclude from consideration
exclude_also = [
    # Don't complain if tests don't hit defensive assertion code:
    "raise AssertionError",
    "raise NotImplementedError",
    # Don't check type hinting imports
    "if typing.TYPE_CHECKING:",
    "if TYPE_CHECKING:",
]

[tool.coverage.path]
source = [
    "{{ module_name }}",
    ".tox/**/site-packages",
]

[tool.hatch.version]
path = "{{ module_name }}/__init__.py"
