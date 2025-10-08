import dataclasses
import datetime
from typing import Optional

from ambient_package_update.metadata.author import PackageAuthor
from ambient_package_update.metadata.constants import LICENSE_MIT
from ambient_package_update.metadata.executables import ScriptExecutable
from ambient_package_update.metadata.maintainer import PackageMaintainer
from ambient_package_update.metadata.readme import ReadmeContent
from ambient_package_update.metadata.ruff_ignored_inspection import (
    RuffFilePatternIgnoredInspection,
    RuffIgnoredInspection,
)


@dataclasses.dataclass
class PackageMetadata:
    package_name: str
    licenser: str
    authors: list[PackageAuthor]
    maintainer: PackageMaintainer
    development_status: str
    readme_content: ReadmeContent
    claim: str
    has_migrations: bool
    dependencies: list[str]
    supported_django_versions: list[str]
    supported_python_versions: list[str]
    github_package_group: str
    min_coverage: float = 100.0
    license: str = LICENSE_MIT
    license_year: int = datetime.datetime.now(tz=datetime.UTC).year
    main_branch: str = "master"
    tests_require_django: bool = True
    github_package_name: str = None
    module_name: Optional[str] = None
    optional_dependencies: dict[str, list[str]] = None
    ruff_ignore_list: list[RuffIgnoredInspection] = None
    ruff_file_based_ignore_list: list[RuffFilePatternIgnoredInspection] = None
    script_executables: list[ScriptExecutable] = dataclasses.field(default_factory=list)
    gitignore_list: list[str] = dataclasses.field(default_factory=list)

    def __post_init__(self):
        if not self.module_name:
            self.module_name = self.package_name.replace("-", "_")
        if not self.github_package_name:
            self.github_package_name = self.package_name.replace("_", "-")
