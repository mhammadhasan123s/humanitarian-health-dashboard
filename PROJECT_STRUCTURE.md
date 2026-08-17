# Project Structure Guide

## Directory Organization

```
humanitarian-health-dashboard/
│
├── README.md                          # Main project documentation
├── PROJECT_STRUCTURE.md               # This file - directory guide
├── requirements.txt                   # Python dependencies
├── .gitignore                         # Git ignore rules
│
├── humanitarian_health.db             # SQLite database (195 records)
│
├── notebooks/                         # Jupyter notebooks (executable workflow)
│   ├── 01_download_worldbank_data.ipynb      # Download data from World Bank API
│   ├── 03_add_synthetic_indicators.ipynb     # Generate synthetic health indicators
│   ├── 04_load_to_sqlite.ipynb               # Create SQLite database
│   └── 05_export_to_powerbi.ipynb            # Export queries to CSV for BI
│
├── data/                              # Data storage
│   ├── raw/                           # Original downloaded data
│   │   └── (empty - generated at runtime)
│   ├── cleaned/                       # Processed data
│   │   └── (empty - generated at runtime)
│   └── powerbi/                       # Export CSVs for Power BI
│       ├── master_health_data.csv     # Complete dataset (195 rows)
│       ├── q3_highest_mortality.csv   # Top countries by mortality
│       ├── q4_regional_averages.csv   # Regional health metrics (8 regions)
│       ├── q5_all_country_trends.csv  # Country time series (195 rows)
│       ├── q6_improvement_analysis.csv # 2010 vs 2022 comparison (15 countries)
│       ├── q7_regional_rankings.csv   # Ranked by mortality per region (15 countries)
│       └── q8_year_over_year.csv      # Annual changes (195 rows)
│
├── sql/                               # SQL query scripts
│   └── analysis_queries.sql           # All 8 analysis queries with documentation
│
├── powerbi/                           # Power BI dashboard files
│   ├── Humanitarian_Health_Dashboard.pbix  # Main Power BI file (5 pages)
│   └── Humanitarian_Health_Dashboard.pdf   # Exported PDF version
│
├── docs/                              # Documentation
│   ├── Humanitarian_Health_Dashboard_Training_Project.docx  # Word doc with details
│   ├── DATA_DICTIONARY.md             # Complete data definitions
│   ├── SQL_QUERIES.md                 # Query explanations (if separate)
│   └── CHANGELOG.md                   # Version history
│
└── scripts/                           # Standalone Python scripts (optional)
    ├── download_data.py               # Standalone download script
    ├── clean_data.py                  # Standalone cleaning script
    ├── load_database.py               # Standalone database loading
    └── export_powerbi.py              # Standalone BI export
```

---

## File Descriptions

### Root Level Files

#### README.md
- **Purpose:** Main project documentation
- **Contains:** Overview, features, findings, structure, quick start, skills demonstrated
- **Audience:** First-time visitors, GitHub browsers
- **Reading Time:** 10-15 minutes

#### PROJECT_STRUCTURE.md
- **Purpose:** This file - directory and file organization guide
- **Contains:** What each file/folder contains and why
- **Audience:** Developers exploring the codebase
- **Reading Time:** 5-10 minutes

#### requirements.txt
- **Purpose:** Python package dependencies
- **Usage:** `pip install -r requirements.txt`
- **Packages:** pandas, numpy, requests, jupyter, sqlite3
- **Note:** sqlite3 is built-in Python; others install via pip

#### .gitignore
- **Purpose:** Tell Git which files to ignore
- **Excludes:** Cache, virtual environments, large data files, IDE files
- **Critical:** Prevents `.env` files with secrets from being committed

#### humanitarian_health.db
- **Purpose:** SQLite database file
- **Size:** ~36 KB
- **Contents:** 2 tables (countries, health_indicators)
- **Records:** 195 total (15 countries × 13 years)
- **Format:** Binary SQLite3 format

---

### Notebooks Directory (`notebooks/`)

#### 01_download_worldbank_data.ipynb
- **Purpose:** Download health data from World Bank API
- **Input:** World Bank API (HTTP requests)
- **Output:** `data/raw/worldbank_health_data.csv`
- **Skills Shown:** API calls, requests library, JSON parsing, data extraction
- **Records Generated:** 195 records (15 countries × 13 years × 1 API request)
- **Time to Run:** 2-3 minutes

#### 03_add_synthetic_indicators.ipynb
- **Purpose:** Generate 4 synthetic health indicators
- **Input:** `data/cleaned/worldbank_humanitarian_health_2010_2022.csv`
- **Output:** `data/cleaned/worldbank_humanitarian_health_complete.csv`
- **Skills Shown:** Pandas, synthetic data generation, statistical correlation, numpy
- **Reason:** Complete dataset (7 metrics instead of 3)
- **Time to Run:** <1 minute
- **Important:** Synthetic data clearly documented for transparency

#### 04_load_to_sqlite.ipynb
- **Purpose:** Create SQLite database from CSV
- **Input:** `data/cleaned/worldbank_humanitarian_health_complete.csv`
- **Output:** `humanitarian_health.db`
- **Skills Shown:** SQL schema creation, foreign keys, data loading, sqlite3 library
- **Tables Created:** countries (15 rows), health_indicators (195 rows)
- **Time to Run:** <1 minute

#### 05_export_to_powerbi.ipynb
- **Purpose:** Export SQL query results to CSVs for Power BI
- **Input:** `humanitarian_health.db` (SQLite database)
- **Output:** 8 CSV files in `data/powerbi/`
- **Skills Shown:** SQL querying, pandas, aggregation, window functions
- **Files Generated:** master_health_data + 7 query results
- **Time to Run:** <1 minute

---

### Data Directory (`data/`)

#### data/raw/
- **Purpose:** Store original downloaded data
- **Content:** `worldbank_health_data.csv` (generated at runtime)
- **Size:** ~6.8 KB
- **Format:** CSV (wide format - years as columns)
- **Retention:** Keep for reproducibility

#### data/cleaned/
- **Purpose:** Store cleaned and processed data
- **Files:**
  - `worldbank_humanitarian_health_2010_2022.csv` - Cleaned real data (long format)
  - `worldbank_humanitarian_health_complete.csv` - With synthetic indicators
- **Format:** CSV (long format - years as rows)
- **Retention:** Keep for database loading

#### data/powerbi/
- **Purpose:** CSV exports for Power BI import
- **Contents:** 8 CSV files exported from SQL queries
- **Usage:** Import each file as a table/relationship in Power BI
- **Retention:** Regenerate as needed; not essential to keep

---

### SQL Directory (`sql/`)

#### analysis_queries.sql
- **Purpose:** All 8 SQL queries documented
- **Contains:** Query code, explanations, expected results
- **Format:** SQL comments + executable queries
- **Use Cases:**
  - Copy-paste into DBeaver/SQL clients
  - Reference during Power BI DAX calculations
  - Interview preparation
- **Queries Included:** 8 main + additional exploratory queries

---

### Power BI Directory (`powerbi/`)

#### Humanitarian_Health_Dashboard.pbix
- **Purpose:** Interactive Power BI dashboard
- **Size:** Depends on data import (~20-50 MB typical)
- **Pages:** 5 (Global Snapshot, Regional, Rankings, Progress, Trends)
- **Visualizations:** 15+ (cards, charts, tables)
- **Data Source:** CSV files from `data/powerbi/`
- **Usage:** Open in Power BI Desktop, explore dashboards, filter data

#### Humanitarian_Health_Dashboard.pdf
- **Purpose:** Static PDF export of dashboard
- **Pages:** 5 (one per BI page)
- **Usage:** Share with stakeholders without Power BI access
- **Limitation:** No interactivity (static images)

---

### Docs Directory (`docs/`)

#### Humanitarian_Health_Dashboard_Training_Project.docx
- **Purpose:** Complete project documentation in Word format
- **Contains:** All details, query explanations, findings
- **Pages:** ~10 pages
- **Use:** Share with non-technical stakeholders, formal reports
- **Format:** Microsoft Word (.docx)

#### DATA_DICTIONARY.md
- **Purpose:** Complete data definitions and metadata
- **Contains:** Column descriptions, data types, ranges, sources
- **Use:** Reference when building BI reports, understanding data limitations
- **Sections:** Schema, quality notes, statistics, anomalies

#### SQL_QUERIES.md (Optional)
- **Purpose:** Detailed query explanations
- **Contains:** Each query with business context and results
- **Use:** Study guide for SQL learning

#### CHANGELOG.md (Optional)
- **Purpose:** Project version history
- **Contains:** What changed in each version
- **Format:** Markdown with dates and descriptions

---

### Scripts Directory (`scripts/`) - Optional

These are standalone Python scripts (not notebooks) for automation:

#### download_data.py
- **Purpose:** Standalone script to download World Bank data
- **Usage:** `python scripts/download_data.py`
- **Advantage:** Can be scheduled as cron jobs

#### clean_data.py
- **Purpose:** Standalone data cleaning
- **Usage:** `python scripts/clean_data.py`

#### load_database.py
- **Purpose:** Create database from CSV
- **Usage:** `python scripts/load_database.py`

#### export_powerbi.py
- **Purpose:** Export queries to CSVs
- **Usage:** `python scripts/export_powerbi.py`

**Note:** Scripts directory is OPTIONAL - notebooks are primary workflow

---

## Data Flow Diagram

```
World Bank API
    ↓
[01_download_worldbank_data.ipynb]
    ↓
data/raw/worldbank_health_data.csv
    ↓
[02_clean_data.py / notebook] (not shown - integrated into 03)
    ↓
data/cleaned/worldbank_humanitarian_health_2010_2022.csv
    ↓
[03_add_synthetic_indicators.ipynb]
    ↓
data/cleaned/worldbank_humanitarian_health_complete.csv
    ↓
[04_load_to_sqlite.ipynb]
    ↓
humanitarian_health.db (SQLite)
    ↓
[05_export_to_powerbi.ipynb]
    ↓
data/powerbi/ (8 CSV files)
    ↓
Power BI Desktop
    ↓
Humanitarian_Health_Dashboard.pbix
    ↓
PDF / Published Report / Interview
```

---

## How to Use Each File

### For Running the Project
1. Start with `notebooks/01_download_worldbank_data.ipynb`
2. Follow through notebooks 03, 04, 05 in order
3. Files generate automatically; check each output
4. Open Power BI file for visualization

### For Learning SQL
1. Open `sql/analysis_queries.sql` in any SQL editor
2. Copy queries into DBeaver connected to `humanitarian_health.db`
3. Modify and experiment with different WHERE/GROUP BY clauses
4. Reference `docs/DATA_DICTIONARY.md` for column definitions

### For Interview Prep
1. Read `README.md` for project overview
2. Study `docs/DATA_DICTIONARY.md` for data understanding
3. Review `sql/analysis_queries.sql` for SQL patterns
4. Explore Power BI dashboard for visualization examples
5. Practice explaining findings from `README.md` Key Findings section

### For Portfolio Submission
1. Include: README.md, requirements.txt, .gitignore
2. Include: all notebooks (show your workflow)
3. Include: database file (humanitarian_health.db)
4. Include: Power BI file (or PDF if binary not supported)
5. Include: SQL queries in sql/ directory
6. Optional: docs/ folder for extra detail

### For Modification/Extension
1. Edit `sql/analysis_queries.sql` for new queries
2. Create new notebooks for additional analysis
3. Update `DATA_DICTIONARY.md` if adding new fields
4. Regenerate Power BI import/relationships if changing data
5. Update `README.md` with new findings

---

## File Sizes Reference

| File | Size | Type | Regenerable |
|------|------|------|-------------|
| humanitarian_health.db | 36 KB | Binary | ✅ Yes |
| worldbank_health_data.csv | 6.8 KB | Text | ✅ Yes (from API) |
| worldbank_humanitarian_health_complete.csv | ~15 KB | Text | ✅ Yes |
| Humanitarian_Health_Dashboard.pbix | 20-50 MB | Binary | ✅ Yes (from CSVs) |
| Humanitarian_Health_Dashboard.pdf | 2-5 MB | Binary | ✅ Yes (from PBIX) |
| Notebooks (.ipynb) | 10-50 KB each | Text/JSON | ⚠️ Keep originals |

---

## Best Practices for Maintenance

### Version Control (Git)
- ✅ Commit: notebooks, SQL, README, requirements.txt
- ✅ Commit: Power BI file (important for portfolio)
- ❌ Don't commit: Large CSV files, environment variables, IDE config
- 📋 Use .gitignore to exclude unnecessary files

### Collaboration
1. Always run notebooks in order (01 → 03 → 04 → 05)
2. Document changes in CHANGELOG.md
3. Update README.md if modifying project scope
4. Keep DATA_DICTIONARY.md synchronized with schema changes

### Updates & Modifications
1. Never delete original notebooks (keep for reproducibility)
2. Create new notebooks for new analyses (06_new_analysis.ipynb)
3. Version Power BI file (v1, v2, etc.) or use Save As
4. Keep database backups before major changes

---

## Troubleshooting

### Missing Files After Git Clone
Run notebooks 01, 03, 04, 05 to regenerate:
```bash
jupyter notebook notebooks/01_download_worldbank_data.ipynb
# ...etc
```

### Database Errors
Delete `humanitarian_health.db` and run notebook 04 again:
```bash
rm humanitarian_health.db
jupyter notebook notebooks/04_load_to_sqlite.ipynb
```

### Power BI Import Issues
1. Regenerate CSV files using notebook 05
2. In Power BI, "Refresh" → "Get Data" → select CSV folder
3. Re-establish relationships between tables

### API Errors
World Bank API sometimes times out. Retry notebook 01 or set:
```python
import time
time.sleep(2)  # Add delay between requests
```

---

**Last Updated:** August 16, 2026  
**Project Status:** Complete ✅
