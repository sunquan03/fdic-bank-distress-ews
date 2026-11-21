# FDIC Bank Distress Early-Warning System

Predicts which US banks will fail or need an assisted exit within the next 12 months using 25 years of public FDIC quarterly reports (2001–2026). 

async API ingest => DuckDB => dbt => model => watch list

Headline result : a one line regulatory rule (leverage below 5%) already catches 88,5% of failing bank-quarters and logistic regression does not beat it on its own. Its real value is as a second net: among banks that still look fine on capital, the model finds 38% of the failures the rule misses with x77 lift over random selection. Rule and model together catch 92,9% of failing bank quarters.