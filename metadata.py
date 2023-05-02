import dataclasses
from typing import Dict, List


# todo add a specific file in every package so we can change it when changing the package
#  (".ambient-package-update" dir? oder als loses file?)

@dataclasses.dataclass
class PackageAuthor:
    name: str
    email: str


@dataclasses.dataclass
class RuffIgnoredInspection:
    key: str
    comment: str


@dataclasses.dataclass
class PackageMetadata:
    package_name: str
    authors: List[PackageAuthor]
    development_status: str
    dependencies: List[str]
    optional_dependencies: Dict[str, List[str]] = None
    ruff_ignore_list: List[RuffIgnoredInspection] = None


dev_dependencies = [
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
]

metadata = {
    'ambient_gadgets': PackageMetadata(
        package_name='ambient_gadgets',
        authors=[
            PackageAuthor(
                name='Ambient Digital',
                email='hello@ambient.digital',
            ),
        ],
        development_status='5 - Production/Stable',
        dependencies=[
            'Django>=2.2.28',
            'bleach>=1.4,<6',
            'python-dateutil>=2.5.3',
        ],
        optional_dependencies={
            'dev': [
                *dev_dependencies,
                'gevent~=22.10',
            ],
            'drf': [
                'djangorestframework>=3.8.2',
            ],
            'graphql': [
                'graphene-django>=2.2.0',
                'django-graphql-jwt>=0.2.1',
            ],
            'view-layer': [
                'django-crispy-forms>=1.4.0',
            ],
        },
        ruff_ignore_list=[
            RuffIgnoredInspection(key='N999', comment="Project name contains underscore, not fixable"),
            RuffIgnoredInspection(key='A003', comment="Django attributes shadow python builtins"),
            RuffIgnoredInspection(key='DJ001', comment="Django model text-based fields shouldn't be nullable"),
            RuffIgnoredInspection(key='B905', comment="Django model text-based fields shouldn't be nullable"),
            RuffIgnoredInspection(key='DTZ001', comment="TODO will affect \"tz_today()\" method"),
            RuffIgnoredInspection(key='DTZ005', comment="TODO will affect \"tz_today()\" method"),
        ],
    ),
    'django_pony_express': PackageMetadata(
        package_name='django_pony_express',
        authors=[
            PackageAuthor(
                name='Ambient Digital',
                email='hello@ambient.digital',
            ),
        ],
        development_status='5 - Production/Stable',
        dependencies=[
            'Django>=2.2.28',
            'html2text>=2020.1.16',
        ],
        optional_dependencies={
            'dev': [
                *dev_dependencies,
            ],
        },
        ruff_ignore_list=[
            RuffIgnoredInspection(key='N999', comment="Project name contains underscore, not fixable"),
            RuffIgnoredInspection(key='A003', comment="Django attributes shadow python builtins"),
            RuffIgnoredInspection(key='DJ001', comment="Django model text-based fields shouldn't be nullable"),
            RuffIgnoredInspection(key='B905', comment="Django model text-based fields shouldn't be nullable"),
        ],
    ),
}


def get_metadata(package_name: str) -> dict:
    try:
        return metadata[package_name].__dict__
    except KeyError as e:
        raise KeyError('Invalid package name provided.') from e


def get_package_list():
    return metadata.keys()
