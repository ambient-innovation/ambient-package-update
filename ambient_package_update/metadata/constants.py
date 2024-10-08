DEV_DEPENDENCIES = [
    # Updater
    "typer~=0.9",
    # Test runner
    "freezegun~=1.3",
    "pytest-django~=4.7",
    "pytest-mock~=3.12",
    "coverage~=7.6",
    # Linting
    "pre-commit~=3.7",
    "ruff~=0.4",
    # Documentation
    "sphinx~=7.1",
    "sphinx-rtd-theme~=2.0",
    "m2r2==0.3.3.post2",
    "mistune<2.0.0",  # fixes a problem mit m2r2
    # Release
    "flit~=3.9",
    "keyring~=25.2",
    # Build
    "ambient-package-update",
]

SUPPORTED_DJANGO_VERSIONS = [
    "4.2",
    "5.0",
    "5.1",
]

SUPPORTED_PYTHON_VERSIONS = [
    "3.9",
    "3.10",
    "3.11",
    "3.12",
]

LICENSE_MIT = "MIT"
LICENSE_GPL = "GPL"
