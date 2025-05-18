WITH latest_balances AS (
  SELECT s1.plan_id, s1.new_balance
  FROM savings_savingsaccount s1
  JOIN (
    SELECT plan_id, MAX(transaction_date) AS latest_date
    FROM savings_savingsaccount
    GROUP BY plan_id
  ) s2
  ON s1.plan_id = s2.plan_id AND s1.transaction_date = s2.latest_date
) -- this CTE is to get latest transaction per plan and the corresppnding new balance based on transaction_date

SELECT 
  u.id AS owner_id,
  CONCAT(u.first_name, ' ', u.last_name) AS name,
  COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 AND lb.new_balance > 0 THEN p.id END) AS savings_count, 
  COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 AND lb.new_balance > 0 THEN p.id END) AS investment_count,
 -- these counts distinct cases where it is either a savings or investment, then the latest new_balance is greater than zero. assuming funded is where the latest new balance is greater than zero
ROUND(SUM(s.confirmed_amount) / 100, 2) AS total_deposits  -- Total deposits across all transactions (not just latest)

FROM users_customuser u
JOIN plans_plan p ON u.id = p.owner_id
JOIN savings_savingsaccount s ON p.id = s.plan_id
JOIN latest_balances lb ON lb.plan_id = p.id

GROUP BY u.id, u.first_name, u.last_name
HAVING savings_count > 0 AND investment_count > 0
ORDER BY total_deposits DESC;
