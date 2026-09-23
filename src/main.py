import asyncio
from typing import Any

import httpx
from fields import resolve_fields_param
from config import settings
from sources import SOURCES, Source, SOURCES_BY_NAME
import polars as pl
from pathlib import Path
import json
from urllib.parse import urlencode
from datetime import date

def build_query_params(source: Source) -> dict[str, Any]:
    params: dict[str, Any] = {
        "limit": settings.fdic_page_limit,
        "sort_by": source.sort_by,
        "sort_order": "ASC",
        "format": "json",
    }
    params.update(source.params)

    if source.fields_params:
        params["fields"] = resolve_fields_param(settings.fdic_field_params)

    return params

async def fetch_source(client: httpx.AsyncClient, source: Source, params: dict) -> tuple[list[dict], int]:
    url = f"{source.path}?{urlencode(params, safe=':')}"
    response = await client.get(url)
    if response.status_code != 200:
        print("STATUS:", response.status_code)
        print("URL:", response.url)
        print("BODY:", response.text)
        response.raise_for_status()
    payload = response.json()
    rows = [r["data"] for r in payload["data"]]
    total = payload["meta"]["total"]
    return rows, total


async def fetch_all(client: httpx.AsyncClient, source: Source, extra: dict|None = None) -> list[dict]:
    params = build_query_params(source)
    if extra:
        params.update(extra)

    rows : list[dict] = []
    offset = 0

    while True:
        page, total = await fetch_source(client, source, {**params, "offset": offset})
        rows.extend(page)

        if not page or len(rows) >= total:
            break
        offset += len(page)

    if len(rows) != total:
        raise RuntimeError(f"Expected {total} rows, got {len(rows)}")
    return rows


def quarter_range(start, end):
    sy, sq = int(start[:4]), int(start[-1])
    ey, eq = int(end[:4]), int(end[-1])
    res = []
    while (sy, sq) <= (ey, eq):
        res.append(f"{sy}Q{sq}")
        sq += 1
        if sq == 5:
            sy, sq = sy + 1, 1

    return res


def quarter_to_dt(quarter: str):
    quarter_ends = {"1": "0331", "2": "0630", "3": "0930", "4": "1231"}
    return f"{quarter[:4]}{quarter_ends[quarter[-1]]}"


quarters = quarter_range("2001Q1", "2026Q2")

def write_rows(rows: list[dict], source_name: str, slug: str):
    out_dir = Path("data/raw") / source_name
    out_dir.mkdir(parents=True, exist_ok=True)

    (out_dir / f"{slug}.json").write_text(json.dumps(rows))
    pl.DataFrame(rows, infer_schema_length=None).write_parquet(out_dir / f"{slug}.parquet")



async def ingest_source(client: httpx.AsyncClient, source: Source):
    if source.per_quarter:
        for quarter in quarter_range(settings.fdic_start_quarter, settings.fdic_end_quarter):
            dt = quarter_to_dt(quarter)
            rows = await fetch_all(client, source, {"filters": f"REPDTE:{dt}"})
            if not rows:
                break
            write_rows(rows, source.name, dt)
    else:
        rows = await fetch_all(client, source)
        write_rows(rows, source.name, date.today().isoformat())



async def main():
    async with httpx.AsyncClient(
        base_url=settings.fdic_base_url,
        timeout=settings.fdic_timeout_seconds,
    ) as client:
        for source in SOURCES:
            if source.name == "financials":
                await ingest_source(client, source)

if __name__ == "__main__":
    asyncio.run(main())
