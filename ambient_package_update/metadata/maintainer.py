import dataclasses


@dataclasses.dataclass
class PackageMaintainer:
    name: str
    url: str
    email: str
