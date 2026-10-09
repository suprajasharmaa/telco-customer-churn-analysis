## 📊 Telco Customer Churn Analysis

📄 [Case Study Report](./Telco_Customer_Churn_Analysis.docx) | 🗃️ [SQL Queries](./telco_churn_analysis_queries.sql)

A SQL-based analysis of 7,043 telecom customers to uncover the drivers behind churn - covering tenure, pricing, add-on services, payment behavior, and household stability. Built entirely in MySQL using CASE logic, CTEs, and window functions (RANK, LAG).

## Overview
This project analyses customer churn in a telecom dataset of 7,043 subscribers.
The goal was to identify which customer segments are most likely to cancel 
and what factors drive that decision.

## Dataset
- **Source:** Kaggle
- **Size:** 7,043 rows × 21 columns
- **Key columns:** CustomerID, Tenure, ContractType, MonthlyCharges, 
InternetService, TechSupport, Churn

## Tools Used
- MySQL (MySQL Workbench)

## Key Findings

1. Customers in their first year are the most likely to churn. Churn drops from 47.68% in the 0-12 month group to 28.71% in the 13-24 month group, an 18.97-point fall and the steepest drop between any two tenure groups .
2. Fibre optic customers churn at more than double the rate of DSL customers while paying about 58% more. Fibre churns at 41.89% against 19.00% for DSL, at $91.50 a month against $58.09.
3. Churned customers had more add-on services than retained customers at every tenure level, and long-tenure churners pay the highest bills. In the 13-24 month group, churned customers averaged 1.96 add-ons against 1.44 for retained ones. Churners with 60+ months of tenure pay $97.32 a month against $66.49 for churners in their first 12 months.
4. Senior citizens on paperless billing or electronic check churn at 44.96%, against 22.94% for seniors on traditional payment. This points to billing friction as a possible factor.
5. Single customers (no partner, no dependents) churn at 34.24%, against 19.88% for customers with a partner and/or dependents, which is about 1.7x higher.

## Recommendations
1. Focus retention effort on the first 12 months, for example with early check-ins and onboarding offers, since that is where churn is highest.
2. Review fibre pricing and service quality against competitor offers, because fibre has the highest churn despite the highest price.
3. Review whether add-ons and rising bills feel like a burden to long-tenure customers, and offer loyalty discounts or easy add-on opt-outs before the 60-month mark.
4. Offer senior citizens phone-guided help with digital billing instead of removing paperless options.
5. Target single customers with new features and promotions, since they are the group most open to switching.

**Limitation**
This is a single snapshot with no billing history or stated cancellation reasons, so every finding is a correlation and not a confirmed cause.

## Files in This Repository
- `telco_churn_analysis_queries.sql` - all queries with comments
- `Telco_Customer_Churn_Analysis.docx` - case study document written analysis

## How to Run
1. Download the CSV from Kaggle (Telco Customer Churn dataset)
2. Create a schema called `telco_churn` in MySQL Workbench
3. Import the CSV into a table called `telco_churn`
4. Run queries in order - each is commented with its business question

