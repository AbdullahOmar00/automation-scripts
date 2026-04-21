"""
Weekly Report Generator
Pulls data from structured logs and generates a formatted weekly status report.
Saves output as a markdown file ready to paste into email or Jira.

Usage:
    python weekly_report_generator.py

Output: weekly_report_YYYY-MM-DD.md
"""

from datetime import datetime, timedelta
import os

# Sample weekly data — in production this would come from a database or API
SAMPLE_WEEK_DATA = {
    "access_requests": {
        "total": 18,
        "completed": 16,
        "pending": 2,
        "by_system": {
            "ERP": 7,
            "CRM": 6,
            "HR_System": 3,
            "Email": 2
        }
    },
    "incidents": {
        "total": 5,
        "resolved": 4,
        "open": 1,
        "escalated": 0,
        "categories": {
            "Login failure": 2,
            "Permission error": 1,
            "Data sync issue": 1,
            "System downtime": 1
        }
    },
    "sla": {
        "access_request_avg_hours": 4.2,
        "access_request_target_hours": 8,
        "incident_response_avg_minutes": 22,
        "incident_response_target_minutes": 30
    },
    "highlights": [
        "Completed RBAC update for ERP finance module",
        "Resolved recurring CRM sync error with vendor patch",
        "Started testing chatbot-assisted ticketing prototype"
    ],
    "blockers": [
        "Pending approval for 2 admin access requests (waiting on department head)"
    ]
}


def generate_report(data):
    """Generate a markdown weekly report from structured data."""
    today = datetime.now()
    week_start = today - timedelta(days=today.weekday())
    week_end = week_start + timedelta(days=4)

    report = []
    report.append(f"# Weekly IT Operations Report")
    report.append(f"**Period:** {week_start.strftime('%b %d')} – {week_end.strftime('%b %d, %Y')}")
    report.append(f"**Generated:** {today.strftime('%Y-%m-%d %H:%M')}")
    report.append("")

    # Access Requests
    ar = data["access_requests"]
    report.append("## Access Requests")
    report.append(f"- Total: {ar['total']} | Completed: {ar['completed']} | Pending: {ar['pending']}")
    report.append(f"- Completion rate: {ar['completed'] / ar['total'] * 100:.0f}%")
    report.append("- By system:")
    for system, count in ar["by_system"].items():
        report.append(f"  - {system}: {count}")
    report.append("")

    # Incidents
    inc = data["incidents"]
    report.append("## Incidents")
    report.append(f"- Total: {inc['total']} | Resolved: {inc['resolved']} | Open: {inc['open']} | Escalated: {inc['escalated']}")
    report.append("- Categories:")
    for cat, count in inc["categories"].items():
        report.append(f"  - {cat}: {count}")
    report.append("")

    # SLA
    sla = data["sla"]
    report.append("## SLA Performance")
    ar_status = "MET" if sla["access_request_avg_hours"] <= sla["access_request_target_hours"] else "MISSED"
    ir_status = "MET" if sla["incident_response_avg_minutes"] <= sla["incident_response_target_minutes"] else "MISSED"
    report.append(f"- Access request avg: {sla['access_request_avg_hours']}h (target: {sla['access_request_target_hours']}h) — **{ar_status}**")
    report.append(f"- Incident response avg: {sla['incident_response_avg_minutes']}min (target: {sla['incident_response_target_minutes']}min) — **{ir_status}**")
    report.append("")

    # Highlights
    report.append("## Highlights")
    for h in data["highlights"]:
        report.append(f"- {h}")
    report.append("")

    # Blockers
    report.append("## Blockers")
    if data["blockers"]:
        for b in data["blockers"]:
            report.append(f"- {b}")
    else:
        report.append("- None")

    return "\n".join(report)


def main():
    report = generate_report(SAMPLE_WEEK_DATA)
    filename = f"weekly_report_{datetime.now().strftime('%Y-%m-%d')}.md"
    with open(filename, "w") as f:
        f.write(report)
    print(f"Report saved to {filename}")
    print()
    print(report)


if __name__ == "__main__":
    main()
