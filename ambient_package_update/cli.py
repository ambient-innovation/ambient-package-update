import os
import re
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
    """
    Load and return the PackageMetadata instance from the target package's
    .ambient-package-update/metadata.py file.
    """
    sys.path.append("./.ambient-package-update")
    try:
        m = import_module("metadata")
    except ModuleNotFoundError as e:
        raise RuntimeError('Please create a directory ".ambient-package-update" and add a "metadata.py".') from e
    sys.path.pop()

    return m.METADATA


def create_rendered_file(*, template: Path | str, relative_target_path: Path | str) -> None:
    """
    Render a single Jinja2 template and write the result to relative_target_path.

    The Jinja2 environment searches .ambient-package-update/templates/ first, then the
    built-in templates directory, so local overrides take precedence. Template globals
    (version, current_year, license_label) are injected alongside the package metadata.
    Output is post-processed to collapse consecutive blank lines and ensure a single
    trailing newline.
    """
    metadata_dict = get_metadata().__dict__

    # Special case: We might want to set an explicit GitHub package name
    metadata_dict["github_package_name"] = metadata_dict["github_package_name"] or metadata_dict["package_name"]

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

    # Get version from file
    regex = r'__version__\s*=\s*"(\d+\.\d+\.\d+)"'
    with open(Path.cwd() / metadata_dict["module_name"] / "__init__.py") as f:
        match = re.search(regex, f.read())
    if match:
        j2_template.globals["version"] = match[1]

    j2_template.globals["current_year"] = datetime.now(tz=UTC).date().year
    j2_template.globals["license_label"] = (
        "GNU General Public License (GPL)" if metadata_dict["license"] == LICENSE_GPL else "MIT License"
    )

    print(f"> Rendering template {basename(template)!r}...")
    rendered_string = j2_template.render(metadata_dict)

    # Post-processing: Remove multiple newlines
    rendered_string = re.sub(r"\n{2,}", "\n\n", rendered_string)

    # Post-processing: Ensure one newline at file end
    rendered_string = re.sub(r"\n{2}$", "\n", rendered_string)

    # Create missing directories
    relative_target_dir = os.path.dirname(relative_target_path)
    if relative_target_dir:
        os.makedirs(os.path.dirname(relative_target_path), exist_ok=True)

    with open(relative_target_path, "w") as f:
        f.write(rendered_string)

    abs_path = Path(relative_target_path).resolve()
    print(f'> Successfully rendered template "{abs_path}".')


def get_template_list(*, include_snippets: bool = False) -> list[str]:
    """
    Return relative template paths from the built-in templates directory.

    Snippets are excluded by default. Pass include_snippets=True to include them
    (used by eject_template to list all ejectable templates).
    """
    return [
        str(Path(Path(path).relative_to(TEMPLATE_PATH), file))
        for path, subdirs, files in os.walk(TEMPLATE_PATH)
        for file in files
        if include_snippets or "snippets" not in path
    ]


def get_local_template_list(*, include_snippets: bool = False) -> list[str]:
    """
    Return relative template paths from the target package's local template directory
    (.ambient-package-update/templates/).

    These are package-specific templates that have no built-in counterpart, such as
    extra documentation pages. Returns an empty list if the directory does not exist.
    Snippets are excluded by default.
    """
    local_template_path = Path(".ambient-package-update/templates")
    if not local_template_path.exists():
        return []
    return [
        str(Path(Path(path).relative_to(local_template_path), file))
        for path, subdirs, files in os.walk(local_template_path)
        for file in files
        if include_snippets or "snippets" not in path
    ]


def setup_package_basics(metadata_dict: dict) -> None:
    """
    Create package folder and __init__.py with claim and version if they don't exist.
    Updates claim in existing __init__.py files.
    """
    module_name = metadata_dict["module_name"]
    module_path = Path.cwd() / module_name

    # Create module folder if it doesn't exist
    if not module_path.exists():
        print(f"> Creating module directory '{module_name}'...")
        module_path.mkdir(parents=True, exist_ok=True)

    # Check for __init__.py and create if missing
    init_file = module_path / "__init__.py"
    if not init_file.exists():
        print("> Creating __init__.py with claim and version...")
        init_file.write_text(f'"""{metadata_dict["claim"]}"""\n\n__version__ = "1.0.0"\n')
    else:
        print("> Updating __init__.py claim...")
        content = init_file.read_text()

        # Extract existing version if present
        regex = r'__version__\s*=\s*"(\d+\.\d+\.\d+)"'
        match = re.search(regex, content)
        version = match[1] if match else "1.0.0"

        # Replace claim at the beginning (first docstring)
        content = re.sub(r'^""".*?"""', f'"""{metadata_dict["claim"]}"""', content, count=1, flags=re.DOTALL)

        # Ensure __version__ is present
        if not re.search(regex, content):
            # Add version after the docstring
            content = re.sub(
                r'^(""".*?""")\s*', rf'\1\n\n__version__ = "{version}"\n', content, count=1, flags=re.DOTALL
            )

        init_file.write_text(content)


@app.command()
def render_templates():
    """
    Render all templates into the target package.

    Built-in templates and local package-specific templates are merged; if both define
    the same path, the local version takes precedence (handled by Jinja2's loader
    ordering). The LICENSE.md file is rendered separately as it is chosen conditionally
    based on the configured license type.
    """
    # Collect all template files; local templates shadow built-in ones with the same path
    template_list = list(dict.fromkeys([*get_template_list(), *get_local_template_list()]))

    for template in template_list:
        print(f"> Found template {template!r}...")

    print("Start rending distribution templates.")

    for template in template_list:
        create_rendered_file(
            template=template,
            relative_target_path=template.removesuffix(".tpl"),
        )

    # The licence file is conditional, so we have to render it separately
    metadata_dict = get_metadata().__dict__
    create_rendered_file(
        template=f"snippets/licenses/{metadata_dict['license']}.md",
        relative_target_path="LICENSE.md",
    )

    # Package basics
    setup_package_basics(metadata_dict)

    print("Rendering finished.")


@app.command()
def build_docs(package_name: str):
    """
    Build Sphinx HTML documentation for the given package by running sphinx-build
    in its docs/ directory.
    """
    print(f'Building docs for package "{package_name}"')
    subprocess.call(f"cd ../{package_name} && sphinx-build docs/ docs/_build/html/", shell=True)


@app.command()
def run_tests():
    """
    Install the target package's dependencies and run its test suite with pytest.
    """
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
    """
    Interactively copy a built-in template into .ambient-package-update/templates/ so
    the target package can customise it. Only built-in templates are listed; locally
    overridden templates are already present in that directory.
    """
    template_list = get_template_list(include_snippets=True)

    for i, template in enumerate(template_list, start=1):
        print(f"{i:>2}) {template}")

    template_no = typer.prompt("Choose template")
    template_no = int(template_no)

    if template_no > len(template_list):
        raise typer.Abort("Invalid template number")

    print(f"Ejecting template {template_list[template_no - 1]}")

    template = template_list[template_no - 1]

    contents = Path(TEMPLATE_PATH / template).read_text()

    output = Path(".ambient-package-update/templates") / template
    os.makedirs(output.parent, exist_ok=True)
    output.write_text(contents)


if __name__ == "__main__":
    app()
