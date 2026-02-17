#!/usr/bin/env bash
# refresh-data.sh — Refresh CLAUDE.md with current live data from the Frappe API
# Called by the agent during heartbeat or manually
# Outputs the "Current Data" section that should replace the one in CLAUDE.md

set -euo pipefail

BASE="http://localhost:8000"
AUTH="Authorization: token 2921cfa2cef69d8:261f6be23bcaa39"

python3 << 'PYEOF'
import requests, json, sys
from datetime import datetime

BASE = "http://localhost:8000"
AUTH = {"Authorization": "token 2921cfa2cef69d8:261f6be23bcaa39"}

def api_get(path):
    r = requests.get(f"{BASE}{path}", headers=AUTH, timeout=10)
    return r.json() if r.status_code == 200 else {}

def api_post(path, data=None):
    r = requests.post(f"{BASE}{path}", headers=AUTH, json=data or {}, timeout=10)
    return r.json() if r.status_code == 200 else {}

# Gather counts
masters = api_get("/api/resource/Event%20Master?limit_page_length=0&fields=[\"name\"]").get("data", [])
editions = api_get("/api/resource/Event%20Edition?limit_page_length=0&fields=[\"name\"]").get("data", [])
categories = api_get("/api/resource/Registration%20Category?limit_page_length=0&fields=[\"name\"]").get("data", [])
rules = api_get("/api/resource/Eligibility%20Rule?limit_page_length=0&fields=[\"name\"]").get("data", [])
variables = api_get("/api/resource/Event%20Variable?limit_page_length=0&fields=[\"name\",\"variable_type\"]").get("data", [])
addons = api_get("/api/resource/Add%20On?limit_page_length=0&fields=[\"name\"]").get("data", [])
regs = api_get("/api/resource/Event%20Registration?limit_page_length=0&fields=[\"name\",\"registration_status\"]").get("data", [])

# Participant vs Edition variables
pf_vars = [v for v in variables if v.get("variable_type") == "Participant Field"]
es_vars = [v for v in variables if v.get("variable_type") == "Edition Setting"]

# Registration stats
confirmed = len([r for r in regs if r.get("registration_status") == "Confirmed"])
pending = len([r for r in regs if r.get("registration_status") == "Pending"])

# Event names
event_names = sorted([m["name"] for m in masters])

# Open editions
open_editions = api_get("/api/resource/Event%20Edition?filters=[[\"status\",\"=\",\"Open for Registration\"]]&fields=[\"name\",\"event_master\",\"current_registrations\"]&limit_page_length=0").get("data", [])

now = datetime.now().strftime("%Y-%m-%d %H:%M")

print(f"""## Current Data (auto-refreshed {now})

- {len(masters)} Event Masters, {len(editions)} Editions, {len(categories)} Categories, {len(rules)} Eligibility Rules
- {len(variables)} Variables ({len(pf_vars)} Participant Field, {len(es_vars)} Edition Setting), {len(addons)} Add-ons
- {len(regs)} Total Registrations ({confirmed} confirmed, {pending} pending)
- Events: {', '.join(event_names)}""")

if open_editions:
    print("\n### Open for Registration")
    for ed in open_editions:
        print(f"- {ed['name']} ({ed.get('current_registrations', 0)} registrations)")

# Variable names for quick reference
print("\n### Participant Field Variables")
pf_names = sorted([v["name"] for v in pf_vars])
print(", ".join(pf_names))

print("\n### Edition Setting Variables")
es_names = sorted([v["name"] for v in es_vars])
print(", ".join(es_names))
PYEOF
