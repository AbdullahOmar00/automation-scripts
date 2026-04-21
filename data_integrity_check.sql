-- fix_duplicate_entries.sql
-- Find and flag duplicate records caused by interface sync errors.
-- This is a common issue when the system UI submits a form twice
-- or a batch job runs overlapping imports.
-- Always review flagged rows before deleting.

-- Step 1: Find exact duplicate rows (all fields match)
SELECT 
    username,
    system_name,
    role,
    request_date,
    COUNT(*) AS duplicate_count
FROM access_requests
GROUP BY username, system_name, role, request_date
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


-- Step 2: Show the actual duplicate rows with their IDs
-- so you can decide which one to keep
SELECT a.*
FROM access_requests a
INNER JOIN (
    SELECT 
        username, system_name, role, request_date,
        MIN(request_id) AS keep_id
    FROM access_requests
    GROUP BY username, system_name, role, request_date
    HAVING COUNT(*) > 1
) dupes ON a.username = dupes.username
       AND a.system_name = dupes.system_name
       AND a.role = dupes.role
       AND a.request_date = dupes.request_date
ORDER BY a.username, a.request_date, a.request_id;


-- Step 3: Flag duplicates for removal (keeps the earliest entry)
-- This marks them rather than deleting — safer for audit trail
UPDATE access_requests a
INNER JOIN (
    SELECT 
        username, system_name, role, request_date,
        MIN(request_id) AS keep_id
    FROM access_requests
    GROUP BY username, system_name, role, request_date
    HAVING COUNT(*) > 1
) dupes ON a.username = dupes.username
       AND a.system_name = dupes.system_name
       AND a.role = dupes.role
       AND a.request_date = dupes.request_date
SET a.status = 'FLAGGED_DUPLICATE'
WHERE a.request_id != dupes.keep_id;


-- Step 4: Verify flagged rows before final cleanup
SELECT * FROM access_requests
WHERE status = 'FLAGGED_DUPLICATE'
ORDER BY username, request_date;
