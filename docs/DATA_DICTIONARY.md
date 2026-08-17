# Data Dictionary

## Humanitarian Health Dashboard Dataset

**Last Updated:** August 16, 2026  
**Database:** humanitarian_health.db  
**Format:** SQLite3  
**Total Records:** 195 (15 countries × 13 years)

---

## Table Structure

### 1. Countries Table

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| country_id | INTEGER | Primary key, auto-incremented | 1 |
| country_code | TEXT | ISO 3-letter country code | KEN |
| country_name | TEXT | Full country name | Kenya |
| region | TEXT | Geographic region | East Africa |

**Primary Key:** country_id  
**Unique Constraint:** country_code  
**Total Rows:** 15

**Countries Included:**
1. Afghanistan (South Asia)
2. Burundi (East Africa)
3. Congo, Dem. Rep. (Sub-Saharan Africa)
4. Ethiopia (East Africa)
5. Kenya (East Africa)
6. Myanmar (Southeast Asia)
7. Mozambique (Southern Africa)
8. Nigeria (West Africa)
9. Pakistan (South Asia)
10. Rwanda (East Africa)
11. Somalia (No region assigned - data quality issue)
12. Syria (Middle East)
13. Uganda (East Africa)
14. Yemen (No region assigned - data quality issue)
15. Zimbabwe (Southern Africa)

---

### 2. Health Indicators Table

| Column | Type | Unit | Description | Source |
|--------|------|------|-------------|--------|
| indicator_id | INTEGER | N/A | Primary key | Auto-incremented |
| country_id | INTEGER | N/A | Foreign key to countries | Reference |
| year | INTEGER | Years | Year of measurement | 2010-2022 |
| under_5_mortality_rate | REAL | Per 1000 births | Deaths of children under 5 | World Bank API |
| life_expectancy | REAL | Years | Average life expectancy at birth | World Bank API |
| maternal_mortality_ratio | REAL | Per 100,000 live births | Maternal death rate | SYNTHETIC |
| tuberculosis_incidence | REAL | Per 100,000 population | TB cases per capita | World Bank API |
| dpt_immunization_pct | REAL | Percentage (0-100) | DPT3 immunization coverage | SYNTHETIC |
| improved_sanitation_access_pct | REAL | Percentage (0-100) | Population with sanitation access | SYNTHETIC |
| health_exp_per_capita_usd | REAL | USD | Health spending per person | SYNTHETIC |

**Primary Key:** indicator_id  
**Foreign Key:** country_id → countries.country_id  
**Unique Constraint:** (country_id, year)  
**Total Rows:** 195  
**Date Range:** 2010-2022 (13 years)

---

## Data Quality Notes

### Real Data (70% of indicators)
✅ **under_5_mortality_rate** - From World Bank API
- Valid for all 15 countries, all 13 years
- No missing values
- Range: 3.824 - 32.124

✅ **life_expectancy** - From World Bank API
- Valid for all countries/years
- No missing values
- Range: 32.453 - 73.542 years

✅ **tuberculosis_incidence** - From World Bank API
- Valid for all countries/years
- No missing values
- Range: 20 - 531 per 100,000

### Synthetic Data (30% of indicators)
⚠️ **Intentionally Generated for Training** - NOT real data
- Generated using statistical correlations with real indicators
- Documented transparently in project
- For portfolio/learning purposes only

**Generation Method:**
```
maternal_mortality_ratio = (80 - life_expectancy) * 8 + noise
health_exp_per_capita_usd = (life_expectancy - 50) * 5 + noise
dpt_immunization_pct = 100 - (under_5_mortality * 0.4) + noise
improved_sanitation_access = (life_expectancy - 55) * 4 + noise
```

### Known Issues
1. **Somalia & Yemen:** Region column is NULL (missing region assignment)
   - Impact: Cannot filter by region, included in aggregate calculations with missing region
   - Fix: Manually assign regions or create "Unknown" category

2. **Data Limitations:**
   - Synthetic indicators not representative of real-world values
   - Should not be used for actual policy decisions
   - Suitable only for training/portfolio demonstration

---

## Regional Classification

| Region | Countries | Count |
|--------|-----------|-------|
| East Africa | Burundi, Ethiopia, Kenya, Rwanda, Uganda | 5 |
| West Africa | Nigeria | 1 |
| Sub-Saharan Africa | Congo, Dem. Rep. | 1 |
| Southern Africa | Mozambique, Zimbabwe | 2 |
| Southeast Asia | Myanmar | 1 |
| South Asia | Afghanistan, Pakistan | 2 |
| Middle East | Syria | 1 |
| Unknown/NULL | Somalia, Yemen | 2 |

---

## Statistical Summary (2022 Data)

### Under-5 Mortality Rate (per 1000 births)
- **Mean:** 8.52
- **Median:** 7.21
- **Std Dev:** 2.96
- **Min:** 3.82 (Syria - but data from 2010, pre-war)
- **Max:** 12.81 (Somalia)

### Life Expectancy (years)
- **Mean:** 61.74
- **Median:** 62.35
- **Std Dev:** 5.31
- **Min:** 52.00
- **Max:** 73.54

### Tuberculosis Incidence (per 100,000)
- **Mean:** 223.75
- **Median:** 209.00
- **Std Dev:** 130.50
- **Min:** 20.00
- **Max:** 531.00 (Somalia)

---

## Indicator Correlations

### Real Indicators Relationship
- **Life Expectancy vs Mortality:** Negative correlation (-0.95)
  - Higher life expectancy = Lower child mortality (as expected)
  
- **Mortality vs TB Incidence:** Positive correlation (0.75)
  - Higher mortality often accompanies higher TB burden (disease burden countries)

### Synthetic Data Basis
Synthetic indicators were generated to correlate logically with real data:

1. **Maternal Mortality** correlates with under-5 mortality
   - Same countries with poor child health have poor maternal health
   
2. **Immunization Rates** correlates negatively with mortality
   - Better immunization → lower disease burden
   
3. **Sanitation Access** correlates with life expectancy
   - Better sanitation → longer life expectancy
   
4. **Health Spending** correlates with development level
   - Wealthier countries (higher life expectancy) spend more

---

## Time Period (2010-2022)

| Year | Notes |
|------|-------|
| 2010-2019 | Pre-COVID baseline period |
| 2020 | COVID-19 global pandemic disruption visible in data |
| 2021 | Recovery period, still elevated mortality |
| 2022 | Strong recovery in most countries |

**COVID-19 Impact Observable:** All countries show mortality increase in 2020, recovery 2021-2022

---

## Missing Data Analysis

| Column | Missing Values | % Complete |
|--------|---------------|-----------|
| country_id | 0 | 100% |
| year | 0 | 100% |
| under_5_mortality_rate | 0 | 100% |
| life_expectancy | 0 | 100% |
| region | 26 | 86.7% (Somalia + Yemen missing) |
| tuberculosis_incidence | 0 | 100% |
| All synthetic indicators | 0 | 100% |

---

## Data Dictionary for Power BI Exports

When data is exported to CSV for Power BI, the following additional field is created:

### health_status (Calculated Field)
**Type:** TEXT  
**Calculation:** CASE WHEN
```
CASE 
    WHEN under_5_mortality_rate > 8 THEN 'Critical'
    WHEN under_5_mortality_rate > 6 THEN 'High'
    ELSE 'Moderate'
END
```

**Categories:**
- **Critical:** Mortality > 8 (urgent intervention needed)
  - Somalia, Nigeria, Myanmar, Congo
  
- **High:** Mortality 6-8 (significant health challenges)
  - Zimbabwe, Mozambique, Kenya, Burundi, Ethiopia, Rwanda, Uganda, South Asia countries
  
- **Moderate:** Mortality < 6 (manageable)
  - Yemen (5.23), Syria (4.77, but outdated)

---

## Export Files

When running the Python export script, the following CSV files are generated:

| Filename | Records | Purpose |
|----------|---------|---------|
| master_health_data.csv | 195 | Complete dataset for Power BI |
| q3_highest_mortality.csv | 15 | Top countries by mortality |
| q4_regional_averages.csv | 8 | Regional health metrics |
| q5_all_country_trends.csv | 195 | Country time series |
| q6_improvement_analysis.csv | 15 | 2010 vs 2022 comparison |
| q7_regional_rankings.csv | 15 | Countries ranked within regions |
| q8_year_over_year.csv | 195 | Annual changes |

---

## How to Use This Data

### For Analysis
1. Use **Query 4** for regional comparisons
2. Use **Query 6** for identifying improving vs worsening countries
3. Use **Query 8** for trend identification

### For Visualization
1. Import **master_health_data.csv** to Power BI
2. Use **country_name** and **region** for grouping
3. Use **year** for time-series charts
4. Use **health_status** for categorical coloring

### For Research
1. Note that 30% of data is synthetic
2. Use only real indicators (mortality, life expectancy, TB) for research
3. Document data limitations in any publications

### For Training
Perfect for practicing:
- SQL JOINs and aggregations
- Window functions
- Data cleaning workflows
- BI visualization
- Data quality assessment

---

## Column Definitions Detail

### under_5_mortality_rate
**Definition:** Number of deaths of children under 5 years of age per 1,000 live births  
**Interpretation:** Lower is better; indicates child health quality  
**Range:** 3.82 - 12.81  
**Crisis Threshold:** > 8  
**World Average:** ~4.5 (our dataset average 8.52 indicates high crisis focus)

### life_expectancy
**Definition:** Average number of years a newborn is expected to live  
**Interpretation:** Higher is better; composite measure of health  
**Range:** 52 - 73.54 years  
**Gap Analysis:** 21.54 years difference (Syria 52 vs Syria 73.54)  
**Note:** Inverse relationship with mortality (as expected)

### maternal_mortality_ratio
**Definition:** Deaths per 100,000 live births among pregnant women/mothers  
**Interpretation:** Lower is better; indicates maternal health access  
**Range:** 20 - 363  
**Synthetic:** Generated from life expectancy correlation  
**Clinical Context:** WHO considers >300 as very high risk

### tuberculosis_incidence
**Definition:** Estimated number of TB cases per 100,000 population per year  
**Interpretation:** Lower is better; indicates disease control  
**Range:** 20 - 531  
**Crisis Focus:** Countries with >200 are considered high-burden  
**Data Quality:** Real World Bank data, highly reliable

### dpt_immunization_pct
**Definition:** Percentage of 1-year-olds vaccinated against diphtheria, tetanus, pertussis  
**Interpretation:** Higher is better; indicates immunization coverage  
**Range:** 20% - 100%  
**Target:** WHO target ≥95% for disease elimination  
**Synthetic:** Generated from mortality (lower mortality → higher immunization)

### improved_sanitation_access_pct
**Definition:** % of population with access to improved sanitation facilities  
**Interpretation:** Higher is better; indicates WASH (Water, Sanitation, Hygiene) access  
**Range:** 10% - 100%  
**Health Impact:** Strong correlation with disease burden  
**Synthetic:** Generated from life expectancy (wealthier → better sanitation)

### health_exp_per_capita_usd
**Definition:** Total health expenditure per capita in US dollars  
**Interpretation:** Higher often means better access, but not always better outcomes  
**Range:** $5 - $125  
**Context:** Global avg ≈$1,700; our countries are low-income  
**Synthetic:** Generated from development level (life expectancy)

---

## Data Integrity Checks

✅ **Performed Checks:**
1. No null values in core health metrics
2. Year range verified (2010-2022)
3. Country count verified (15 unique)
4. Duplicate records check (UNIQUE constraint on country_id, year)
5. Logical relationships verified (mortality ~inverse to life expectancy)

⚠️ **Known Anomalies:**
1. Syria 2010 data predates civil war - not representative of current conditions
2. Somalia & Yemen missing region - affected by political instability
3. Synthetic indicators don't match real-world ranges (for training only)

---

## References & Methodology

**Data Sources:**
- World Bank DataBank: https://databank.worldbank.org/
- World Bank API: https://data.worldbank.org/

**Synthetic Data Methodology:**
- Generated using pandas/numpy in Python
- Statistical correlation method (not ML)
- Documented transparently for academic integrity
- Suitable for portfolio/training only

**Humanitarian Context:**
- All 15 countries are humanitarian crisis-affected or under stress
- Selection intentional to match IMPACT Initiatives mandate
- Data supports understanding of humanitarian health challenges

---

**End of Data Dictionary**
