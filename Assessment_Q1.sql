SELECT 
    u.id AS owner_id,
	CONCAT(u.first_name, ' ', u.last_name) as customer_name, -- i did a concatenation to get the full customer name
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
    ROUND(SUM(s.confirmed_amount) / 100, 2) AS total_deposits -- I did this conversion to get the Naira value from Kobo
FROM users_customuser u
JOIN plans_plan p ON u.id = p.owner_id
JOIN savings_savingsaccount s ON p.id = s.plan_id
GROUP BY u.id, customer_name
HAVING 
    savings_count > 0 AND
    investment_count > 0 AND
    ROUND(SUM(s.new_balance) / 100, 2) > 0 -- This filter ensures we have customers with a funded account, assuming new_balance is the current balance on the account. 
ORDER BY total_deposits DESC;