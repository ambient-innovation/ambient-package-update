from ambient_package_update import __version__

DEV_DEPENDENCIES = [
    # Updater
    "typer~=0.9",
    # Test runner
    "freezegun~=1.2",
    "pytest-django~=4.5",
    "pytest-mock~=3.10",
    "coverage~=7.3",
    # Linting
    "pre-commit~=3.5",
    "ruff~=0.1",
    # Documentation
    "sphinx==4.2.0",
    "sphinx-rtd-theme==1.0.0",
    "m2r2==0.3.1",
    "mistune<2.0.0",  # fixes a problem mit m2r2
    # Build
    f"ambient-package-update~={__version__}",
]

SUPPORTED_DJANGO_VERSIONS = [
    "3.2",
    "4.1",
    "4.2",
    "5.0",
]

SUPPORTED_PYTHON_VERSIONS = [
    "3.8",
    "3.9",
    "3.10",
    "3.11",
    "3.12",
]

LICENSE_MIT = "MIT"
LICENSE_GPL = "GPL"
