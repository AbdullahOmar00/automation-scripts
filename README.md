# Automation Scripts

A collection of Python and SQL scripts I built to automate repetitive IT operations and reporting tasks. These are based on real workflows — company-specific data has been removed and replaced with sample data.

## Scripts

| File | Purpose |
|------|---------|
| `access_request_tracker.py` | Track and log access requests, flag least-privilege violations |
| `dormant_accounts.sql` | Find accounts with no login in 90 days for quarterly access reviews |
| `weekly_report_generator.py` | Auto-generate weekly IT operations status reports |
| `incident_summary.py` | Summarize incidents from raw logs grouped by category and severity |
| `fix_duplicate_entries.sql` | Find and flag duplicate records caused by interface sync errors |
| `data_integrity_check.sql` | Validate data consistency across related tables |

## Why these exist

At work I kept running into the same manual tasks every week — pulling access request numbers, writing status reports, fixing data issues through the database when the system interface broke. Instead of doing them by hand, I scripted them.

## Usage

```bash
pip install pandas

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
```

## Tools

- Python 3.10+
- MySQL
- pandas (for report generation)

## Note

All data in these scripts is fictional sample data. No real company or user information is included.
