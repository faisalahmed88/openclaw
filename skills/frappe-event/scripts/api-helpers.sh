#!/usr/bin/env bash
# Frappe Event API helper — reusable wrapper
# Usage: source this file, then call frappe_api <method> [args...]
set -euo pipefail

FRAPPE_URL="http://localhost:8000"
FRAPPE_TOKEN="token 2921cfa2cef69d8:261f6be23bcaa39"

frappe_get() {
  local endpoint="$1"
  curl -s -H "Authorization: ${FRAPPE_TOKEN}" "${FRAPPE_URL}${endpoint}"
}

frappe_post() {
  local endpoint="$1"
  shift
  curl -s -H "Authorization: ${FRAPPE_TOKEN}" "$@" "${FRAPPE_URL}${endpoint}"
}

frappe_post_json() {
  local endpoint="$1"
  local json_data="$2"
  curl -s -H "Authorization: ${FRAPPE_TOKEN}" -H "Content-Type: application/json" -d "${json_data}" "${FRAPPE_URL}${endpoint}"
}

# Quick shortcuts
list_events()       { frappe_get "/api/method/event.api.admin_event.get_event_masters"; }
list_editions()     { frappe_get "/api/method/event.api.admin_event.get_event_editions"; }
list_categories()   { frappe_get "/api/method/event.api.admin_event.get_registration_categories"; }
list_rules()        { frappe_get "/api/method/event.api.admin_event.get_eligibility_rules"; }
list_addons()       { frappe_get "/api/method/event.api.admin_event.get_add_ons"; }
list_variables()    { frappe_get "/api/method/event.api.admin_event.get_event_variables"; }
dashboard_stats()   { frappe_get "/api/method/event.api.admin_event.get_dashboard_stats"; }

get_edition()       { frappe_post "/api/method/event.api.admin_event.get_event_edition" -d "name=$1"; }
get_stats()         { frappe_post "/api/method/event.api.admin_tools.get_registration_statistics" -d "event_edition=$1"; }
search_reg()        { frappe_post "/api/method/event.api.admin_tools.global_search_registrations" -d "search_term=$1"; }

create_event()      { frappe_post_json "/api/method/event.api.admin_event.create_complete_event" "$1"; }

echo "Frappe Event API helpers loaded. Available commands:"
echo "  list_events, list_editions, list_categories, list_rules, list_addons, list_variables"
echo "  dashboard_stats, get_edition <name>, get_stats <edition>, search_reg <term>"
echo "  create_event '<json>'"
