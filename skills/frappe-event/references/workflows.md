# Event Creation — Complete Workflow Reference

This document describes the **exact order of operations** for creating a complete
event with all configuration. The agent MUST follow this workflow to ensure all
fields render correctly on the registration portal.

## Architecture: How Variables Reach the Portal

```
Event Variable (standalone document)
   ├── variable_type: "Participant Field"  → CAN appear on registration form
   └── variable_type: "Edition Setting"    → system config, NOT shown on form

Registration Category (standalone document)
   └── required_variables: [              → links to Event Variable
         { event_variable: "Age",
           is_required: 1,
           display_order: 1 }
       ]

Portal Registration Form
   └── For selected category, reads category.required_variables[]
       → For each: loads Event Variable doc
       → Filters: only variable_type == "Participant Field"
       → Renders form field
```

**KEY INSIGHT**: Variables are NOT shown based on `edition_variables`. They are
shown based on `Registration Category → required_variables[]`. The edition's
`edition_variables` is for system-level config (like max_categories_per_registration).

## Step-by-Step Event Creation

### Phase 1: Gather Requirements

- Event name, code, description
- Dates (start, end, registration open/close)
- Venue (name, city, country)
- Categories (names, codes, pricing, capacity)
- Eligibility rules per category
- Form fields (variables) per category
- Add-ons (name, type, price, options)
- Schedule (days, activities)

### Phase 2: Verify Existing Data

Before creating anything, check what already exists:

```bash
# List existing variables (MUST use exact names)
curl -s -H 'Authorization: token ...' \
  'http://localhost:8000/api/method/event.api.admin_event.get_event_variables'

# List existing categories
curl -s -H 'Authorization: token ...' \
  'http://localhost:8000/api/method/event.api.admin_event.get_registration_categories'

# List existing rules
curl -s -H 'Authorization: token ...' \
  'http://localhost:8000/api/method/event.api.admin_event.get_eligibility_rules'

# List existing add-ons
curl -s -H 'Authorization: token ...' \
  'http://localhost:8000/api/method/event.api.admin_event.get_add_ons'
```

### Phase 3: Create Missing Entities

If any variables, rules, or add-ons don't exist, create them FIRST:

```bash
# Create a new Participant Field variable
curl -s -H 'Authorization: token ...' -H 'Content-Type: application/json' \
  -d '{"data": "{\"variable_name\":\"My Var\",\"variable_code\":\"my_var\",\"variable_type\":\"Participant Field\",\"data_type\":\"Number\",\"is_active\":1}"}' \
  'http://localhost:8000/api/method/event.api.admin_event.save_event_variable'

# Create a new eligibility rule
curl -s -H 'Authorization: token ...' -H 'Content-Type: application/json' \
  -d '{"data": "{\"rule_name\":\"Min Age 16\",\"rule_code\":\"MIN_AGE_16\",\"conditions\":[{\"variable\":\"Age\",\"operator\":\">=\",\"value\":\"16\"}]}"}' \
  'http://localhost:8000/api/method/event.api.admin_event.save_eligibility_rule'
```

### Phase 4: Create the Event (Wizard API)

Use `create_complete_event` to create event master + edition + link categories:

```bash
curl -s -H 'Authorization: token ...' -H 'Content-Type: application/json' \
  -d '{"event_data": { ... }}' \
  'http://localhost:8000/api/method/event.api.admin_event.create_complete_event'
```

The `event_data` JSON includes:

- `event_master` — name, code, description
- `event_edition` — dates, venue, status
- `existing_categories` — names of pre-existing categories to use
- `new_categories` — new categories to create
- `category_pricing` — price/capacity per category for this edition
- `selected_variables` — variables to link to edition (edition-level config)
- `selected_addons` — add-ons for this edition
- `event_days` — schedule days
- `settings` — status, publish, refund settings

### Phase 5: Link Variables to Categories (CRITICAL — often missed!)

**This step is REQUIRED for variables to appear on the registration portal.**

For EACH category, call `save_registration_category_full`:

```bash
curl -s -H 'Authorization: token ...' -H 'Content-Type: application/json' \
  -d '{"data": "{\"name\":\"U11\",\"required_variables\":[{\"event_variable\":\"Age\",\"is_required\":1,\"display_order\":1},{\"event_variable\":\"TTR Value\",\"is_required\":1,\"display_order\":2},{\"event_variable\":\"Guardian Consent\",\"is_required\":1,\"display_order\":3,\"help_text\":\"Required for players under 18\"}],\"eligibility_rules\":[{\"eligibility_rule\":\"Age up to 6\"}]}"}' \
  'http://localhost:8000/api/method/event.api.admin_event.save_registration_category_full'
```

**Category Variable Link fields:**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| event_variable | Link | YES | Exact name of the Event Variable |
| is_required | Check | no | Whether participant must fill (default 1) |
| display_order | Int | no | Render order on form |
| field_label | Data | no | Override label (else uses variable's field_label) |
| help_text | Small Text | no | Help text shown below field |

### Phase 6: Verify

Check at least one category to confirm variables are linked:

```bash
curl -s -H 'Authorization: token ...' \
  -d 'name=U11' \
  'http://localhost:8000/api/method/event.api.admin_event.get_registration_category_full'
```

Confirm the response includes `required_variables` with entries.

## Common Mistakes

1. **Inventing variable names** — ALWAYS call `get_event_variables` first and use EXACT names
2. **Only linking to edition** — `edition_variables` does NOT make fields appear on the portal
3. **Forgetting Phase 5** — The `create_complete_event` wizard does NOT set `required_variables` on categories
4. **Wrong variable_type** — Only `"Participant Field"` type variables render on the form
5. **Using `save_registration_category` instead of `save_registration_category_full`** — The basic `save_registration_category` doesn't handle child tables properly

## Variable Type Guide

| When to use                              | variable_type     | Example                      |
| ---------------------------------------- | ----------------- | ---------------------------- |
| Participant fills in during registration | Participant Field | Age, TTR Value, Club         |
| System config for the edition            | Edition Setting   | Max Group Size, Late Fee     |
| Calculated at runtime                    | Computed          | (rare, usually custom logic) |
