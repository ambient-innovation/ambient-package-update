import dataclasses
from typing import Optional


@dataclasses.dataclass
class ReadmeContent:
    tagline: str
    content: Optional[str] = None
    custom_installation: Optional[str] = None
    additional_installation: Optional[str] = None
