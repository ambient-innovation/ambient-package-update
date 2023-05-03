import dataclasses


@dataclasses.dataclass
class ReadmeContent:
    tagline: str
    content: str = None
