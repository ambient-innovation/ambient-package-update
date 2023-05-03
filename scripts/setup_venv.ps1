echo "Create virtualenv"
python -m venv .venv
echo "Activate virtualenv"
.venv/Scripts/activate
echo "Update pip"
python.exe -m pip install --upgrade pip
echo "Install pip-tools"
pip install pip-tools
echo "Render requirements file"
pip-compile --extra=dev -o requirements.txt pyproject.toml --resolver=backtracking
echo "Install python dependencies"
pip-sync
echo "Install git hooks"
pre-commit install -t pre-push -t pre-commit --install-hooks
