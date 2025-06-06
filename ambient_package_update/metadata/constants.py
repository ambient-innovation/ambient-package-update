DEV_DEPENDENCIES = [
    # Updater
    "typer~=0.12",
    # Test runner
    "pytest-django~=4.9",
    "pytest-mock~=3.14",
    "coverage~=7.6",
    # Linting
    "pre-commit~=4.2",
    "ruff~=0.11",
    # Documentation
    "sphinx~=7.1",
    "sphinx-rtd-theme~=2.0",
    "m2r2==0.3.3.post2",
    "mistune<2.0.0",  # fixes a problem mit m2r2
    # Release
    "flit~=3.12",
    "keyring~=25.6",
    # Build
    "ambient-package-update",
]

SUPPORTED_DJANGO_VERSIONS = [
    "4.2",
    "5.1",
    "5.2",
]

SUPPORTED_PYTHON_VERSIONS = [
    "3.9",
    "3.10",
    "3.11",
    "3.12",
    "3.13",
]

LICENSE_MIT = "MIT"
LICENSE_GPL = "GPL"

DEPLOYMENT_STATUS_ALPHA = "3 - Alpha"
DEPLOYMENT_STATUS_BETA = "4 - Beta"
DEPLOYMENT_STATUS_STABLE = "5 - Production/Stable"
