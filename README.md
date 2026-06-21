# NPA-Risk-Credit-Scorecard-India
Analysed 30,000-row Indian loan dataset (2018–2025) to identify  NPA drivers and build a rule-based credit scorecard using Excel,  MySQL &amp; Power BI. Scorecard captured 64.85% of actual defaults  across occupation, CIBIL, macro environment, ALR and FOIR dimensions.

# NPA Risk Prediction & Credit Scorecard
### Indian Loan Portfolio Analysis | 2018–2025

## Overview
Analysed a 30,000-row Indian retail loan dataset spanning 2018–2025 
to identify key drivers of Non-Performing Assets (NPAs) and build 
a rule-based credit scorecard. The project replicates the analytical 
workflow of a junior risk analyst at an Indian bank — moving from 
raw borrower data to a validated scoring model across three tools.

## Business Problems Solved
| # | Problem | Key Finding |
|---|---------|-------------|
| 1 | NPA by Occupation | Farmers (50.07%) and Daily Wage Workers (47.28%) showed highest default rates |
| 2 | CIBIL Band Analysis | NPA rate drops from 61% (300-499) to 21% (800-900) — monotonic decline |
| 3 | Macro Environment Impact | Low Rate environments produced highest NPAs (37.54%) — counterintuitive finding |
| 4 | Asset-Rich Defaulters | 4,812 borrowers with ALR > 3 still defaulted — collateral alone is insufficient |
| 5 | FOIR Stress Analysis | 45.3% of portfolio in Severe FOIR band (>70%) — defaults were structurally inevitable |
| 6 | Credit Scorecard | Rule-based model captured 64.85% of actual NPAs across three risk tiers |

## Key Metrics
- **Portfolio NPA Rate:** 33.65%
- **Scorecard Capture Rate:** 64.85% of actual defaults flagged as High Risk
- **High Risk Borrowers:** 50.8% of portfolio — reflects deeply stressed loan book
- **Severe FOIR Exposure:** 45.3% of borrowers spending >70% income on debt repayment

## Tools & Methodology
| Tool | Purpose |
|------|---------|
| Microsoft Excel | Data cleaning, derived columns (ALR, FOIR, EMI), pivot analysis, scorecard |
| MySQL | SQL replication of all findings — GROUP BY, CASE WHEN, UNION ALL, subqueries |
| Power BI | Four-page interactive dashboard with DAX measures and calculated columns |

## Dataset
- 30,000 rows, 26+columns
- Borrower attributes: Occupation, Annual Income, CIBIL Score, Net Worth, Existing Debt
- Loan attributes: Loan Amount, Tenure, Total Repayment, Rate Environment
- Target variable: Loan Status (Performing / Default NPA)
- Period: 2018–2025 | Geography: India (retail lending)

## Dashboard Pages
1. **Portfolio Overview** — KPI cards, portfolio health donut chart
2. **Borrower Risk Profile** — NPA by occupation, CIBIL distribution, FOIR stress bands
3. **Macro Analysis** — Rate environment impact, loan volume trend, CIBIL by environment
4. **Scorecard Validation** — Risk tier distribution, NPA capture rate

## Author
Sushant Kumar / June 2026
