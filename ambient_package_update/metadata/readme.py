import dataclasses
from typing import Optional


@dataclasses.dataclass
class ReadmeContent:
    # Variables that are used in the default templates
    tagline: str = None
    content: Optional[str] = None
    uses_internationalisation: bool = True
