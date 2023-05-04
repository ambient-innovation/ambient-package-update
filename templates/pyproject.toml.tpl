[build-system]
requires = ["flit_core >=3.2,<4"]
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
    "Framework :: Django :: 2.2",
    "Framework :: Django :: 3.1",
    "Framework :: Django :: 3.2",
    "Framework :: Django :: 4.0",
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
line-length = 120
multi_line_output = 3
skip-string-normalization = true
include_trailing_comma = true

[tool.ruff]
# Enable pycodestyle (`E`) and Pyflakes (`F`) codes by default.
select = ["E", "F", "W", "N", "I", "B", "A", "DTZ", "DJ"]
ignore = [{% for ruff_ignore in ruff_ignore_list %}
    '{{ ruff_ignore.key }}', # {{ ruff_ignore.comment }}{% endfor %}
]

# Allow autofix for all enabled rules (when `--fix`) is provided.
fixable =["E", "F", "W", "N", "I", "B", "A", "DTZ", "DJ"]
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
envlist = py{38,39,310,311}-django{22,30,31,32,40,41,42}
isolated_build = True

[testenv]
deps =
    django22: Django>=2.2.28,<3.0
    django30: Django>=3.0,<3.1
    django31: Django>=3.1,<3.2
    django32: Django>=3.2,<3.3
    django40: Django>=4.0,<4.1
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
