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
    'ambient-package-update~=23.5.1',
]
