DEV_DEPENDENCIES = [
    # Updater
    "typer~=0.19",
    # Test runner
    "pytest-cov~=7.0",
    "pytest-django~=4.11",
    "pytest-mock~=3.15",
    # Linting
    "pre-commit~=4.3",
    # Documentation
    "sphinx~=7.4",
    "sphinx-rtd-theme~=3.0",
    "m2r2~=0.3",
    # "mistune<2.0.0",  # fixes a problem mit m2r2
    # Release
    "uv~=0.9",
    "keyring~=25.7",
    # Build
    "ambient-package-update",
]

SUPPORTED_DJANGO_VERSIONS = [
    "4.2",
    "5.2",
    "6.0",
]

SUPPORTED_PYTHON_VERSIONS = [
    "3.10",
    "3.11",
    "3.12",
    "3.13",
    "3.14",
]

LICENSE_MIT = "MIT"
LICENSE_GPL = "GPL"

DEPLOYMENT_STATUS_ALPHA = "3 - Alpha"
DEPLOYMENT_STATUS_BETA = "4 - Beta"
DEPLOYMENT_STATUS_STABLE = "5 - Production/Stable"
DEPLOYMENT_STATUS_INACTIVE = "7 - Inactive"
