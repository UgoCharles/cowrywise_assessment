SELECT
  u.id AS customer_id,
  CONCAT(u.first_name, ' ', u.last_name) AS name, -- i used concatenation to get the full customer name
  TIMESTAMPDIFF(MONTH, u.created_on, CURDATE()) AS tenure_months, -- i used this function to get the difference between the sign up date and current date. returns a value in months.
  COUNT(s.id) AS total_transactions,
  ROUND(
    (COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.created_on, CURDATE()), 0)) * 12 * AVG(s.confirmed_amount) * 0.001 / 100, 2) AS estimated_clv -- added NULLIF incase of where tenure_month is zero to prevent division by zero. Then i converted the kobo value to naira
FROM users_customuser u
LEFT JOIN savings_savingsaccount s ON s.owner_id = u.id AND s.confirmed_amount > 0 -- I made sure to filter for confrimed amount greater than 0 to be sure there was actual inflow and my estimated_cltv is more accurate
GROUP BY u.id, u.first_name, u.last_name, u.created_on
ORDER BY estimated_clv DESC;
