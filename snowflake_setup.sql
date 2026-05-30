-- Run this entire file in a Snowflake SQL Worksheet (as ACCOUNTADMIN)
-- before doing anything else.

-- 1. Create compute warehouse
CREATE WAREHOUSE IF NOT EXISTS dbt_wh
  WAREHOUSE_SIZE = 'X-SMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  COMMENT = 'Warehouse for dbt ipl_analytics project';

-- 2. Create database and schemas
CREATE DATABASE IF NOT EXISTS ipl_db;
USE DATABASE ipl_db;

CREATE SCHEMA IF NOT EXISTS raw;        -- raw source tables
CREATE SCHEMA IF NOT EXISTS staging;    -- dbt staging views
CREATE SCHEMA IF NOT EXISTS marts;      -- dbt mart tables

-- 3. Create a dedicated dbt user (don't use ACCOUNTADMIN for dbt)
CREATE USER IF NOT EXISTS dbt_user
  PASSWORD = 'dbt_Password123!'
  DEFAULT_ROLE = SYSADMIN
  DEFAULT_WAREHOUSE = dbt_wh
  COMMENT = 'Service user for dbt';

-- 4. Grant permissions
GRANT ROLE SYSADMIN TO USER dbt_user;
GRANT ALL PRIVILEGES ON DATABASE ipl_db TO ROLE SYSADMIN;
GRANT ALL PRIVILEGES ON ALL SCHEMAS IN DATABASE ipl_db TO ROLE SYSADMIN;
GRANT ALL PRIVILEGES ON WAREHOUSE dbt_wh TO ROLE SYSADMIN;

-- 5. Verify
SHOW SCHEMAS IN DATABASE ipl_db;
SHOW USERS LIKE 'dbt_user';
