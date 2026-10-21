DEV_DEPENDENCIES = [
    # Updater
    "typer~=0.27",
    # Test runner
    "pytest-cov~=7.1",
    "pytest-django~=4.14",
    "pytest-mock~=3.17",
    # Linting
    "pre-commit~=4.7",
    # Documentation
    "sphinx~=8.2",
    "sphinx-rtd-theme~=3.1",
    "sphinx-mdinclude~=0.6",
    # Release
    "uv~=0.13",
    "keyring~=25.7",
    # Build
    "ambient-package-update",
]

SUPPORTED_DJANGO_VERSIONS = [
    "5.2",
    "6.0",
    "6.1",
]

# Python versions each Django version runs on, as documented in the Django installation FAQ.
# Used to keep unsupported combinations out of the rendered CI test matrix.
DJANGO_PYTHON_COMPATIBILITY = {
    "4.2": ["3.8", "3.9", "3.10", "3.11", "3.12"],
    "5.0": ["3.10", "3.11", "3.12"],
    "5.1": ["3.10", "3.11", "3.12", "3.13"],
    "5.2": ["3.10", "3.11", "3.12", "3.13", "3.14"],
    "6.0": ["3.12", "3.13", "3.14"],
    "6.1": ["3.12", "3.13", "3.14"],
    "6.2": ["3.12", "3.13", "3.14"],
}

SUPPORTED_PYTHON_VERSIONS = [
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
