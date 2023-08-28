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
    "Framework :: Django",
    "Framework :: Django :: 3.2",
    "Framework :: Django :: 4.1",
    "Framework :: Django :: 4.2",
    "Intended Audience :: Developers",
    "License :: OSI Approved :: MIT License",
    "Natural Language :: English",
    "Operating System :: OS Independent",
    "Programming Language :: Python",
    "Programming Language :: Python :: 3",
    "Programming Language :: Python :: 3.8",
    "Programming Language :: Python :: 3.9",
    "Programming Language :: Python :: 3.10",
    "Programming Language :: Python :: 3.11",
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
'Homepage' = 'https://github.com/ambient-innovation/{{ package_name|replace("_", "-") }}/'
'Documentation' = 'https://{{ package_name|replace("_", "-") }}.readthedocs.io/en/latest/index.html'
'Maintained by' = 'https://ambient.digital/'
'Bugtracker' = 'https://github.com/ambient-innovation/{{ package_name|replace("_", "-") }}/issues'
'Changelog' = 'https://{{ package_name|replace("_", "-") }}.readthedocs.io/en/latest/features/changelog.html'


[tool.black]
# use force-exclude, so that black also applies exclude when run using pre-commit: https://github.com/psf/black/issues/395
force-exclude = '''.*/migrations/.*'''
line-length = 120
multi_line_output = 3
skip-string-normalization = true
include_trailing_comma = true

[tool.ruff]
select = [
    "E",       # pycodestyle errors
    "W",       # pycodestyle warnings
    "F",       # Pyflakes
    "N",       # pep8-naming
    "I",       # isort
    "B",       # flake8-bugbear
    "A",       # flake8-builtins
    "DTZ",     # flake8-datetimez
    "DJ",      # flake8-django
    "RUF100",  # Removes unnecessary "#noqa" comments
    "YTT",     # Avoid non-future-prove usages of "sys"
    # "FBT",     # Protects you from the "boolean trap bug"
    "C4",      # Checks for unnecessary conversions
    "PIE",     # Bunch of useful rules
    # "SIM",     # Simplifies your code
    "INT",     # Validates your gettext translation strings
    "PGH",     # No all-purpose "# noqa" and eval validation
    # "UP",      # PyUpgrade
]
ignore = [{% for ruff_ignore in ruff_ignore_list %}
    '{{ ruff_ignore.key }}', # {{ ruff_ignore.comment }}{% endfor %}
]

# Allow autofix for all enabled rules (when `--fix`) is provided.
fixable = [
    "E",       # pycodestyle errors
    "W",       # pycodestyle warnings
    "F",       # Pyflakes
    "N",       # pep8-naming
    "I",       # isort
    "B",       # flake8-bugbear
    "A",       # flake8-builtins
    "DTZ",     # flake8-datetimez
    "DJ",      # flake8-django
    "RUF100",  # Removes unnecessary "#noqa" comments
    "YTT",     # Avoid non-future-prove usages of "sys"
    # "FBT",     # Protects you from the "boolean trap bug"
    "C4",      # Checks for unnecessary conversions
    "PIE",     # Bunch of useful rules
    # "SIM",     # Simplifies your code
    "INT",     # Validates your gettext translation strings
    "PGH",     # No all-purpose "# noqa" and eval validation
    # "UP",      # PyUpgrade
]
unfixable = []

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

# Assume Python 3.11
target-version = "py311"

[tool.tox]
legacy_tox_ini = """
[tox]
envlist = py{38,39,310,311}-django{32,41,42}
isolated_build = True

[testenv]
# Django deprecation overview: https://www.djangoproject.com/download/
deps =
    django32: Django>=3.2,<3.3
    django41: Django>=4.1,<4.2
    django42: Django>=4.2,<4.3
extras = {% for area, dependency_list in optional_dependencies.items() %}{{ area }},{% endfor %}
commands =
    pytest --ds settings tests

[gh-actions]
python =
    3.8: py38
    3.9: py39
    3.10: py310
    3.11: py311
"""
