#!/usr/bin/env bash
# Search registrations
# Usage: ./search-registrations.sh <search_term>
set -euo pipefail

FRAPPE_URL="http://localhost:8000"
FRAPPE_TOKEN="token 2921cfa2cef69d8:261f6be23bcaa39"

term="${1:-}"
if [ -z "$term" ]; then
  echo "Usage: $0 <search_term>"
  echo "Search by name, email, or registration ID"
  exit 1
fi

echo "Searching for: $term"
curl -s \
  -H "Authorization: ${FRAPPE_TOKEN}" \
  -d "search_term=$term" \
  "${FRAPPE_URL}/api/method/event.api.admin_tools.global_search_registrations" | python3 -c "
import sys, json
data = json.load(sys.stdin).get('message', {})
results = data.get('results', data) if isinstance(data, dict) else data
if isinstance(results, list):
    if not results:
        print('No registrations found.')
    for r in results:
        if isinstance(r, dict):
            print(f'{r.get(\"name\",\"?\")} — {r.get(\"first_name\",\"\")} {r.get(\"last_name\",\"\")} | {r.get(\"email\",\"\")} | {r.get(\"event_edition\",\"\")} | Status: {r.get(\"registration_status\",\"\")}')
        else:
            print(r)
else:
    print(json.dumps(results, indent=2))
" 2>/dev/null || echo "Error parsing response"
