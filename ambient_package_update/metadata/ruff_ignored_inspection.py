import dataclasses


@dataclasses.dataclass
class RuffIgnoredInspection:
    key: str
    comment: str
