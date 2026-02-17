#!/usr/bin/env bash
# Dashboard overview script
set -euo pipefail

FRAPPE_URL="http://localhost:8000"
FRAPPE_TOKEN="token 2921cfa2cef69d8:261f6be23bcaa39"

echo "=== Event Management Dashboard ==="
echo ""

curl -s -H "Authorization: ${FRAPPE_TOKEN}" "${FRAPPE_URL}/api/method/event.api.admin_event.get_dashboard_stats" | python3 -c "
import sys, json
d = json.load(sys.stdin).get('message', {})
print(f'Event Masters:        {d.get(\"event_masters\", 0)}')
print(f'Active Events:        {d.get(\"active_events\", 0)}')
print(f'Event Editions:       {d.get(\"event_editions\", 0)}')
print(f'Open Editions:        {d.get(\"open_editions\", 0)}')
print(f'Total Registrations:  {d.get(\"registrations\", 0)}')
print(f'Confirmed:            {d.get(\"confirmed_registrations\", 0)}')
print(f'Categories:           {d.get(\"categories\", 0)}')
print(f'Variables:            {d.get(\"variables\", 0)}')
print(f'Eligibility Rules:    {d.get(\"eligibility_rules\", 0)}')
print(f'Add-ons:              {d.get(\"addons\", 0)}')
recent = d.get('recent_registrations', [])
if recent:
    print(f'\nRecent Registrations:')
    for r in recent:
        print(f'  {r.get(\"name\")} — {r.get(\"first_name\")} {r.get(\"last_name\")} ({r.get(\"event_edition\")}) [{r.get(\"registration_status\")}]')
" 2>/dev/null

echo ""
echo "=== Events ==="
curl -s -H "Authorization: ${FRAPPE_TOKEN}" "${FRAPPE_URL}/api/method/event.api.admin_event.get_event_masters" | python3 -c "
import sys, json
events = json.load(sys.stdin).get('message', [])
for e in events:
    status = 'Active' if e.get('is_active') else 'Inactive'
    print(f'  [{e.get(\"event_code\")}] {e.get(\"event_name\")} — {e.get(\"edition_count\",0)} editions [{status}]')
" 2>/dev/null
