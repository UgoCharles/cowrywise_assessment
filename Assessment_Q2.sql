WITH transactions_per_customer_month AS (
    SELECT 
        s.owner_id,
        YEAR(s.created_on) AS year,
        MONTH(s.created_on) AS month,
        COUNT(*) AS total_transactions
    FROM savings_savingsaccount s
    GROUP BY s.owner_id, YEAR(s.created_on), MONTH(s.created_on)
), -- this CTE aggregates the count of transactions for all customers by year and month. this ensures all months are unique for individual years

avg_transactions_per_customer AS (
    SELECT 
        owner_id,
        AVG(total_transactions) AS avg_tx_per_month
    FROM transactions_per_customer_month
    GROUP BY owner_id
), -- this CTE ensures the correct averages of all customer transactions and respective customers

categorized_customers AS (
    SELECT 
        CASE 
            WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
            WHEN avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_tx_per_month
    FROM avg_transactions_per_customer
) -- this CTE now segments these averages into three categories based on the output of the CTE above.

SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_tx_per_month), 1) AS avg_transactions_per_month
FROM categorized_customers
GROUP BY frequency_category
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
-- this final select function counts the customers for each categorized label and rounds the average of the transactions per month