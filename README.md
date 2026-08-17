# Humanitarian Health Dashboard - Training Project

A comprehensive SQL and Power BI project analyzing humanitarian health indicators across 15 crisis-affected countries (2010-2022).

**Author:** Mhamad Shhab Aldeen Hasan  
**Date:** August 2026  
**Status:** Complete

---

## Project Overview

This project demonstrates a professional data analytics workflow for humanitarian health analysis:

- **Data Pipeline:** World Bank API --> Python Cleaning --> SQLite Database --> SQL Analysis --> Power BI Dashboard
- **SQL Skills:** 8 progressive queries from basic SELECT to advanced window functions (RANK, LAG)
- **Visualization:** 5-page interactive Power BI dashboard with 15+ visualizations
- **Impact:** Real-world humanitarian health crisis identification and trend analysis

**Target Audience:** UN agencies, IMPACT Initiatives, humanitarian organizations

---

## Key Findings

### Crisis Zones (2022)
- **Somalia:** Highest under-5 mortality rate (12.81 per 1,000 live births)
- **Nigeria:** West Africa crisis (11.95)
- **Myanmar:** Southeast Asia crisis (9.18)
- **Syria:** The ONLY country where health worsened (+0.95, +24.8%) due to civil war

### Success Stories (2010-2022)
- **Zimbabwe:** Improved 39% (12.75 to 7.78)
- **Uganda:** Improved 39% (8.26 to 5.04)
- **Ethiopia:** Improved 32% (8.98 to 6.09)

### COVID-19 Impact (Visible in Data)
- 2020: Mortality increase across all countries
- 2021-2022: Strong recovery in most countries
- Kenya showed +0.64 spike in 2020, followed by -0.91 recovery in 2022

### Regional Ranking (Worst to Best, 2022)
1. West Africa: 13.3
2. Sub-Saharan Africa: 10.2
3. Southern Africa: 10.0
4. Southeast Asia: 9.0
5. South Asia: 7.3
6. East Africa: 7.2
7. Middle East: 6.1

---

## Data Sources

| Indicator | Source | Type | Records |
|-----------|--------|------|---------|
| Under-5 Mortality Rate | World Bank API (SP.DYN.CDRT.IN) | Real | 195 |
| Life Expectancy | World Bank API (SP.DYN.LE00.IN) | Real | 195 |
| TB Incidence | World Bank API (SH.TBS.INCD) | Real | 195 |
| Maternal Mortality Ratio | Synthetic | Generated | 195 |
| Health Expenditure per Capita | Synthetic | Generated | 195 |
| DPT Immunization Coverage | Synthetic | Generated | 195 |
| Sanitation Access | Synthetic | Generated | 195 |

**Note on Synthetic Data:** 4 indicators were generated using statistical correlations with real World Bank data. This is documented transparently. The synthetic data was created for training and portfolio demonstration purposes. All analysis findings are based on the 3 real indicators.

---

## Data Quality and Missing Values

### Missing Values Decision: Kept As-Is

During data exploration, the following data quality issues were identified:

1. **Somalia and Yemen have NULL region values** in the countries table. These were intentionally left as NULL rather than imputed because:
   - Assigning a region without verified source data would introduce bias
   - NULL values serve as a real-world data quality lesson (common in humanitarian datasets where conflict zones have incomplete metadata)
   - SQL queries using GROUP BY region correctly exclude these countries from regional averages, which is the appropriate analytical behavior
   - This mirrors real humanitarian data environments where analysts must handle incomplete data transparently

2. **No missing values in health_indicators table.** All 195 records (15 countries x 13 years) have complete indicator values because:
   - The 3 real indicators were sourced from World Bank API which has strong coverage for these countries
   - The 4 synthetic indicators were generated programmatically with no gaps

3. **Data Quality Lesson:** In humanitarian data analysis, missing values should be documented and explained rather than silently filled. Imputation decisions must be justified and transparent, especially when informing resource allocation or crisis response.

---

## Database Schema

### Countries Table (15 rows)
| Column | Type | Description |
|--------|------|-------------|
| country_id | INTEGER | Primary key |
| country_code | TEXT | ISO 3-letter code (e.g., KEN) |
| country_name | TEXT | Full name (e.g., Kenya) |
| region | TEXT | Geographic region (NULL for Somalia, Yemen) |

### Health Indicators Table (195 rows)
| Column | Type | Description |
|--------|------|-------------|
| indicator_id | INTEGER | Primary key |
| country_id | INTEGER | Foreign key to countries |
| year | INTEGER | Year (2010-2022) |
| under_5_mortality_rate | REAL | Deaths per 1,000 live births |
| life_expectancy | REAL | Life expectancy at birth (years) |
| tuberculosis_incidence | REAL | TB cases per 100,000 population |
| maternal_mortality_ratio | REAL | Deaths per 100,000 live births (synthetic) |
| health_exp_per_capita_usd | REAL | Health spending per person USD (synthetic) |
| dpt_immunization_pct | REAL | DPT3 vaccination coverage % (synthetic) |
| improved_sanitation_access_pct | REAL | Population with improved sanitation % (synthetic) |

---

## SQL Queries (8 Total)

| Query | Description | SQL Skills |
|-------|-------------|------------|
| 1 | Get all countries | SELECT, ORDER BY |
| 2 | Filter by region (East Africa) | WHERE clause |
| 3 | Highest mortality countries 2022 | JOIN, WHERE, ORDER BY, LIMIT |
| 4 | Regional health averages | GROUP BY, AVG, COUNT, MAX, MIN |
| 5 | Kenya trends 2010-2022 | Time series, JOIN |
| 6 | 2010 vs 2022 comparison | Self-JOIN, calculated columns, percentage change |
| 7 | Regional rankings | RANK() OVER (PARTITION BY) window function |
| 8 | Year-over-year changes | LAG() OVER (PARTITION BY) window function |

All queries are documented in `sql/analysis_queries.sql` with comments explaining purpose, SQL skills used, and expected results.

---

## Power BI Dashboard (5 Pages)

| Page | Title | Visualizations |
|------|-------|---------------|
| 1 | Global Humanitarian Health Snapshot 2022 | KPI cards, pie chart, bar chart, line chart |
| 2 | Regional Health Analysis - Deep Dive | Table, bar chart, column chart |
| 3 | Country Health Rankings by Region - 2022 | Table, bar charts (top 10 worst, top 5 best) |
| 4 | Health Progress vs Crisis - 2010 to 2022 | Table, bar chart (most improved), crisis alert table |
| 5 | Country Health Trends & COVID-19 Impact | Line charts (all countries + key comparison), table |

---

## Project Structure

```
humanitarian-health-dashboard/
|-- README.md                           # This file
|-- requirements.txt                    # Python dependencies
|-- .gitignore                          # Git configuration
|-- humanitarian_health.db              # SQLite database (195 records)
|
|-- notebooks/                          # Jupyter notebooks (run in order)
|   |-- 01_download_worldbank_data.ipynb    # Step 1: Download from World Bank API
|   |-- 03_add_synthetic_indicators.ipynb   # Step 3: Add 4 synthetic indicators
|   |-- 04_load_to_sqlite.ipynb             # Step 4: Create SQLite database
|   |-- 05_export_to_powerbi.ipynb          # Step 5: Export CSVs for Power BI
|
|-- data/
|   |-- raw/                            # Original downloaded data
|   |-- cleaned/                        # Processed data
|   |-- powerbi/                        # Export CSVs for BI (8 files)
|
|-- sql/
|   |-- analysis_queries.sql            # All 8 SQL queries with documentation
|
|-- powerbi/
|   |-- Humanitarian_Health_Dashboard.pbix  # Power BI file (add manually)
|
|-- docs/
|   |-- DATA_DICTIONARY.md             # Complete data definitions
|   |-- Humanitarian_Health_Dashboard_Training_Project.docx
```

---

## How to Reproduce

### Prerequisites
- Python 3.8+
- Jupyter Notebook
- Power BI Desktop
- DBeaver or any SQLite client

### Steps

1. Clone this repository
   ```bash
   git clone https://github.com/mhammadhasan123s/humanitarian-health-dashboard.git
   cd humanitarian-health-dashboard
   ```

2. Install Python dependencies
   ```bash
   pip install -r requirements.txt
   ```

3. Run notebooks in order
   ```bash
   jupyter notebook notebooks/01_download_worldbank_data.ipynb
   jupyter notebook notebooks/03_add_synthetic_indicators.ipynb
   jupyter notebook notebooks/04_load_to_sqlite.ipynb
   jupyter notebook notebooks/05_export_to_powerbi.ipynb
   ```

4. Open SQL queries in DBeaver
   - Connect to `humanitarian_health.db`
   - Run queries from `sql/analysis_queries.sql`

5. Open Power BI Dashboard
   - Open `powerbi/Humanitarian_Health_Dashboard.pbix`

---

## Skills Demonstrated

### SQL
- SELECT, WHERE, ORDER BY, LIMIT
- JOIN (inner join, self-join)
- GROUP BY with aggregation functions (AVG, COUNT, MAX, MIN)
- Window functions: RANK() OVER (PARTITION BY), LAG() OVER (PARTITION BY)
- Common Table Expressions (CTEs)
- CASE statements for conditional logic
- Calculated columns and percentage change calculations

### Python
- API data download (requests library)
- Data cleaning and transformation (pandas, numpy)
- Synthetic data generation with statistical correlation
- Database operations (sqlite3)
- CSV export for analytics tools

### Power BI
- Multi-source data import
- Data modeling and relationships
- 15+ visualizations (KPI cards, bar, line, pie charts, tables)
- Multi-page interactive reports
- Professional formatting and layout

### Data Analysis
- Humanitarian health crisis identification
- Regional comparative analysis
- Time-series trend analysis with COVID-19 impact detection
- Year-over-year growth calculations
- Data quality assessment and documentation

---

## Countries Analyzed (15)

| Country | Code | Region |
|---------|------|--------|
| Afghanistan | AFG | South Asia |
| Burundi | BDI | East Africa |
| Congo, Dem. Rep. | COD | Sub-Saharan Africa |
| Ethiopia | ETH | East Africa |
| Kenya | KEN | East Africa |
| Mozambique | MOZ | Southern Africa |
| Myanmar | MMR | Southeast Asia |
| Nigeria | NGA | West Africa |
| Pakistan | PAK | South Asia |
| Rwanda | RWA | East Africa |
| Somalia | SOM | NULL (data quality issue) |
| Syria | SYR | Middle East |
| Uganda | UGA | East Africa |
| Yemen | YEM | NULL (data quality issue) |
| Zimbabwe | ZWE | Southern Africa |

---

## License

This project is for educational and portfolio purposes.  
Data sourced from World Bank Open Data (CC-BY 4.0 license).

---

## Author

**Mhamad Shhab Aldeen Hasan**  
MSc Data Science & Analytics - Universiti Kebangsaan Malaysia (UKM)  
GitHub: [mhammadhasan123s](https://github.com/mhammadhasan123s)

---

Last Updated: August 2026
