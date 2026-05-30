"""
One-time script to load IPL CSV data into Snowflake raw schema.

Usage:
    1. Download matches.csv and deliveries.csv from Kaggle:
       https://www.kaggle.com/datasets/nowke9/ipldata
    2. Place both CSVs in the same folder as this script
    3. Fill in your .env file
    4. Run: python load_data.py
"""
import pandas as pd
import snowflake.connector
from snowflake.connector.pandas_tools import write_pandas
import os
from dotenv import load_dotenv

load_dotenv()

def get_connection():
    return snowflake.connector.connect(
        account=os.getenv("SNOWFLAKE_ACCOUNT"),
        user=os.getenv("SNOWFLAKE_USER"),
        password=os.getenv("SNOWFLAKE_PASSWORD"),
        warehouse="dbt_wh",
        database="ipl_db",
        schema="raw"
    )

def load_table(conn, csv_path: str, table_name: str):
    print(f"Loading {csv_path} → {table_name}...")
    df = pd.read_csv(csv_path)
    df.columns = df.columns.str.upper().str.replace(" ", "_")
    success, nchunks, nrows, _ = write_pandas(
        conn, df, table_name,
        auto_create_table=True,
        overwrite=True
    )
    if success:
        print(f"  ✓ Loaded {nrows} rows into raw.{table_name}")
    else:
        print(f"  ✗ Failed to load {table_name}")

def main():
    print("=== IPL Data Loader ===")

    # validate files exist
    for f in ["matches.csv", "deliveries.csv"]:
        if not os.path.exists(f):
            raise FileNotFoundError(
                f"{f} not found. Download from: "
                "https://www.kaggle.com/datasets/nowke9/ipldata"
            )

    conn = get_connection()
    print("Connected to Snowflake ✓\n")

    load_table(conn, "matches.csv", "MATCHES")
    load_table(conn, "deliveries.csv", "DELIVERIES")

    conn.close()
    print("\n=== Done! Raw tables loaded into ipl_db.raw ===")
    print("Next step: run 'dbt debug' to test your dbt connection")

if __name__ == "__main__":
    main()
