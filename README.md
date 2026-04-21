# Automation Scripts

A collection of Python and SQL scripts I built to automate repetitive IT operations and reporting tasks. These are based on real workflows — company-specific data has been removed and replaced with sample data.

## Structure

```
automation-scripts/
├── access-management/
│   ├── access_request_tracker.py     # Track and log access requests
│   └── dormant_accounts.sql          # Find accounts with no login in 90 days
├── reporting/
│   ├── weekly_report_generator.py    # Auto-generate weekly status reports
│   └── incident_summary.py          # Summarize incidents from raw logs
├── sql-troubleshooting/
│   ├── fix_duplicate_entries.sql     # Find and flag duplicate records
│   └── data_integrity_check.sql     # Validate data consistency across tables
└── requirements.txt
```

## Why these exist

At work I kept running into the same manual tasks every week — pulling access request numbers, writing status reports, fixing data issues through the database when the system interface broke. Instead of doing them by hand, I scripted them.

## Usage

```bash
pip install -r requirements.txt

# Generate a weekly report from sample data
python reporting/weekly_report_generator.py

# Check for dormant accounts
# Run dormant_accounts.sql against your MySQL database
```

## Tools

- Python 3.10+
- MySQL
- pandas (for report generation)

## Note

All data in these scripts is fictional sample data. No real company or user information is included.
