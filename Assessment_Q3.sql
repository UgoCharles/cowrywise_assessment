SELECT 
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    MAX(s.transaction_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days -- used this function to know how many days since the last a transaction was made
FROM plans_plan p
LEFT JOIN savings_savingsaccount s ON p.id = s.plan_id
WHERE (p.is_regular_savings = 1 OR p.is_a_fund = 1) AND transaction_status = "Success"
GROUP BY p.id, p.owner_id, type
HAVING last_transaction_date IS NULL OR DATEDIFF(CURDATE(), last_transaction_date) > 365 -- added a filter here to the output to ensure all users with no transactions in over a year are highlighted.
ORDER BY inactivity_days ASC;
