"""
Incident Summary Generator
Reads incident log data and produces a summary grouped by category and severity.
Useful for monthly reviews and management reporting.

Usage:
    python incident_summary.py
"""

import pandas as pd
from datetime import datetime

SAMPLE_INCIDENTS = [
    {"id": "INC-101", "date": "2025-01-03", "category": "Login failure", "severity": "Low", "system": "CRM", "resolved": True, "resolution_hours": 1.5},
    {"id": "INC-102", "date": "2025-01-05", "category": "Permission error", "severity": "Medium", "system": "ERP", "resolved": True, "resolution_hours": 3.0},
    {"id": "INC-103", "date": "2025-01-07", "category": "Data sync issue", "severity": "High", "system": "HR_System", "resolved": True, "resolution_hours": 6.0},
    {"id": "INC-104", "date": "2025-01-10", "category": "System downtime", "severity": "Critical", "system": "ERP", "resolved": True, "resolution_hours": 2.0},
    {"id": "INC-105", "date": "2025-01-12", "category": "Login failure", "severity": "Low", "system": "Email", "resolved": True, "resolution_hours": 0.5},
    {"id": "INC-106", "date": "2025-01-14", "category": "Permission error", "severity": "Medium", "system": "CRM", "resolved": True, "resolution_hours": 4.0},
    {"id": "INC-107", "date": "2025-01-18", "category": "Data sync issue", "severity": "High", "system": "ERP", "resolved": False, "resolution_hours": None},
    {"id": "INC-108", "date": "2025-01-20", "category": "Login failure", "severity": "Low", "system": "CRM", "resolved": True, "resolution_hours": 1.0},
]


def summarize_incidents(df):
    """Print incident summary."""
    print("=" * 55)
    print(f"INCIDENT SUMMARY — {datetime.now().strftime('%B %Y')}")
    print("=" * 55)
    print(f"Total incidents:  {len(df)}")
    print(f"Resolved:         {df['resolved'].sum()}")
    print(f"Open:             {(~df['resolved']).sum()}")

    resolved = df[df["resolved"]]
    if len(resolved) > 0:
        avg_hours = resolved["resolution_hours"].mean()
        print(f"Avg resolution:   {avg_hours:.1f} hours")
    print()

    print("By severity:")
    severity_order = ["Critical", "High", "Medium", "Low"]
    for sev in severity_order:
        count = len(df[df["severity"] == sev])
        if count > 0:
            print(f"  {sev}: {count}")
    print()

    print("By category:")
    for cat, count in df["category"].value_counts().items():
        print(f"  {cat}: {count}")
    print()

    print("By system:")
    for sys, count in df["system"].value_counts().items():
        print(f"  {sys}: {count}")
    print()

    open_incidents = df[~df["resolved"]]
    if len(open_incidents) > 0:
        print("OPEN INCIDENTS:")
        for _, row in open_incidents.iterrows():
            print(f"  {row['id']} — {row['category']} on {row['system']} (Severity: {row['severity']})")


def main():
    df = pd.DataFrame(SAMPLE_INCIDENTS)
    summarize_incidents(df)


if __name__ == "__main__":
    main()
