import os
import subprocess
import sys
from datetime import UTC, datetime
from importlib import import_module
from os.path import basename
from pathlib import Path

import typer
from jinja2 import Environment, FileSystemLoader, select_autoescape

from ambient_package_update.metadata.constants import LICENSE_GPL
from ambient_package_update.metadata.package import PackageMetadata

BASE_PATH = Path(__file__).parent
TEMPLATE_PATH = BASE_PATH / "templates"

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


def create_rendered_file(*, template: Path, relative_target_path: Path | str) -> None:
    """
    Takes a template Path object and renders a template in the target package.
    """
    metadata_dict = get_metadata().__dict__

    # Special case: We might want to set an explicit GitHub package name
    metadata_dict["github_package_name"] = (
        metadata_dict["github_package_name"] if metadata_dict["github_package_name"] else metadata_dict["package_name"]
    )

    env = Environment(
        loader=FileSystemLoader(
            [
                ".ambient-package-update/templates",
                TEMPLATE_PATH,
            ]
        ),
        autoescape=select_autoescape(),
        keep_trailing_newline=True,
        lstrip_blocks=True,
    )

    j2_template = env.get_template(str(template).replace("\\", "/"))
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


def get_template_list(*, include_snippets: bool = False) -> list[str]:
    template_list = [
        str(Path(Path(path).relative_to(TEMPLATE_PATH), file))
        for path, subdirs, files in os.walk(TEMPLATE_PATH)
        for file in files
        if include_snippets or "snippets" not in path
    ]
    return template_list


@app.command()
def render_templates():
    # Collect all template files and add them to "template_list"
    template_list = get_template_list()

    for template in template_list:
        print(f"> Found template {template!r}...")

    print("Start rending distribution templates.")

    for template in template_list:
        create_rendered_file(
            template=template,
            relative_target_path=template.removesuffix(".tpl"),
        )

    # License file is conditional so we have to render it separately
    metadata_dict = get_metadata().__dict__
    create_rendered_file(
        template=f"snippets/licenses/{metadata_dict['license']}.md",
        relative_target_path="LICENSE.md",
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


@app.command()
def eject_template():
    template_list = get_template_list(include_snippets=True)

    for i, template in enumerate(template_list, start=1):
        print(f"{i:>2}) {template}")

    template_no = typer.prompt("Choose template")
    template_no = int(template_no)

    if template_no > len(template_list):
        raise typer.Abort("Invalid template number")

    print(f"Ejecting template {template_list[template_no-1]}")

    template = template_list[template_no - 1]

    contents = Path(TEMPLATE_PATH / template).read_text()

    output = Path(".ambient-package-update/templates") / template
    os.makedirs(output.parent, exist_ok=True)
    output.write_text(contents)


if __name__ == "__main__":
    app()
