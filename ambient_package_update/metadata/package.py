import dataclasses
import datetime

from ambient_package_update.metadata.author import PackageAuthor
from ambient_package_update.metadata.constants import LICENSE_MIT
from ambient_package_update.metadata.readme import ReadmeContent
from ambient_package_update.metadata.ruff_ignored_inspection import RuffIgnoredInspection


@dataclasses.dataclass
class PackageMetadata:
    package_name: str
    company: str
    authors: list[PackageAuthor]
    development_status: str
    readme_content: ReadmeContent
    has_migrations: bool
    dependencies: list[str]
    supported_django_versions: list[str]
    supported_python_versions: list[str]
    min_coverage: float = 100.0
    license: str = LICENSE_MIT
    license_year: int = datetime.datetime.now(tz=datetime.UTC).year
    optional_dependencies: dict[str, list[str]] = None
    ruff_ignore_list: list[RuffIgnoredInspection] = None
