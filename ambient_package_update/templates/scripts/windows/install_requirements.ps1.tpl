pip install -U uv
uv sync --frozen {% for area, dependency_list in optional_dependencies.items() %}--group {{ area }}{% endfor %}
