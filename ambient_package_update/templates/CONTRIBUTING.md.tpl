# Contribute

## Setup package for development

- Create a Python virtualenv and activate it
- Install "uv" with `pip install -U uv`
- Sync the requirements with `uv sync --frozen{% for area, dependency_list in optional_dependencies.items() %} --extra {{ area }}{% endfor %}`

## Add functionality

- Create a new branch for your feature
- Change the dependency in your requirements.txt to a local (editable) one that points to your local file system:
  `-e /Users/workspace/{{ package_name|replace("_", "-") }}` or via pip  `pip install -e /Users/workspace/{{ package_name|replace("_", "-") }}`
- Ensure the code passes the tests
- Create a pull request

## Run tests

- Run tests
  ````
  pytest --ds settings tests
  ````

- Check coverage
  ````
  coverage run -m pytest {% if tests_require_django %}--ds settings {% endif %}tests
  coverage report -m
  ````

## Git hooks (via pre-commit)

We use pre-push hooks to ensure that only linted code reaches our remote repository and pipelines aren't triggered in
vain.

To enable the configured pre-push hooks, you need to [install](https://pre-commit.com/) pre-commit and run once:

    pre-commit install -t pre-push -t pre-commit --install-hooks

This will permanently install the git hooks for both, frontend and backend, in your local
[`.git/hooks`](./.git/hooks) folder.
The hooks are configured in the [`.pre-commit-config.yaml`](templates/.pre-commit-config.yaml.tpl).

You can check whether hooks work as intended using the [run](https://pre-commit.com/#pre-commit-run) command:

    pre-commit run [hook-id] [options]

Example: run single hook

    pre-commit run ruff --all-files

Example: run all hooks of pre-push stage

    pre-commit run --all-files

## Update documentation

- To build the documentation, run: `sphinx-build docs/ docs/_build/html/`.
- Open `docs/_build/html/index.html` to see the documentation.

{% if readme_content.uses_internationalisation %}
### Translation files

If you have added custom text, make sure to wrap it in `_()` where `_` is
gettext_lazy (`from django.utils.translation import gettext_lazy as _`).

How to create translation file:

* Navigate to `{{ module_name }}`
* `python manage.py makemessages -l de`
* Have a look at the new/changed files within `{{ module_name }}/locale`

How to compile translation files:

* Navigate to `{{ module_name }}`
* `python manage.py compilemessages`
* Have a look at the new/changed files within `{{ module_name }}/locale`
{% endif %}
