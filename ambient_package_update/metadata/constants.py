from ambient_package_update import __version__

DEV_DEPENDENCIES = [
    # Test runner
    'freezegun~=1.2',
    'pytest-django~=4.5',
    'pytest-mock~=3.10',
    # Linting
    'pre-commit~=3.2',
    'black~=23.3',
    # Documentation
    'Django~=3.2',
    'sphinx==4.2.0',
    'sphinx-rtd-theme==1.0.0',
    'm2r2==0.3.1',
    'mistune<2.0.0',  # fixes a problem mit m2r2
    # Build
    f'ambient-package-update~={__version__}',
]

LICENSE_MIT = "MIT"
LICENSE_GPL = "GPL"
