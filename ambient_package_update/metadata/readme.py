import dataclasses


@dataclasses.dataclass
class ReadmeContent:
    # Variables that are used in the default templates
    tagline: str = None
    content: str | None = None
    uses_internationalisation: bool = True
