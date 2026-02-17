---
name: frappe-event
description: "Full Frappe Event Management system: create events with editions, categories, eligibility rules, add-ons, variables, schedules; manage registrations, payments, refunds, statistics, bulk operations, and more. Triggers on: event, edition, registration, category, eligibility, add-on, schedule, refund, payment, participant, attendee, ticket."
metadata: { "openclaw": { "emoji": "🎪", "always": true } }
---

# Frappe Event Management — Complete Agent Skill

You are an agent that fully manages a Frappe-based Event Management system via its REST API.
**You MUST execute all API calls yourself using `curl` and return results. NEVER tell the user to run commands.**

## Connection

| Key         | Value                                                  |
| ----------- | ------------------------------------------------------ |
| Base URL    | `http://localhost:8000`                                |
| Auth header | `Authorization: token 2921cfa2cef69d8:261f6be23bcaa39` |
| Portal URL  | `http://localhost:8000/` (for browsing)                |

Every `curl` you run MUST include `-s -H 'Authorization: token 2921cfa2cef69d8:261f6be23bcaa39'`.
URL-encode spaces as `%20` in all URLs.

---

## Quick-Reference: API Endpoint Map

### 1. Event Masters (top-level event definitions)

| Action      | Method | Endpoint                                                                   |
| ----------- | ------ | -------------------------------------------------------------------------- |
| List all    | GET    | `/api/method/event.api.admin_event.get_event_masters`                      |
| Get one     | POST   | `/api/method/event.api.admin_event.get_event_master` with `name=<name>`    |
| Save/Update | POST   | `/api/method/event.api.admin_event.save_event_master` with `data=<json>`   |
| Delete      | POST   | `/api/method/event.api.admin_event.delete_event_master` with `name=<name>` |

### 2. Event Editions (yearly instances of an event)

| Action        | Method | Endpoint                                                                                                                |
| ------------- | ------ | ----------------------------------------------------------------------------------------------------------------------- |
| List all      | GET    | `/api/method/event.api.admin_event.get_event_editions` (optional `?event_master=<name>`)                                |
| Get one       | POST   | `/api/method/event.api.admin_event.get_event_edition` with `name=<name>`                                                |
| Save/Update   | POST   | `/api/method/event.api.admin_event.save_event_edition` with `data=<json>`                                               |
| Delete        | POST   | `/api/method/event.api.admin_event.delete_event_edition` with `name=<name>`                                             |
| Duplicate     | POST   | `/api/method/event.api.admin_event.duplicate_event_edition` with `source_edition`, `new_edition_name`, `new_start_date` |
| Export config | POST   | `/api/method/event.api.admin_event.export_event_config` with `event_edition=<name>`                                     |

### 3. Registration Categories

| Action                 | Method | Endpoint                                                                                |
| ---------------------- | ------ | --------------------------------------------------------------------------------------- |
| List all               | GET    | `/api/method/event.api.admin_event.get_registration_categories`                         |
| Get one                | POST   | `/api/method/event.api.admin_event.get_registration_category` with `name=<name>`        |
| Get full (with rules)  | POST   | `/api/method/event.api.admin_event.get_registration_category_full` with `name=<name>`   |
| Save                   | POST   | `/api/method/event.api.admin_event.save_registration_category` with `data=<json>`       |
| Save full (with rules) | POST   | `/api/method/event.api.admin_event.save_registration_category_full` with `data=<json>`  |
| Bulk save              | POST   | `/api/method/event.api.admin_event.save_categories_bulk` with `categories=<json-array>` |
| Delete                 | POST   | `/api/method/event.api.admin_event.delete_registration_category` with `name=<name>`     |

### 4. Eligibility Rules

| Action                   | Method | Endpoint                                                                                                          |
| ------------------------ | ------ | ----------------------------------------------------------------------------------------------------------------- |
| List all                 | GET    | `/api/method/event.api.admin_event.get_eligibility_rules`                                                         |
| Get one                  | POST   | `/api/method/event.api.admin_event.get_eligibility_rule` with `name=<name>`                                       |
| Save                     | POST   | `/api/method/event.api.admin_event.save_eligibility_rule` with `data=<json>`                                      |
| Delete                   | POST   | `/api/method/event.api.admin_event.delete_eligibility_rule` with `name=<name>`                                    |
| Check eligibility        | POST   | `/api/method/event.api.eligibility.check_category_eligibility` with `edition`, `participant_data=<json>`          |
| Check add-on eligibility | POST   | `/api/method/event.api.eligibility.check_addon_eligibility` with `edition`, `category`, `participant_data=<json>` |

### 5. Add-Ons

| Action   | Method | Endpoint                                                             |
| -------- | ------ | -------------------------------------------------------------------- |
| List all | GET    | `/api/method/event.api.admin_event.get_add_ons`                      |
| Get one  | POST   | `/api/method/event.api.admin_event.get_add_on` with `name=<name>`    |
| Save     | POST   | `/api/method/event.api.admin_event.save_add_on` with `data=<json>`   |
| Delete   | POST   | `/api/method/event.api.admin_event.delete_add_on` with `name=<name>` |

### 6. Event Variables

| Action    | Method | Endpoint                                                                        |
| --------- | ------ | ------------------------------------------------------------------------------- |
| List all  | GET    | `/api/method/event.api.admin_event.get_event_variables`                         |
| Get one   | POST   | `/api/method/event.api.admin_event.get_event_variable` with `name=<name>`       |
| Get full  | POST   | `/api/method/event.api.admin_event.get_event_variable_full` with `name=<name>`  |
| Save      | POST   | `/api/method/event.api.admin_event.save_event_variable` with `data=<json>`      |
| Save full | POST   | `/api/method/event.api.admin_event.save_event_variable_full` with `data=<json>` |
| Delete    | POST   | `/api/method/event.api.admin_event.delete_event_variable` with `name=<name>`    |

### 7. Activity Types & Event Days

| Action               | Method | Endpoint                                                                       |
| -------------------- | ------ | ------------------------------------------------------------------------------ |
| List activity types  | GET    | `/api/method/event.api.admin_event.get_activity_types`                         |
| Save activity type   | POST   | `/api/method/event.api.admin_event.save_activity_type` with `data=<json>`      |
| Delete activity type | POST   | `/api/method/event.api.admin_event.delete_activity_type` with `name=<name>`    |
| List event days      | POST   | `/api/method/event.api.admin_event.get_event_days` with `event_edition=<name>` |
| Save event day       | POST   | `/api/method/event.api.admin_event.save_event_day` with `data=<json>`          |
| Delete event day     | POST   | `/api/method/event.api.admin_event.delete_event_day` with `name=<name>`        |

### 8. Create Complete Event (Wizard)

**POST** `/api/method/event.api.admin_event.create_complete_event`

Body: `event_data=<json>` — a single JSON object containing:

```json
{
  "event_master": {
    "event_name": "My Event",
    "event_code": "MYEV",
    "short_description": "Description",
    "is_active": 1
  },
  "event_edition": {
    "edition_name": "My Event 2026",
    "edition_number": 1,
    "start_date": "2026-06-01",
    "end_date": "2026-06-02",
    "venue_name": "Venue Name",
    "city": "City",
    "country": "Country",
    "registration_start_date": "2026-03-01",
    "registration_end_date": "2026-05-30"
  },
  "existing_categories": ["Category Name 1"],
  "new_categories": [
    {
      "category_name": "New Cat",
      "category_code": "NC",
      "default_capacity": 100,
      "description": "Desc"
    }
  ],
  "category_pricing": [
    {
      "registration_category": "Category Name 1",
      "price": 50,
      "capacity": 200,
      "is_available": 1,
      "early_bird_price": 40
    }
  ],
  "category_rules": {
    "Category Name 1": ["Minimum Age 18", "Is Not Service Member"]
  },
  "selected_variables": ["Age", "TTR Rating"],
  "selected_addons": [
    { "name": "Lunch Package", "price": 8 },
    { "name": "Parking Pass", "price": 10 }
  ],
  "variables": [],
  "activity_types": [],
  "event_days": [
    { "day_name": "Day 1", "day_date": "2026-06-01", "activities": [] },
    { "day_name": "Day 2", "day_date": "2026-06-02", "activities": [] }
  ],
  "schedule_settings": {
    "enable_schedule_selection": false
  },
  "schedule_items": [],
  "settings": {
    "status": "Draft",
    "is_published": 0,
    "refund_enabled": false,
    "refund_fee_percent": 2.9
  }
}
```

### 9. Registrations & Admin Tools

| Action                      | Method | Endpoint                                                                                                             |
| --------------------------- | ------ | -------------------------------------------------------------------------------------------------------------------- |
| Statistics                  | POST   | `/api/method/event.api.admin_tools.get_registration_statistics` with `event_edition=<name>`                          |
| Export registrations        | POST   | `/api/method/event.api.admin_tools.export_registrations` with `event_edition=<name>`                                 |
| Export options              | POST   | `/api/method/event.api.admin_tools.get_export_options` with `event_edition=<name>`                                   |
| Search registrations        | POST   | `/api/method/event.api.admin_tools.global_search_registrations` with `search_term=<q>`                               |
| Update registration         | POST   | `/api/method/event.api.admin_tools.admin_update_registration` with `registration_name=<name>`, `updates=<json>`      |
| Cancel registration         | POST   | `/api/method/event.api.admin_tools.admin_cancel_registration` with `registration_name=<name>`, `reason=<text>`       |
| Add note                    | POST   | `/api/method/event.api.admin_tools.admin_add_note` with `registration_name=<name>`, `note=<text>`                    |
| Bulk update status          | POST   | `/api/method/event.api.admin_tools.bulk_update_status` with `registration_names=<json-array>`, `new_status=<status>` |
| Bulk send email             | POST   | `/api/method/event.api.admin_tools.bulk_send_email` with `registration_names=<json-array>`, `subject`, `message`     |
| Create on-site registration | POST   | `/api/method/event.api.admin_tools.create_onsite_registration` with `registration_data=<json>`                       |

### 10. Payments & Refunds

| Action                    | Method | Endpoint                                                                                                                     |
| ------------------------- | ------ | ---------------------------------------------------------------------------------------------------------------------------- |
| Get refund info           | POST   | `/api/method/event.api.refund.get_refund_info` with `registration_name=<name>`                                               |
| Process refund            | POST   | `/api/method/event.api.refund.process_refund` with `registration_name=<name>`, `refund_amount=<num>`, `reason=<text>`        |
| Cancel + refund           | POST   | `/api/method/event.api.refund.cancel_registration` with `registration_name=<name>`, `reason=<text>`, `process_refund_flag=1` |
| Refund history            | POST   | `/api/method/event.api.refund.get_refund_history` with `event_edition=<name>`                                                |
| Available payment methods | GET    | `/api/method/event.api.mollie_payment.get_available_payment_methods`                                                         |
| Cancellation policy       | GET    | `/api/method/event.api.admin_tools.get_cancellation_policy` (optional `?event_edition=<name>`)                               |

### 11. Schedule & Bulk Import

| Action           | Method | Endpoint                                                                                               |
| ---------------- | ------ | ------------------------------------------------------------------------------------------------------ |
| Import template  | POST   | `/api/method/event.api.bulk_import.get_import_template` with `import_type=<type>`                      |
| Preview import   | POST   | `/api/method/event.api.bulk_import.preview_import` with `event_edition`, `import_data`, `import_type`  |
| Import schedule  | POST   | `/api/method/event.api.bulk_import.import_schedule` with `event_edition`, `import_data`, `import_type` |
| Export schedule  | POST   | `/api/method/event.api.bulk_import.export_schedule` with `event_edition`, `format=json`                |
| Get edition days | POST   | `/api/method/event.api.bulk_import.get_edition_days` with `event_edition=<name>`                       |

### 12. Dashboard & Permissions

| Action                 | Method | Endpoint                                                                                            |
| ---------------------- | ------ | --------------------------------------------------------------------------------------------------- |
| Dashboard stats        | GET    | `/api/method/event.api.admin_event.get_dashboard_stats`                                             |
| User allowed events    | GET    | `/api/method/event.api.event_permissions.get_user_allowed_events`                                   |
| Check event access     | POST   | `/api/method/event.api.event_permissions.check_event_access` with `event_master=<name>`             |
| Filtered events        | GET    | `/api/method/event.api.event_permissions.get_filtered_events`                                       |
| Filtered editions      | GET    | `/api/method/event.api.event_permissions.get_filtered_editions`                                     |
| Filtered registrations | POST   | `/api/method/event.api.event_permissions.get_filtered_registrations` with `event_master`, `edition` |

### 13. Duplicate & Export

| Action              | Method | Endpoint                                                                                                                |
| ------------------- | ------ | ----------------------------------------------------------------------------------------------------------------------- |
| Duplicate edition   | POST   | `/api/method/event.api.admin_event.duplicate_event_edition` with `source_edition`, `new_edition_name`, `new_start_date` |
| Export event config | POST   | `/api/method/event.api.admin_event.export_event_config` with `event_edition=<name>`                                     |

### 14. Public / Portal Registration APIs

| Action                  | Method | Endpoint                                                                               |
| ----------------------- | ------ | -------------------------------------------------------------------------------------- |
| List published editions | GET    | `/api/method/event.api.registration.get_editions` (optional `?status=Open`)            |
| Edition details         | POST   | `/api/method/event.api.registration.get_edition_details` with `edition_name=<name>`    |
| Edition categories      | POST   | `/api/method/event.api.registration.get_edition_categories` with `edition_name=<name>` |
| Edition add-ons         | POST   | `/api/method/event.api.registration.get_edition_addons` with `edition_name=<name>`     |
| Submit registration     | POST   | `/api/method/event.api.registration.submit_registration` with `data=<json>`            |

### 15. Notifications

| Action            | Method | Endpoint                                                                                             |
| ----------------- | ------ | ---------------------------------------------------------------------------------------------------- |
| Send confirmation | POST   | `/api/method/event.api.notifications.send_registration_confirmation` with `registration_name=<name>` |

---

## How to Execute Calls

Always use `curl -s` with proper POST data. Example patterns:

**GET call:**

```bash
curl -s -H 'Authorization: token 2921cfa2cef69d8:261f6be23bcaa39' 'http://localhost:8000/api/method/event.api.admin_event.get_event_masters'
```

**POST call with form data:**

```bash
curl -s -H 'Authorization: token 2921cfa2cef69d8:261f6be23bcaa39' -d 'name=2TM 2022' 'http://localhost:8000/api/method/event.api.admin_event.get_event_edition'
```

**POST call with JSON body (for create/update):**

```bash
curl -s -H 'Authorization: token 2921cfa2cef69d8:261f6be23bcaa39' -H 'Content-Type: application/json' -d '{"event_data": {...}}' 'http://localhost:8000/api/method/event.api.admin_event.create_complete_event'
```

---

## ⚠️ CRITICAL: How Variables Appear on the Registration Portal

The portal registration form ONLY shows variables that are linked to **Registration Categories** via `required_variables`, NOT from `edition_variables`.

### Variable Linking Architecture

```
Event Variable (defines the field: name, type, options)
    ↓ linked via
Registration Category → required_variables[] (Category Variable Link)
    ↓ at runtime
Portal form reads categories → collects required_variables → renders form fields
```

- `edition_variables` = edition-level config/system variables (NOT form fields)
- `Registration Category.required_variables` = the actual form fields participants fill in

### MANDATORY Workflow: Adding Form Fields to Registration

1. **Ensure variables exist** — call `get_event_variables` and verify each needed variable exists
   - If missing, create with `save_event_variable` — set `variable_type: "Participant Field"` for form fields
2. **Link variables to EACH category** — call `save_registration_category_full` for every category:
   ```json
   {
     "data": "{\"name\": \"U11\", \"required_variables\": [{\"event_variable\": \"Age\", \"is_required\": 1, \"display_order\": 1}, {\"event_variable\": \"TTR Value\", \"is_required\": 1, \"display_order\": 2}]}"
   }
   ```
3. **Also link eligibility rules to categories** if needed (same API, `eligibility_rules` field)
4. **Verify** — call `get_registration_category_full` for at least one category and confirm `required_variables` has entries

### Category Variable Link Fields

| Field          | Type                  | Description                                    |
| -------------- | --------------------- | ---------------------------------------------- |
| event_variable | Link → Event Variable | The variable to collect (required)             |
| is_required    | Check                 | Whether participant must fill this (default 1) |
| display_order  | Int                   | Render order on form                           |
| field_label    | Data                  | Custom label override (optional)               |
| help_text      | Small Text            | Help text shown below field (optional)         |

### Variable Types

| variable_type     | Purpose                                               | Shows on Form? |
| ----------------- | ----------------------------------------------------- | -------------- |
| Participant Field | Data entered by participant                           | ✅ YES         |
| Edition Setting   | System config (e.g., max_categories_per_registration) | ❌ NO          |
| Computed          | Calculated at runtime                                 | ❌ NO          |

Only `Participant Field` variables appear on the registration portal form.

---

## ⚠️ MANDATORY POST-CREATION VERIFICATION

After creating or modifying an event, you MUST verify the result using the correct APIs.
**`get_event_edition` does NOT return category-level rules or variables** — it only returns pricing/capacity per category.
You MUST use `get_registration_category_full` to verify rules and variables were applied.

### Verification Checklist (run after every event create/modify)

1. **For EACH category** that should have rules or variables, call:
   ```bash
   curl -s -H 'Authorization: token 2921cfa2cef69d8:261f6be23bcaa39' \
     -d 'name=<CategoryName>' \
     'http://localhost:8000/api/method/event.api.admin_event.get_registration_category_full'
   ```
2. **Check the response** for:
   - `required_variables` — array of `{event_variable, is_required, display_order}` entries
   - `eligibility_rules` — array of `{eligibility_rule}` entries
   - `required_variable_names` — flat list of variable names (quick check)
   - `eligibility_rule_names` — flat list of rule names (quick check)
3. **If `required_variables` is empty** but you set them → the save failed. Call `save_registration_category_full` again.
4. **If `eligibility_rules` is empty** but you linked rules → the save failed or `category_rules` in `create_complete_event` was ignored. Call `save_registration_category_full` with the rules.

### What Each API Returns (know the difference)

| API                              | Returns                                                                                                                              | Does NOT Return                    |
| -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------- |
| `get_event_edition`              | Edition metadata, `edition_categories` (pricing, capacity, availability per category)                                                | Category rules, required variables |
| `get_registration_category`      | Basic category fields (name, code, description, capacity)                                                                            | Rules, variables                   |
| `get_registration_category_full` | **Everything**: basic fields + `required_variables[]` + `eligibility_rules[]` + `required_variable_names` + `eligibility_rule_names` | —                                  |

**NEVER claim "rules are present" based on `get_event_edition` — it cannot show them. ALWAYS use `get_registration_category_full`.**

---

## Agent Workflow Examples

### "Create an event" (COMPLETE WORKFLOW)

1. Ask for: event name, code, dates, venue, city, categories, pricing, eligibility rules, add-ons, form fields
2. Fetch existing data:
   - `get_registration_categories` — existing categories
   - `get_eligibility_rules` — existing rules
   - `get_add_ons` — existing add-ons
   - `get_event_variables` — existing variables (USE EXACT NAMES from this list)
3. Build `create_complete_event` JSON payload and POST it
4. **AFTER creation — link form fields AND rules to categories:**
   For EACH category, call `save_registration_category_full` with:
   - `required_variables` — variables participants must fill in
   - `eligibility_rules` — rules that gate this category
5. **VERIFY EVERY CATEGORY** — for EACH category, call `get_registration_category_full` and confirm:
   - `required_variables` count matches expected
   - `eligibility_rules` count matches expected
   - Print the variable/rule names for the user to see
6. **If verification fails** — retry `save_registration_category_full` and re-verify

### "List all events"

1. Call `get_event_masters` → format and display

### "Show registration stats for <edition>"

1. Call `get_registration_statistics` with `event_edition=<name>` → format breakdown

### "Search for a registration"

1. Call `global_search_registrations` with `search_term=<name or email>`

### "Cancel a registration"

1. Call `admin_cancel_registration` with `registration_name=<REG-XXXX>` and optional `reason`

### "Duplicate an edition for next year"

1. Call `duplicate_event_edition` with `source_edition`, `new_edition_name`, and `new_start_date`

### "Create event from PDF rules"

1. Read the PDF content (using nano-pdf or file read)
2. Parse event name, dates, categories, eligibility rules, pricing, add-ons
3. Map parsed rules to existing `Eligibility Rule` names, or create new ones via `save_eligibility_rule`
4. Build the complete event JSON and call `create_complete_event`
5. **Link variables AND rules to each category** via `save_registration_category_full`
6. **Verify EVERY category** via `get_registration_category_full` — confirm variables and rules counts
7. Print verification summary for user

### "Show dashboard overview"

1. Call `get_dashboard_stats` → format total events, editions, registrations, revenue

### "Add a form field to a category"

1. Verify variable exists via `get_event_variables`
2. Call `save_registration_category_full` with `required_variables` including the new field
3. Verify with `get_registration_category_full` — confirm the variable appears in the response

### "Verify an event's categories"

1. Call `get_event_edition` to list `edition_categories` (names only)
2. For EACH category name, call `get_registration_category_full`
3. Report: category name → #variables, variable names → #rules, rule names

---

## Existing System Data (for reference when creating events)

### Eligibility Rules Available

Age 7 to 17, Age up to 6, Is IVV/VSL-EVG Member, Is Not Service Member, Is Service Member,
Minimum Age 16, Minimum Age 18, Senior 40+, TTR above 1001, TTR above 1601,
TTR up to 1000, TTR up to 1200, TTR up to 1300, TTR up to 1400, TTR up to 1500, TTR up to 1800,
TTR 1201 to 1600, TTR 1201 to 1800, Under 19

### Add-Ons Available

2TM Event T-Shirt (€25), Accommodation (Barracks) (€15), Additional Class Entry (€10),
IML Solidarity Medal (€20), Lunch Package (€8), Meal Package (€40),
Nachmeldung (Late Registration) (€5), Parking Pass (€10), Refund Protection (€5),
Shuttle Bus Service (€5), Tournament Ball Set (€12)

### Event Variables Available (PARTICIPANT FIELD — form inputs)

Age (Number), Birth Year (Number), Club / Association (Text), Guardian Consent (Boolean),
IML Passport Number (Text), IVV Member (Boolean), Marching Distance Preference (Select),
Military Rank (Text), Previous Participations (Number), Service Member (Boolean),
T-Shirt Size (Select), TTR Value (Number), Tournament License Number (Text)

### Event Variables Available (EDITION SETTING — system config, NOT shown on form)

Early Bird Discount (Number), Group Minimum for Pennant (Number),
Late Registration Surcharge (Number), Max Group Size (Number), Nachmeldung Deadline (Date)

**IMPORTANT**: When linking variables, ALWAYS use the EXACT names from this list.
Call `get_event_variables` first to get the current list. Do NOT invent variable names.

### Additional Reference Documents (in `references/`)

- `architecture.md` — Entity relationships, registration flow, payment flow, admin architecture
- `api-reference-full.md` — All 91 whitelisted endpoints with full parameter documentation
- `doctypes-full.md` — All 38 DocType schemas with field definitions
- `payment-integration.md` — Mollie payment integration flow
- `doctypes.md` — Quick-reference doctype fields
- `workflows.md` — Complete event creation workflow phases

### Existing Events

- Swiss Two-Day March (2TM) — 5 editions
- TTC Neureut Osterturnier (OT-NEUREUT) — 13 editions
- EdTest Event (EDT) — 2 editions
- OpenClaw Age & TTR Open 2026 (OC-TTR-2026) — 1 edition
