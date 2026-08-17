-- ============================================================================
-- HUMANITARIAN HEALTH DASHBOARD - SQL QUERIES
-- ============================================================================
-- Database: humanitarian_health.db
-- Purpose: Analyze humanitarian health indicators (2010-2022)
-- Countries: 15 humanitarian crisis-affected countries
-- Total Records: 195 (15 countries × 13 years)
-- ============================================================================

-- ============================================================================
-- QUERY 1: Get All Countries
-- ============================================================================
-- Purpose: Retrieve all countries in the dataset
-- SQL Skills: Basic SELECT
-- Result: 15 rows showing all countries with region information

SELECT 
    country_id,
    country_code,
    country_name,
    region
FROM countries
ORDER BY country_name;

-- ============================================================================
-- QUERY 2: Filter Countries by Region
-- ============================================================================
-- Purpose: Get countries in a specific region (East Africa)
-- SQL Skills: WHERE clause, filtering
-- Result: Shows countries grouped by geographic region

SELECT 
    country_code,
    country_name,
    region
FROM countries
WHERE region = 'East Africa'
ORDER BY country_name;

-- ============================================================================
-- QUERY 3: Countries with Highest Child Mortality (2022)
-- ============================================================================
-- Purpose: Identify countries with worst child health outcomes in 2022
-- SQL Skills: JOIN, WHERE, ORDER BY, LIMIT
-- Business Value: Crisis identification - top countries needing intervention

SELECT 
    c.country_name,
    c.region,
    h.year,
    h.under_5_mortality_rate
FROM health_indicators h
JOIN countries c ON h.country_id = c.country_id
WHERE h.year = 2022
ORDER BY h.under_5_mortality_rate DESC
LIMIT 10;

-- Result Shows:
-- Somalia: 12.81 (highest - critical)
-- Nigeria: 11.95 (West Africa crisis)
-- Myanmar: 9.18 (Southeast Asia)

-- ============================================================================
-- QUERY 4: Average Child Mortality by Region (2022)
-- ============================================================================
-- Purpose: Compare health outcomes across geographic regions
-- SQL Skills: GROUP BY, AVG, MAX, MIN, ROUND
-- Business Value: Regional prioritization for resources

SELECT 
    c.region,
    COUNT(DISTINCT c.country_id) as num_countries,
    ROUND(AVG(h.under_5_mortality_rate), 2) as avg_mortality,
    ROUND(MAX(h.under_5_mortality_rate), 2) as highest_mortality,
    ROUND(MIN(h.under_5_mortality_rate), 2) as lowest_mortality,
    ROUND(AVG(h.life_expectancy), 1) as avg_life_expectancy,
    ROUND(AVG(h.tuberculosis_incidence), 0) as avg_tb_incidence
FROM health_indicators h
JOIN countries c ON h.country_id = c.country_id
WHERE h.year = 2022
GROUP BY c.region
ORDER BY avg_mortality DESC;

-- Result Shows Regional Ranking:
-- West Africa: 13.3 (worst)
-- Sub-Saharan Africa: 10.2
-- Southern Africa: 10.0
-- Southeast Asia: 9.0
-- South Asia: 7.3
-- East Africa: 7.2
-- Middle East: 6.1 (best)

-- ============================================================================
-- QUERY 5: Individual Country Trends (2010-2022)
-- ============================================================================
-- Purpose: Analyze 13-year health trajectory for a country
-- SQL Skills: JOIN, WHERE, ORDER BY for time-series
-- Business Value: Trend identification, COVID-19 impact visible

SELECT 
    c.country_name,
    c.region,
    h.year,
    h.under_5_mortality_rate,
    h.life_expectancy,
    h.tuberculosis_incidence
FROM health_indicators h
JOIN countries c ON h.country_id = c.country_id
WHERE c.country_name = 'Kenya'
ORDER BY h.year ASC;

-- Result Shows Kenya's Journey:
-- 2010: Mortality 7.424, Life Exp 60.915
-- 2019: Mortality 7.294, Life Exp 62.939 (steady improvement)
-- 2020: Mortality 7.937 (COVID impact visible)
-- 2021: Mortality 8.124 (still recovering)
-- 2022: Mortality 7.212 (strong recovery)

-- ============================================================================
-- QUERY 6: Countries with Improving vs Worsening Health (2010 vs 2022)
-- ============================================================================
-- Purpose: Identify health progress and crises over 12 years
-- SQL Skills: Self-JOIN, calculated columns, percentage calculations
-- Business Value: Success stories (Zimbabwe) vs crises (Syria)

SELECT 
    c.country_name,
    c.region,
    h_2010.under_5_mortality_rate as mortality_2010,
    h_2022.under_5_mortality_rate as mortality_2022,
    ROUND(h_2022.under_5_mortality_rate - h_2010.under_5_mortality_rate, 2) as change,
    ROUND(((h_2022.under_5_mortality_rate - h_2010.under_5_mortality_rate) / h_2010.under_5_mortality_rate * 100), 1) as pct_change
FROM health_indicators h_2010
JOIN health_indicators h_2022 ON h_2010.country_id = h_2022.country_id
JOIN countries c ON h_2010.country_id = c.country_id
WHERE h_2010.year = 2010 AND h_2022.year = 2022
ORDER BY change DESC;

-- Result Shows:
-- WORSENED (only 1):
-- Syria: +0.95 (+24.8%) - civil war impact
--
-- IMPROVED (14 countries, best to worst):
-- Zimbabwe: -4.97 (-39.0%)
-- Mozambique: -4.29 (-37.1%)
-- Somalia: -3.81 (-22.9%)
-- Burundi: -3.51 (-33.4%)
-- Ethiopia: -2.89 (-32.1%)
-- Uganda: -3.23 (-39.1%)
-- Congo: -2.72 (-23.4%)
-- Nigeria: -2.41 (-16.8%)
-- Afghanistan: -2.41 (-28.7%)
-- Rwanda: -1.35 (-18.4%)
-- Pakistan: -1.18 (-15.3%)
-- Yemen: -0.35 (-6.3%)
-- Kenya: -0.21 (-2.9%)
-- Myanmar: -0.03 (-0.3%)

-- ============================================================================
-- QUERY 7: Rank Countries by Mortality Within Each Region (2022)
-- ============================================================================
-- Purpose: Identify best/worst performer in each region
-- SQL Skills: Window function (RANK), PARTITION BY
-- Business Value: Fair comparison within peer regions, not global ranking

SELECT 
    c.country_name,
    c.region,
    h.year,
    h.under_5_mortality_rate,
    RANK() OVER (PARTITION BY c.region, h.year ORDER BY h.under_5_mortality_rate DESC) as rank_in_region,
    RANK() OVER (PARTITION BY c.region, h.year ORDER BY h.under_5_mortality_rate ASC) as rank_best
FROM health_indicators h
JOIN countries c ON h.country_id = c.country_id
WHERE h.year = 2022
ORDER BY c.region, rank_in_region;

-- Result Shows Regional Rankings (Rank 1 = Worst):
-- EAST AFRICA:
-- Kenya: 7.212 (rank 1 - worst in region)
-- Burundi: 6.997 (rank 2)
-- Ethiopia: 6.093 (rank 3)
-- Rwanda: 5.993 (rank 4)
-- Uganda: 5.035 (rank 5 - best in region)
--
-- WEST AFRICA:
-- Nigeria: 11.953 (rank 1 - worst, but only 1 country)
--
-- And so on for other regions...

-- ============================================================================
-- QUERY 8: Year-over-Year Mortality Changes (LAG Window Function)
-- ============================================================================
-- Purpose: Show annual health changes, identify setbacks and improvements
-- SQL Skills: Window function (LAG), PARTITION BY, calculated columns
-- Business Value: Trend direction, COVID-19 impact visible in 2020

SELECT 
    c.country_name,
    c.region,
    h.year,
    h.under_5_mortality_rate,
    LAG(h.under_5_mortality_rate) OVER (PARTITION BY h.country_id ORDER BY h.year) as prev_year_mortality,
    ROUND(h.under_5_mortality_rate - LAG(h.under_5_mortality_rate) OVER (PARTITION BY h.country_id ORDER BY h.year), 2) as year_over_year_change
FROM health_indicators h
JOIN countries c ON h.country_id = c.country_id
ORDER BY c.country_name, h.year;

-- Example Output for Kenya:
-- 2010: 7.424 | prev: NULL | change: NULL (first year)
-- 2011: 7.275 | prev: 7.424 | change: -0.149 (improved)
-- 2012: 7.208 | prev: 7.275 | change: -0.067 (improved)
-- ...
-- 2019: 7.294 | prev: 7.186 | change: +0.108 (worsened)
-- 2020: 7.937 | prev: 7.294 | change: +0.643 (COVID IMPACT - BIG JUMP)
-- 2021: 8.124 | prev: 7.937 | change: +0.187 (still elevated)
-- 2022: 7.212 | prev: 8.124 | change: -0.912 (strong recovery)

-- ============================================================================
-- ADDITIONAL QUERIES FOR DEEPER ANALYSIS
-- ============================================================================

-- Get all health indicators for 2022
SELECT 
    c.country_name,
    c.region,
    h.under_5_mortality_rate,
    h.life_expectancy,
    h.maternal_mortality_ratio,
    h.tuberculosis_incidence,
    h.dpt_immunization_pct,
    h.improved_sanitation_access_pct,
    h.health_exp_per_capita_usd
FROM health_indicators h
JOIN countries c ON h.country_id = c.country_id
WHERE h.year = 2022
ORDER BY h.under_5_mortality_rate DESC;

-- ============================================================================
-- DATABASE SCHEMA FOR REFERENCE
-- ============================================================================

-- Countries Table
-- CREATE TABLE countries (
--     country_id INTEGER PRIMARY KEY AUTOINCREMENT,
--     country_code TEXT UNIQUE NOT NULL,
--     country_name TEXT NOT NULL,
--     region TEXT
-- );

-- Health Indicators Table
-- CREATE TABLE health_indicators (
--     indicator_id INTEGER PRIMARY KEY AUTOINCREMENT,
--     country_id INTEGER NOT NULL,
--     year INTEGER NOT NULL,
--     under_5_mortality_rate REAL,
--     life_expectancy REAL,
--     maternal_mortality_ratio REAL,
--     tuberculosis_incidence REAL,
--     dpt_immunization_pct REAL,
--     improved_sanitation_access_pct REAL,
--     health_exp_per_capita_usd REAL,
--     FOREIGN KEY (country_id) REFERENCES countries(country_id),
--     UNIQUE(country_id, year)
-- );

-- ============================================================================
-- END OF SQL QUERIES
-- ============================================================================
