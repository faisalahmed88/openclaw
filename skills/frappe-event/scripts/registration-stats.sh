#!/usr/bin/env bash
# Registration statistics viewer
# Usage: ./registration-stats.sh <event_edition>
set -euo pipefail

FRAPPE_URL="http://localhost:8000"
FRAPPE_TOKEN="token 2921cfa2cef69d8:261f6be23bcaa39"

edition="${1:-}"
if [ -z "$edition" ]; then
  echo "Usage: $0 <event_edition_name>"
  echo "Example: $0 '2TM 2026'"
  exit 1
fi

echo "=== Registration Statistics for: $edition ==="
curl -s \
  -H "Authorization: ${FRAPPE_TOKEN}" \
  -d "event_edition=$edition" \
  "${FRAPPE_URL}/api/method/event.api.admin_tools.get_registration_statistics" | python3 -m json.tool

echo ""
echo "=== Edition Details ==="
curl -s \
  -H "Authorization: ${FRAPPE_TOKEN}" \
  -d "name=$edition" \
  "${FRAPPE_URL}/api/method/event.api.admin_event.get_event_edition" | python3 -c "
import sys, json
data = json.load(sys.stdin).get('message', {})
print(f\"Edition: {data.get('edition_name')}\")
print(f\"Event: {data.get('event_master')}\")
print(f\"Status: {data.get('status')}\")
print(f\"Dates: {data.get('start_date')} to {data.get('end_date')}\")
print(f\"Venue: {data.get('venue_name')}, {data.get('city')}\")
print(f\"Published: {'Yes' if data.get('is_published') else 'No'}\")
print(f\"Current Registrations: {data.get('current_registrations', 0)}\")
print(f\"Waiting List: {data.get('waiting_list_count', 0)}\")
cats = data.get('edition_categories', [])
if cats:
    print(f\"\\nCategories ({len(cats)}):\")
    for c in cats:
        avail = 'Available' if c.get('is_available') else 'Closed'
        print(f\"  - {c.get('registration_category')}: €{c.get('price',0)} (count: {c.get('current_count',0)}/{c.get('capacity',0)}) [{avail}]\")
addons = data.get('edition_add_ons', [])
if addons:
    print(f\"\\nAdd-ons ({len(addons)}):\")
    for a in addons:
        print(f\"  - {a.get('add_on')}: €{a.get('price',0)}\")
" 2>/dev/null
