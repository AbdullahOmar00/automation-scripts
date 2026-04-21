-- dormant_accounts.sql
-- Find user accounts with no login activity in the last 90 days.
-- Used for quarterly access reviews to enforce least-privilege.
-- Run against the user management database.

-- Step 1: Find all active accounts that haven't logged in recently
SELECT 
    u.user_id,
    u.username,
    u.department,
    u.role,
    u.account_status,
    u.created_date,
    u.last_login_date,
    DATEDIFF(CURDATE(), u.last_login_date) AS days_since_login
FROM users u
WHERE u.account_status = 'active'
  AND u.last_login_date < DATE_SUB(CURDATE(), INTERVAL 90 DAY)
ORDER BY u.last_login_date ASC;


-- Step 2: Count dormant accounts by department
SELECT 
    u.department,
    COUNT(*) AS dormant_accounts,
    MIN(u.last_login_date) AS oldest_login
FROM users u
WHERE u.account_status = 'active'
  AND u.last_login_date < DATE_SUB(CURDATE(), INTERVAL 90 DAY)
GROUP BY u.department
ORDER BY dormant_accounts DESC;


-- Step 3: Flag dormant accounts that still have admin or elevated roles
-- These are the highest risk — unused accounts with high privileges
SELECT 
    u.user_id,
    u.username,
    u.department,
    u.role,
    u.last_login_date,
    DATEDIFF(CURDATE(), u.last_login_date) AS days_since_login
FROM users u
WHERE u.account_status = 'active'
  AND u.last_login_date < DATE_SUB(CURDATE(), INTERVAL 90 DAY)
  AND u.role IN ('admin', 'super_admin', 'manager')
ORDER BY u.role, u.last_login_date ASC;
