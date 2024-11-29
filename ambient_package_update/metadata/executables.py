import dataclasses


@dataclasses.dataclass
class ScriptExecutable:
    name: str
    import_path: str
