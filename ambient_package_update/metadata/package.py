import dataclasses
from typing import Dict, List

from ambient_package_update.metadata.author import PackageAuthor
from ambient_package_update.metadata.ruff_ignored_inspection import RuffIgnoredInspection


@dataclasses.dataclass
class PackageMetadata:
    package_name: str
    authors: List[PackageAuthor]
    development_status: str
    dependencies: List[str]
    optional_dependencies: Dict[str, List[str]] = None
    ruff_ignore_list: List[RuffIgnoredInspection] = None
