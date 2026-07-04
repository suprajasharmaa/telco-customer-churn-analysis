CREATE DATABASE IF NOT EXISTS telco_churn;
USE telco_churn;
-- Distribution check: how is tenure spread across customers?
-- Logic: bucket customers into tenure ranges, count how many fall in each bucket
SELECT
  CASE
    WHEN tenure <= 12 THEN '0-12 months'
    WHEN tenure BETWEEN 13 AND 24 THEN '13-24 months'
    WHEN tenure BETWEEN 25 AND 48 THEN '25-48 months'
    WHEN tenure BETWEEN 49 AND 60 THEN '49-60 months'
    ELSE '60+ months'
  END AS tenure_bucket,
  COUNT(*) AS customer_count
FROM customers
GROUP BY tenure_bucket
ORDER BY tenure_bucket;

SELECT case when MonthlyCharges between 18 and 30.99 Then 'Basic'
            when MonthlyCharges between 31 and 60.99 Then 'Low'
            when MonthlyCharges between 61 and 90.99 Then 'Mid'
            else 'High'
            end as charge_bucket,
       count(*) as customer_count
 from customers
group by charge_bucket
order by min(MonthlyCharges);

-- QUESTION 1: Do customers who churn after long tenure show different monthly charge patterns than customers who churn early - suggesting a late-stage price or value problem rather than a poor initial fit?
-- Logic: Filter to only churned customers, bucket them by tenure length, then compute the average monthly charge within each tenure bucket to see if long-tenure churners pay more than early churners.
-- Finding sentence: Customers who churn after 60+ months pay an average monthly charge of $97.32, compared to $66.49 for customers who churn within their first 12 months 
-- - a $30.83 (46%) higher monthly bill among long-tenure churners right before they leave.
-- Caveat sentence: This gap likely reflects a mix of price increases and accumulated service upgrades over time, but the dataset has no historical billing or service-change 
-- records, so the exact cause can't be confirmed - only the pattern itself.
    
    SELECT case WHEN tenure <= 12 THEN '0-12 months'
    WHEN tenure BETWEEN 13 AND 24 THEN '13-24 months'
    WHEN tenure BETWEEN 25 AND 48 THEN '25-48 months'
    WHEN tenure BETWEEN 49 AND 60 THEN '49-60 months'
    ELSE '60+ months'
  END AS tenure_bucket,
  round(avg(MonthlyCharges),2) as avg_monthly_charge, count(*) as customer_count from customers
            where Churn='Yes' 
            group by tenure_bucket
            order by tenure_bucket;
            

-- QUESTION 2: At the same tenure length, do churned customers have fewer add-on services than customers who stayed - indicating that under-served customers are more likely to leave?
-- Logic: Bucket customers by tenure, sum each customer's add-on services (OnlineSecurity, OnlineBackup, DeviceProtection, TechSupport, StreamingTV, StreamingMovies), then compare 
-- the average add-on count between churned and retained customers within each tenure bucket.
-- Finding: Contrary to the hypothesis that under-served customers churn more, churned customers had MORE add-on services than retained customers at every single tenure 
-- level - for example, in the 13-24 month bracket, churned customers averaged 1.96 add-ons compared to 1.44 for retained customers, a 36% higher add-on count among 
-- those who left. This pattern holds consistently from 0 months to 60+ months, ruling out the original hypothesis entirely — but it raises a new question instead: customers 
-- with more add-ons likely have higher bills (as seen in Q1), suggesting churn may be driven by accumulated cost rather than lack of service.

SELECT
  CASE WHEN tenure <= 12 THEN '0-12 months'
       WHEN tenure BETWEEN 13 AND 24 THEN '13-24 months'
       WHEN tenure BETWEEN 25 AND 48 THEN '25-48 months'
       WHEN tenure BETWEEN 49 AND 60 THEN '49-60 months'
       ELSE '60+ months'
  END AS tenure_bucket,

  AVG(CASE WHEN Churn = 'No' THEN
        (CASE WHEN OnlineSecurity='Yes' THEN 1 ELSE 0 END +
         CASE WHEN OnlineBackup='Yes' THEN 1 ELSE 0 END +
         CASE WHEN DeviceProtection='Yes' THEN 1 ELSE 0 END +
         CASE WHEN TechSupport='Yes' THEN 1 ELSE 0 END +
         CASE WHEN StreamingTV='Yes' THEN 1 ELSE 0 END +
         CASE WHEN StreamingMovies='Yes' THEN 1 ELSE 0 END)
      END) AS avg_addon_no,

  AVG(CASE WHEN Churn = 'Yes' THEN
        (CASE WHEN OnlineSecurity='Yes' THEN 1 ELSE 0 END +
         CASE WHEN OnlineBackup='Yes' THEN 1 ELSE 0 END +
         CASE WHEN DeviceProtection='Yes' THEN 1 ELSE 0 END +
         CASE WHEN TechSupport='Yes' THEN 1 ELSE 0 END +
         CASE WHEN StreamingTV='Yes' THEN 1 ELSE 0 END +
         CASE WHEN StreamingMovies='Yes' THEN 1 ELSE 0 END)
      END) AS avg_addon_yes,

  COUNT(CASE WHEN Churn = 'No' THEN 1 END) AS count_no,
  COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) AS count_yes

FROM customers
GROUP BY tenure_bucket
ORDER BY MIN(tenure);

-- QUESTION 3: Do Fiber optic customers churn at a higher rate than DSL customers despite paying a premium - suggesting a value mismatch?
-- Logic: Group customers by InternetService type, then calculate the average monthly charge and the churn rate (% of customers who churned) within each group, to see 
-- if paying more for Fiber correlates with leaving more often.
-- Finding sentence: Fiber optic customers pay an average of $91.50/month - about 58% more than DSL customers ($58.09) - yet churn at more than double the rate (41.89% 
-- vs 19%), confirming a real value mismatch rather than just a pricing difference.
-- Caveat sentence: This shows a correlation between higher price and higher churn for Fiber customers, but the dataset doesn't reveal the root cause - it could be price 
-- sensitivity, service quality issues, or stronger competitor offers in the fiber market, none of which can be directly confirmed with this data.

SELECT internetservice, round(avg(MonthlyCharges),2) as avg_monthly_charges, 
concat(round(count(case when churn='Yes' then 1 END)*100/ count(*),2),'%') as churn_rate_pct
from customers group by internetservice;

-- QUESTION 4: Are senior citizens using paperless billing/electronic check more  likely to churn than senior citizens using traditional payment methods - 
-- suggesting digital friction rather than service dissatisfaction?
-- Logic: Filter to senior citizens only, then group them into 'Digital' (PaperlessBilling = 'Yes' OR PaymentMethod = 'Electronic check') vs 'Traditional' (everyone else), and 
-- calculate the churn rate within each group to see if digital billing/payment methods correlate with higher churn among older customers.
-- Finding sentence: Senior citizens using digital billing or electronic check payment churn at 44.96%, nearly double the 22.94% churn rate of senior citizens using 
-- traditional payment methods - a 22 percentage point gap.
-- Caveat sentence: This pattern is consistent with digital friction (difficulty managing online billing/payments), but it could also reflect other factors like 
-- income level or technology comfort that the dataset doesn't directly measure the correlation is clear, but the exact cause can't be confirmed.

SELECT case when PaperlessBilling = 'Yes' OR PaymentMethod = 'Electronic check' THEN 'Digital' ELSE 'Traditional' END as paymentmethod_bysc, 
concat(round(count(case when churn='Yes' then 1 END)*100/ count(*),2),'%') as churn_pct 
from customers where SeniorCitizen=1 
group by paymentmethod_bysc;

-- QUESTION 5: Do customers with a partner and/or dependents churn less than single customers with no dependents - suggesting household stability lowers churn?
-- Logic: Group customers into 'settled' (Partner = 'Yes' OR Dependents = 'Yes') vs 'single' (neither), then calculate the churn rate within each group to see if 
-- household stability correlates with lower churn.
-- Finding sentence: Single customers with no partner and no dependents churn at  34.24%, compared to just 19.88% for customers with a partner and/or dependents - 
-- single customers churn at nearly double the rate (1.7x higher).
-- Caveat sentence: This supports the idea that household stability reduces churn, but the dataset can't confirm the mechanism - it could be financial stability from a 
-- shared household, less willingness to disrupt family routines by switching providers, or simply that single customers are younger and more price-sensitive. Any of these 
-- would produce the same pattern.

SELECT case when Partner='Yes' or Dependents= 'Yes' then 'settled' else 'single' end as household_stability, 
concat(round(count(case when churn='Yes' then 1 END)*100/ count(*),2),'%') as churn_pct 
from customers
group by household_stability;

-- QUESTION 6 (Bonus): Which internet service type has the highest churn rate,  and how does it rank against the others when accounting for average monthly charges?
-- Logic: Use a CTE to first calculate average monthly charge and churn rate per  InternetService type, then rank the three types by churn rate using RANK().
-- Finding: Fiber optic customers rank #1 in churn at 41.89%, more than double DSL's  19.00% (#2), despite paying 58% more per month ($91.50 vs $58.09) - confirming 
-- the value mismatch found in Question 3, now demonstrated using a CTE and window function.

WITH churn_by_service AS (
  SELECT 
    InternetService,
    ROUND(AVG(MonthlyCharges),2) AS avg_monthly_charges,
    ROUND(COUNT(CASE WHEN churn='Yes' THEN 1 END)*100/ COUNT(*),2) AS churn_rate
  FROM customers
  GROUP BY InternetService
)

SELECT * , rank() over (order by churn_rate desc) as rnk from churn_by_service;

-- QUESTION 7 (Bonus): How does churn rate change from one tenure bucket to the next,  and at which transition does churn drop most sharply?
-- Logic: Use a CTE to calculate churn rate per tenure bucket, then use LAG() to pull  in the previous bucket's churn rate and calculate the difference between consecutive 
-- buckets, revealing where retention improves the most as customers age in.
-- Finding: Churn rate drops from 47.68% in the 0-12 month bucket to 28.71% in the  13-24 month bucket - an 18.97 percentage point drop, the steepest decline of any 
-- transition in the dataset. This confirms the first year is the highest-risk window,  and retention efforts concentrated there would have the largest impact on overall churn.

WITH churn_by_tenure AS 
( SELECT CASE WHEN tenure <= 12 THEN '0-12 months' 
WHEN tenure BETWEEN 13 AND 24 THEN '13-24 months' 
WHEN tenure BETWEEN 25 AND 48 THEN '25-48 months' 
WHEN tenure BETWEEN 49 AND 60 THEN '49-60 months' ELSE '60+ months' END AS tenure_bucket, 
round(count(case when churn='Yes' then 1 END)*100/ count(*),2) as churn_rate_pct FROM customers GROUP BY tenure_bucket ORDER BY min(tenure))

SELECT *,
LAG(churn_rate_pct) OVER (ORDER BY tenure_bucket) AS previous_bucket_rate,
churn_rate_pct-LAG(churn_rate_pct) OVER (ORDER BY tenure_bucket) as diff_prev
FROM churn_by_tenure;


