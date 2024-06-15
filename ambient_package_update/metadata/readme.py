import dataclasses
from typing import Optional


@dataclasses.dataclass
class ReadmeContent:
    tagline: str
    content: Optional[str] = None
    custom_installation: Optional[str] = None
    additional_installation: Optional[str] = None
    uses_internationalisation: bool = True

    installation_template: Optional[str] = "snippets/installation.tpl"
    content_template: Optional[str] = "snippets/empty.tpl"
    contribute_template: Optional[str] = "snippets/contribute.tpl"
    publish_template: Optional[str] = "snippets/publish.tpl"
    maintenance_template: Optional[str] = "snippets/maintenance.tpl"
