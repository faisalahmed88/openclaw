#!/usr/bin/env bash
# Quick event creation script
# Usage: ./create-event.sh '<json_payload>'
set -euo pipefail

FRAPPE_URL="http://localhost:8000"
FRAPPE_TOKEN="token 2921cfa2cef69d8:261f6be23bcaa39"

if [ -z "${1:-}" ]; then
  echo "Usage: $0 '<event_data_json>'"
  echo "Example: $0 '{\"event_master\":{\"event_name\":\"Test\",\"event_code\":\"TST\"},\"event_edition\":{\"edition_name\":\"Test 2026\",\"edition_number\":1,\"start_date\":\"2026-06-01\",\"end_date\":\"2026-06-02\",\"venue_name\":\"Berlin\",\"city\":\"Berlin\"}}'"
  exit 1
fi

echo "Creating event..."
result=$(curl -s \
  -H "Authorization: ${FRAPPE_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"event_data\": $1}" \
  "${FRAPPE_URL}/api/method/event.api.admin_event.create_complete_event")

echo "$result" | python3 -m json.tool 2>/dev/null || echo "$result"
