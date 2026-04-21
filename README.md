Automation Scripts
A collection of Python and SQL scripts I built to automate repetitive IT operations and reporting tasks. These are based on real workflows — company-specific data has been removed and replaced with sample data.
Scripts
FilePurposeaccess_request_tracker.pyTrack and log access requests, flag least-privilege violationsdormant_accounts.sqlFind accounts with no login in 90 days for quarterly access reviewsweekly_report_generator.pyAuto-generate weekly IT operations status reportsincident_summary.pySummarize incidents from raw logs grouped by category and severityfix_duplicate_entries.sqlFind and flag duplicate records caused by interface sync errorsdata_integrity_check.sqlValidate data consistency across related tables
Why these exist
At work I kept running into the same manual tasks every week — pulling access request numbers, writing status reports, fixing data issues through the database when the system interface broke. Instead of doing them by hand, I scripted them.
Usage
bashpip install pandas

# Generate a weekly report from sample data
python weekly_report_generator.py

# Summarize incidents
python incident_summary.py

# Track and flag risky access requests
python access_request_tracker.py

# SQL scripts — run against your MySQL database
# dormant_accounts.sql
# fix_duplicate_entries.sql
# data_integrity_check.sql
Tools

Python 3.10+
MySQL
pandas (for report generation)

Note
All data in these scripts is fictional sample data. No real company or user information is included.
