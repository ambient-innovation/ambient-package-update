import dataclasses
from typing import Optional


@dataclasses.dataclass
class ReadmeContent:
    tagline: str
    content: Optional[str] = None
    installation: Optional[str] = None
