# IPL Analytics — dbt + Snowflake

Analytics engineering project modeling IPL cricket data (2008–2020) using dbt on Snowflake. Demonstrates staging/mart layered architecture, data quality testing, auto-generated documentation, and CI via GitHub Actions.

## Architecture

```
Kaggle CSVs
    |
load_data.py        ← one-time Python script, loads raw data
    |
Snowflake raw       ← ipl_db.raw.MATCHES, ipl_db.raw.DELIVERIES
    |
dbt staging         ← ipl_db.staging.stg_matches, stg_deliveries
    |                  (renamed columns, cleaned — views)
dbt marts           ← ipl_db.marts.top_batsmen, team_win_stats,
                       toss_analysis, bowler_economy
                       (business logic — tables)
```

## Business Questions Answered

| Model | Question |
|---|---|
| `top_batsmen` | Who are the most prolific IPL batsmen of all time? |
| `team_win_stats` | Which teams dominated each season? |
| `toss_analysis` | Does winning the toss actually help you win? |
| `bowler_economy` | Which bowlers are the most economical? |

## Stack

| Layer | Technology |
|---|---|
| Data warehouse | Snowflake (Azure, Central India) |
| Transformation | dbt 1.8 |
| Raw data loading | Python + snowflake-connector |
| CI/CD | GitHub Actions |
| Dataset | IPL 2008–2020 (Kaggle) |

## Getting Started

### Prerequisites
- Snowflake account (free trial at snowflake.com)
- Python 3.11+
- dbt-snowflake installed

### Setup

```bash
# 1. Clone the repo
git clone https://github.com/kapparasamanvita/ipl-analytics
cd ipl-analytics

# 2. Install dependencies
pip install -r requirements.txt

# 3. Set up environment variables
cp .env.example .env
# Edit .env with your Snowflake credentials

# 4. Run Snowflake setup SQL
# Open snowflake_setup.sql in a Snowflake SQL Worksheet and run it

# 5. Download data from Kaggle
# https://www.kaggle.com/datasets/nowke9/ipldata
# Place matches.csv and deliveries.csv in project root

# 6. Load raw data into Snowflake
python load_data.py

# 7. Configure dbt
cp profiles.yml ~/.dbt/profiles.yml

# 8. Test connection
dbt debug

# 9. Run models
dbt run

# 10. Run tests
dbt test

# 11. Generate and view docs
dbt docs generate
dbt docs serve
```

## Example Query Output

```sql
-- Top 5 batsmen of all time
SELECT batsman, total_runs, matches_played, strike_rate
FROM ipl_db.marts.top_batsmen
LIMIT 5;
```

```
batsman           | total_runs | matches_played | strike_rate
------------------+------------+----------------+------------
V Kohli           |       5434 |            192 |      130.02
SK Raina          |       5137 |            193 |      136.74
RG Sharma         |       4898 |            188 |      130.41
DA Warner         |       4706 |            142 |      140.92
CH Gayle          |       4484 |            125 |      151.86
```

## dbt Tests

- `unique` and `not_null` on all primary keys
- `relationships` test ensuring every delivery references a valid match
- `accepted_values` on toss_decision (bat/field only)

## CI/CD

GitHub Actions runs `dbt run` and `dbt test` on every push to main.
Add these secrets to GitHub → Settings → Secrets → Actions:
- `SNOWFLAKE_ACCOUNT`
- `SNOWFLAKE_USER`
- `SNOWFLAKE_PASSWORD`

## What This Demonstrates

- dbt layered architecture (staging → marts)
- SQL data modeling with CTEs
- Data quality testing with dbt tests
- Referential integrity validation
- Auto-generated data documentation
- CI/CD for data pipelines
