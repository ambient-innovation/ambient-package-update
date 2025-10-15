echo "Install uv"
pip install uv
echo "Install Python dependencies"
uv sync --frozen{% for area, dependency_list in optional_dependencies.items() %} --extra {{ area }}{% endfor %}
echo "Install git hooks"
pre-commit install -t pre-push -t pre-commit --install-hooks
