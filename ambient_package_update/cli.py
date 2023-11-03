import os
import subprocess
import sys
from datetime import UTC, datetime
from importlib import import_module
from os.path import basename
from pathlib import Path

import typer
from jinja2 import Template

from ambient_package_update.metadata.constants import LICENSE_GPL
from ambient_package_update.metadata.package import PackageMetadata

BASE_PATH = Path(__file__).parent

app = typer.Typer()


@app.command()
def get_metadata() -> PackageMetadata:
    sys.path.append("./.ambient-package-update")
    try:
        m = import_module("metadata")
    except ModuleNotFoundError as e:
        raise RuntimeError('Please create a directory ".ambient-package-update" and add a "metadata.py".') from e
    sys.path.pop()

    return m.METADATA


def get_template_path() -> Path:
    return BASE_PATH / "templates"


def create_rendered_file(*, template: Path, relative_target_path: Path | str) -> None:
    """
    Takes a template Path object and renders a template in the target package.
    """
    metadata_dict = get_metadata().__dict__

    j2_template = Template(template.read_text(), keep_trailing_newline=True)
    j2_template.globals["current_year"] = datetime.now(tz=UTC).date().year
    j2_template.globals["license_label"] = (
        "GNU General Public License (GPL)" if metadata_dict["license"] == LICENSE_GPL else "MIT License"
    )

    print(f"> Rendering template {basename(template)!r}...")
    rendered_string = j2_template.render(metadata_dict)

    # Create missing directories
    relative_target_dir = os.path.dirname(relative_target_path)
    if relative_target_dir:
        os.makedirs(os.path.dirname(relative_target_path), exist_ok=True)

    with open(relative_target_path, "w") as f:
        f.write(rendered_string)

    abs_path = Path(relative_target_path).resolve()
    print(f'> Successfully rendered template "{abs_path}".')


@app.command()
def render_templates():
    template_list = []
    # Collect all template files and add them to "template_list"
    for path, subdirs, files in os.walk(get_template_path()):
        print(path, subdirs, files)
        [template_list.append(Path(f"{path}/{file}")) for file in files]

    print("Start rending distribution templates.")

    for template in template_list:
        create_rendered_file(
            template=template, relative_target_path=str(Path(template).relative_to(get_template_path()))[:-4]
        )

    # License file is conditional so we have to render it separately
    metadata_dict = get_metadata().__dict__
    create_rendered_file(
        template=BASE_PATH / f"licenses/{metadata_dict['license']}.md", relative_target_path="LICENSE.md"
    )

    print("Rendering finished.")


@app.command()
def build_docs(package_name: str):
    print(f'Building docs for package "{package_name}"')
    subprocess.call(f"cd ../{package_name} && sphinx-build docs/ docs/_build/html/", shell=True)


@app.command()
def run_tests():
    print("Running tests")

    package_data = get_metadata()
    dependency_list = package_data.dependencies

    if package_data.optional_dependencies:
        for opt_dependency in package_data.optional_dependencies.values():
            dependency_list += opt_dependency

    dependency_list = " ".join(f'"{d}"' for d in dependency_list)
    subprocess.call(f"pip install {dependency_list}", shell=True)

    subprocess.call("pytest --ds settings tests", shell=True)


if __name__ == "__main__":
    app()
