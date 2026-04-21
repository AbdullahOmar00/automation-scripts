"""
Access Request Tracker
Logs and summarizes access requests from a CSV export.
Flags requests that violate least-privilege principles.

Usage:
    python access_request_tracker.py

Input:  CSV file with columns: request_id, user, system, role_requested, department, date
Output: Summary printed to console + flagged_requests.csv
"""

import pandas as pd
from datetime import datetime
import os

# Sample data — replace with your actual CSV export path
SAMPLE_DATA = [
    {"request_id": "REQ-001", "user": "user_a", "system": "ERP", "role_requested": "admin", "department": "Finance", "date": "2025-01-15"},
    {"request_id": "REQ-002", "user": "user_b", "system": "CRM", "role_requested": "read_only", "department": "Sales", "date": "2025-01-15"},
    {"request_id": "REQ-003", "user": "user_c", "system": "HR_System", "role_requested": "admin", "department": "Marketing", "date": "2025-01-16"},
    {"request_id": "REQ-004", "user": "user_d", "system": "ERP", "role_requested": "editor", "department": "Finance", "date": "2025-01-16"},
    {"request_id": "REQ-005", "user": "user_e", "system": "CRM", "role_requested": "admin", "department": "IT", "date": "2025-01-17"},
    {"request_id": "REQ-006", "user": "user_f", "system": "ERP", "role_requested": "read_only", "department": "HR", "date": "2025-01-17"},
    {"request_id": "REQ-007", "user": "user_g", "system": "HR_System", "role_requested": "admin", "department": "Sales", "date": "2025-01-18"},
    {"request_id": "REQ-008", "user": "user_h", "system": "CRM", "role_requested": "editor", "department": "Finance", "date": "2025-01-18"},
]

# Roles that should be flagged for review — admin access from non-IT departments
HIGH_RISK_ROLE = "admin"
EXEMPT_DEPARTMENTS = ["IT", "Security"]


def load_requests(csv_path=None):
    """Load access requests from CSV or use sample data."""
    if csv_path and os.path.exists(csv_path):
        return pd.read_csv(csv_path)
    return pd.DataFrame(SAMPLE_DATA)


def flag_risky_requests(df):
    """Flag admin requests from departments that typically shouldn't have admin access."""
    flagged = df[
        (df["role_requested"] == HIGH_RISK_ROLE) &
        (~df["department"].isin(EXEMPT_DEPARTMENTS))
    ].copy()
    flagged["flag_reason"] = "Admin access requested by non-IT/Security department"
    return flagged


def generate_summary(df, flagged):
    """Print a summary of access requests."""
    print("=" * 50)
    print(f"ACCESS REQUEST SUMMARY — {datetime.now().strftime('%Y-%m-%d')}")
    print("=" * 50)
    print(f"Total requests:        {len(df)}")
    print(f"Unique systems:        {df['system'].nunique()}")
    print(f"Unique users:          {df['user'].nunique()}")
    print(f"Flagged for review:    {len(flagged)}")
    print()

    print("Requests by system:")
    for system, count in df["system"].value_counts().items():
        print(f"  {system}: {count}")
    print()

    print("Requests by role:")
    for role, count in df["role_requested"].value_counts().items():
        print(f"  {role}: {count}")
    print()

    if len(flagged) > 0:
        print("FLAGGED REQUESTS:")
        for _, row in flagged.iterrows():
            print(f"  {row['request_id']} — {row['user']} requesting {row['role_requested']} on {row['system']} (Dept: {row['department']})")
    else:
        print("No flagged requests.")


def main():
    df = load_requests()
    flagged = flag_risky_requests(df)
    generate_summary(df, flagged)

    if len(flagged) > 0:
        output_path = "flagged_requests.csv"
        flagged.to_csv(output_path, index=False)
        print(f"\nFlagged requests saved to {output_path}")


if __name__ == "__main__":
    main()
