import dataclasses


@dataclasses.dataclass
class RuffIgnoredInspection:
    key: str
    comment: str


@dataclasses.dataclass
class RuffFilePatternIgnoredInspection:
    pattern: str
    rules: list[RuffIgnoredInspection]
