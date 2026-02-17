#!/usr/bin/env bash
# create-event-complete.sh — Full event creation with variable-to-category linking
# Usage: source scripts/api-helpers.sh first, then call functions from this script
#
# This script handles the COMPLETE event creation workflow:
# 1. Create event via create_complete_event API
# 2. Link required_variables to each Registration Category
# 3. Link eligibility_rules to each Registration Category
# 4. Verify everything

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/api-helpers.sh"

# Verify a variable exists by exact name
# Returns 0 if exists, 1 if not
verify_variable_exists() {
    local var_name="$1"
    local encoded=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$var_name'))")
    local result=$(frappe_get "/api/resource/Event%20Variable/$encoded" 2>/dev/null)
    if echo "$result" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('data',{}).get('name',''))" 2>/dev/null | grep -q .; then
        return 0
    fi
    return 1
}

# List all existing variable names
list_all_variables() {
    frappe_get "/api/resource/Event%20Variable?limit_page_length=100&fields=[\"name\",\"variable_type\"]" | \
    python3 -c "
import sys, json
data = json.load(sys.stdin)['data']
for d in sorted(data, key=lambda x: x['name']):
    print(f\"{d['name']} ({d.get('variable_type','?')})\")"
}

# Link required_variables and eligibility_rules to a category
# Args: category_name, required_vars_json, eligibility_rules_json
link_category_fields() {
    local cat_name="$1"
    local vars_json="${2:-[]}"
    local rules_json="${3:-[]}"
    
    local payload=$(python3 -c "
import json
data = {
    'name': '$cat_name',
    'required_variables': json.loads('$vars_json'),
    'eligibility_rules': json.loads('$rules_json')
}
print(json.dumps(data))
")
    
    local result=$(frappe_post_json "/api/method/event.api.admin_event.save_registration_category_full" "{\"data\": $(echo "$payload" | python3 -c 'import sys,json; print(json.dumps(sys.stdin.read().strip()))')}")
    echo "$result" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)['message']
    print(f\"  ✓ {d.get('name','?')}: {d.get('message','OK')}\")
except:
    print(f\"  ✗ $cat_name: Failed\")
    sys.exit(1)
"
}

# Verify a category has required_variables
verify_category_variables() {
    local cat_name="$1"
    local encoded=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$cat_name'))")
    
    frappe_get "/api/resource/Registration%20Category/$encoded" | \
    python3 -c "
import sys, json
d = json.load(sys.stdin)['data']
vars = d.get('required_variables', [])
rules = d.get('eligibility_rules', [])
print(f\"  {d['name']}: {len(vars)} variables, {len(rules)} rules\")
for v in vars:
    print(f\"    - {v.get('event_variable','')} (required={v.get('is_required',0)})\")
for r in rules:
    print(f\"    - rule: {r.get('eligibility_rule','')}\")
"
}

echo "Event creation helper loaded. Available functions:"
echo "  verify_variable_exists <name>    — Check if variable exists"
echo "  list_all_variables               — List all variables with types"
echo "  link_category_fields <cat> <vars_json> <rules_json>"
echo "  verify_category_variables <cat>  — Show category's linked fields"
