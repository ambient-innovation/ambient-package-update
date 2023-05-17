import os
import subprocess
import sys
from datetime import datetime, timezone
from importlib import import_module
from pathlib import Path

import typer
from jinja2 import Template

from ambient_package_update.metadata.package import PackageMetadata

BASE_PATH = Path(__file__).parent

app = typer.Typer()

"""
def deploy_to_test_pypi(package_name: str):
    subprocess.run("echo 'Publishing to test pypi'")
    subprocess.run(f"cd {package_name} && flit publish --repository testpypi")


def deploy_to_prod_pypi(package_name: str):
    subprocess.run("echo 'Publishing to production pypi'")
    subprocess.run(f"cd {package_name} && flit publish")


@app.command()
def release_package(package_name: str):
    # Render templates
    render_templates(package_name=package_name)

    # Deploy to PyPI TEST
    deploy_to_test_pypi(package_name=package_name)

    # Deploy to PyPI PROD
    deploy_to_prod_pypi(package_name=package_name)


@app.command()
def release_all_packages():
    for package in get_package_list():
        release_package(package_name=package)


@app.command()
def build_all_docs():
    for package in get_package_list():
        run_tests(package_name=package)

@app.command()
def run_all_tests():
    for package in get_package_list():
        run_tests(package_name=package)


"""


@app.command()
def get_metadata() -> PackageMetadata:
    sys.path.append("./.ambient-package-update")
    try:
        m = import_module('metadata')
    except ModuleNotFoundError as e:
        raise RuntimeError('Please create a directory ".ambient-package-update" and add a "metadata.py".') from e
    sys.path.pop()

    return m.METADATA


@app.command()
def render_templates():
    template_path = BASE_PATH / "templates"

    template_list = []
    for path, subdirs, files in os.walk(template_path):
        print(path, subdirs, files)
        for file in files:
            template_list.append(Path(f"{path}/{file}"))

    print('Start rending distribution templates.')
    metadata_dict = get_metadata().__dict__
    for template in template_list:
        j2_template = Template(template.read_text(), keep_trailing_newline=True)
        j2_template.globals['current_year'] = datetime.now(tz=timezone.utc).date().year

        rendered_string = j2_template.render(metadata_dict)

        relative_template_path = str(Path(template).relative_to(template_path))[:-4]

        # Create missing directories
        print(relative_template_path)
        relative_template_dir = os.path.dirname(relative_template_path)
        if relative_template_dir:
            os.makedirs(os.path.dirname(relative_template_path), exist_ok=True)

        with open(relative_template_path, 'w') as f:
            f.write(rendered_string)

        abs_path = Path(relative_template_path).resolve()
        print(f'> Successfully rendered template "{abs_path}".')
    print('Rendering finished.')


@app.command()
def build_docs(package_name: str):
    print(f'Building docs for package "{package_name}"')
    subprocess.call(f"cd ../{package_name} && sphinx-build docs/ docs/_build/html/", shell=True)


@app.command()
def run_tests():
    print('Running tests')

    package_data = get_metadata()
    dependency_list = package_data.dependencies

    if package_data.optional_dependencies:
        for _, opt_dependency in package_data.optional_dependencies.items():
            dependency_list += opt_dependency

    dependency_list = ' '.join(f'"{d}"' for d in dependency_list)
    subprocess.call(f"pip install {dependency_list}", shell=True)

    subprocess.call("pytest --ds settings tests", shell=True)


if __name__ == "__main__":
    app()
