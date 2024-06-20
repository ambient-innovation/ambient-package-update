import dataclasses
from typing import Optional


@dataclasses.dataclass
class ReadmeContent:
    # Variables that are used in the default templates
    tagline: str
    content: Optional[str] = None
    custom_installation: Optional[str] = None
    additional_installation: Optional[str] = None
    uses_internationalisation: bool = True
