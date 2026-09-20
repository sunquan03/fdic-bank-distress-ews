from dataclasses import dataclass, field
from config import settings


@dataclass(frozen=True)
class Source:
    name: str
    path: str
    params: dict[str, str] = field(default_factory=dict)
    sort_by: str = "ID"
    per_quarter: bool = False
    fields_params: str | None = None



SOURCES: tuple[Source, ...] = (
    Source(
        name="financials",
        path="/financials",
        sort_by="CERT",
        per_quarter=True,
        fields_params=settings.fdic_field_params,
    ),
    Source(
        name="institutions",
        path="/institutions",
        sort_by="CERT",
    ),
    Source(
        name="failures",
        path="/failures",
        sort_by="CERT",
    ),
    Source(
        name="history",
        path="/history",
        sort_by="CERT",
    ),
)

SOURCES_BY_NAME = {s.name: s for s in SOURCES}


