from pathlib import Path

from pydantic import field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict

PROJECT_ROOT = Path(__file__).resolve().parent.parent


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=PROJECT_ROOT / ".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )

    fdic_base_url: str
    fdic_page_limit: int = 10_000
    fdic_timeout_seconds: float = 30.0
    fdic_max_retries: int = 5
    fdic_sleep_seconds: float = 0.5

    fdic_start_quarter: str
    fdic_end_quarter: str
    fdic_field_params: str

    fdic_data_dir: Path = Path("data")
    fdic_keep_raw_json: bool = True

    log_level: str = "INFO"

    @field_validator("fdic_start_quarter", "fdic_end_quarter")
    @classmethod
    def _valid_quarter(cls, v: str) -> str:
        v = v.upper().strip()
        year, _, q = v.partition("Q")
        if not (year.isdigit() and q in {"1", "2", "3", "4"}):
            raise ValueError(f"expected YYYYQn, got {v!r}")
        return v

    @field_validator("fdic_data_dir")
    @classmethod
    def _absolute_data_dir(cls, v: Path) -> Path:
        return v if v.is_absolute() else PROJECT_ROOT / v


settings = Settings()
