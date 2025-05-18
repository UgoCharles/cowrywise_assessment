# cowrywise_assessment
Assessment for Ugochukwu Otuokere

**Assessment_Q1**

This question required an output of customers who have at least one savings or funded plan. with "funded" in the context of cowrywise i had to assume the latest new balance on the **savings_savingsaccount** for each plan_id was recorded as a CTE. my approach was as follows

**Approach:**

- I used a Common Table Expression (CTE) to extract the most recent transaction per plan based on the transaction_date.
- From this latest transaction, I retrieved the new_balance and used it to determine whether the plan is considered funded.

**In the main query:**

- I counted how many funded savings plans and investment plans each customer has.
- I calculated total deposits across all transactions by summing the confirmed_amount (converted from kobo to Naira).
- The HAVING clause ensures that only customers with at least one funded savings plan and one funded investment plan are included.
- Finally, I sorted the results by total deposits in descending order to highlight the most valuable customers.

**Challenges:**

The main challenge i encountered here was trying to find out what a funded savings or investment account really was. i had to deep dive into the columns and found the new_balance column which i assumed a funded plan is one where the new_balance is greater than zero — meaning money has been deposited and not fully withdrawn.


**Assessment_Q2**

This task required categorization of customers into three distinct frequencies after calculating average transactions-per-month. The logical approach used three CTEs where each CTE was used as a step to the next logic
see steps below

**Approach:**

- I began by calculating the number of transactions per customer per month using a Common Table Expression (CTE). Grouping by both year and month ensures that monthly activity is correctly isolated over time.
- In the second CTE, I computed the average number of monthly transactions per customer, giving a clear measure of how often each user engages on a recurring basis.
- The third CTE uses this average to categorize customers into:
 High Frequency: 10 or more transactions/month
 Medium Frequency: 3–9 transactions/month
 Low Frequency: fewer than 3 transactions/month

- Finally, the outer query returns the total number of customers in each category, along with the average monthly transaction count for that group. I also used the FIELD() function to ensure the results are ordered logically from highest to lowest frequency category.

**Assessment_Q3**

To get customers who have not made transactions in over a year, the last transaction date and current data were instrumental in getting accurate results. also, adding a filter transaction_status = success ensured we only picked rows where there were successful transactions

**Approach:**
- I started by joining plans_plan with savings_savingsaccount to access transaction data linked to each plan.
- For each plan, I used a CASE statement to label it as either a Savings or Investment plan based on flag fields.
- I filtered for only successful transactions to ensure accuracy when identifying true inactivity.
- Using MAX(transaction_date), I retrieved the most recent transaction for each plan.
- Then I calculated the number of days since the last transaction using DATEDIFF(CURDATE(), MAX(transaction_date)). If there are no transactions, this value is NULL.
- The HAVING clause filters for:
   Plans that have never had a transaction (last_transaction_date IS NULL), or
   Plans that haven’t had a transaction in over 365 days.
- Results are ordered by inactivity_days so the oldest inactive plans are at the top.


**Assessment_Q4**


**Approach:**

- I selected relevant fields from the users_customuser table, including a full name (created using CONCAT) and the account tenure in months (calculated using TIMESTAMPDIFF between the signup date and today).
- I joined the savings_savingsaccount table to get transaction data and filtered for confirmed amounts greater than zero to ensure we’re only analyzing real deposits.
- The total number of qualifying transactions per customer is counted using COUNT(s.id).
- For the CLV calculation, I used the formula specified in the document
Where:
   The average profit is approximated as 0.1% of the average confirmed amount, converted from kobo to Naira.
   NULLIF is used to avoid division by zero if a customer has zero months of tenure.

- Finally, I ordered the results by estimated_clv in descending order to highlight the most valuable customers.

