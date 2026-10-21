#!/bin/bash
pip install -U uv
uv sync{% for area, dependency_list in optional_dependencies.items() %} --extra {{ area }}{% endfor %}
