pip install -U pip-tools
pip-compile --extra {% for area, dependency_list in optional_dependencies.items() %}{{ area }},{% endfor %} -o requirements.txt pyproject.toml --resolver=backtracking
pip-sync
