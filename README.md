# Telco Customer Churn Analysis

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
1. Customers on month-to-month contracts churn at significantly higher 
rates than those on long-term contracts
2. Fibre optic customers without tech support churn at 2× the rate of 
those with support
3. Customers with higher monthly charges and no add-on services are the 
highest risk segment
4. Electronic bill pay customers show higher churn - suggesting billing 
friction as a factor
5. Single occupant households churn more than family households

## Recommendations
1. Offer loyalty incentives to month-to-month customers to convert to 
annual contracts
2. Bundle tech support into fibre plans during onboarding
3. Flag new customers with month-to-month contracts and no add-ons as 
high-risk for proactive outreach

## Files in This Repository
- `churn_analysis.sql` - all queries with comments
- `findings_summary.pdf` - 1-page written analysis

## How to Run
1. Download the CSV from Kaggle (Telco Customer Churn dataset)
2. Create a schema called `telco_churn` in MySQL Workbench
3. Import the CSV into a table called `telco_churn`
4. Run queries in order - each is commented with its business question

## 📊 Telco Customer Churn Analysis

📄 [Case Study Report](./Telco_Customer_Churn_Analysis.docx) | 🗃️ [SQL Queries](./telco_churn_analysis_queries.sql)

A SQL-based analysis of 7,043 telecom customers to uncover the drivers behind churn — covering tenure, pricing, add-on services, payment behavior, and household stability. Built entirely in MySQL using CASE logic, CTEs, and window functions (RANK, LAG).
