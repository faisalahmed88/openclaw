# Frappe Event App — Doctype Reference

## 37 Doctypes in the Event Module

### Core Doctypes (standalone)

| Doctype               | Purpose                                                                    |
| --------------------- | -------------------------------------------------------------------------- |
| Event Master          | Top-level event definition (name, code, description)                       |
| Event Edition         | Yearly instance of an event (dates, venue, categories, add-ons)            |
| Registration Category | Category template (e.g., "Adults 18+", "Youth U19") with eligibility rules |
| Eligibility Rule      | Reusable rule with conditions (age checks, TTR limits, membership)         |
| Add On                | Optional purchasable items (t-shirts, meals, parking)                      |
| Event Variable        | Data fields collected from participants (age, TTR, club)                   |
| Activity Type         | Types of activities in the schedule                                        |
| Event Day             | A single day within an edition                                             |
| Schedule Item         | Individual schedule entry (time, location, capacity)                       |
| Event Registration    | A participant's registration record                                        |
| Payment Transaction   | Payment records linked to registrations                                    |
| Payment Settings      | Global payment configuration (Mollie)                                      |
| Event Admin           | Admin user assignments per event                                           |
| Event Log             | Audit log entries                                                          |
| Auth Code             | Verification codes for guest registration                                  |

### Child Doctypes (embedded in parent records)

| Doctype                        | Parent                | Purpose                                                                                     |
| ------------------------------ | --------------------- | ------------------------------------------------------------------------------------------- |
| Edition Category               | Event Edition         | Category pricing & capacity for a specific edition                                          |
| Edition Add On                 | Event Edition         | Add-on pricing for a specific edition                                                       |
| Edition Registration Period    | Event Edition         | Registration period dates                                                                   |
| Edition Variable Value         | Event Edition         | Variable values specific to edition                                                         |
| Category Eligibility Rule Link | Registration Category | Links rules to categories                                                                   |
| Category Allowed Organization  | Registration Category | Organization restrictions                                                                   |
| Category Variable Link         | Registration Category | Variables required from participants (form fields) — **THIS is what renders on the portal** |
| Add On Category Link           | Add On                | Which categories can use this add-on                                                        |
| Add On Eligibility Rule Link   | Add On                | Add-on eligibility restrictions                                                             |
| Add On Option                  | Add On                | Add-on variants/options                                                                     |
| Add On Variable                | Add On                | Variables affecting add-on                                                                  |
| Add On Variable Option         | Add On                | Options for add-on variables                                                                |
| Rule Condition                 | Eligibility Rule      | Individual conditions within a rule                                                         |
| Event Category Item            | Event Master          | Categories linked to master                                                                 |
| Event Add On Item              | Event Master          | Add-ons linked to master                                                                    |
| Event Activity                 | Event Day             | Activities within a day                                                                     |
| Schedule Item Category Link    | Schedule Item         | Categories allowed per schedule item                                                        |
| Registration Schedule Item     | Event Registration    | Schedule selections by registrant                                                           |
| Event Registration Add On      | Event Registration    | Add-ons purchased by registrant                                                             |
| Registration Variable Value    | Event Registration    | Variable values from registrant                                                             |
| Group Registration Member      | Event Registration    | Members within group registration                                                           |
| Refund Tier                    | Event Edition         | Tiered refund policies                                                                      |

## Key Field Structures

### Event Master

```json
{
  "event_name": "string (required)",
  "event_code": "string (required, unique short code)",
  "short_description": "text",
  "is_active": 1,
  "compliance_accepted": 1,
  "compliance_accepted_by": "user email"
}
```

### Event Edition

```json
{
  "event_master": "link to Event Master (required)",
  "edition_name": "string (required)",
  "edition_number": "int",
  "status": "Draft|Open|Closed|Completed|Cancelled",
  "is_published": 0|1,
  "start_date": "YYYY-MM-DD",
  "end_date": "YYYY-MM-DD",
  "registration_start_date": "YYYY-MM-DD",
  "registration_end_date": "YYYY-MM-DD",
  "venue_name": "string",
  "venue_address": "string",
  "city": "string",
  "country": "string",
  "current_registrations": "int (auto)",
  "waiting_list_count": "int (auto)",
  "refund_enabled": 0|1,
  "refund_deadline": "YYYY-MM-DD",
  "refund_fee_percent": "float (default 3.0)",
  "use_tiered_refunds": 0|1,
  "use_master_categories": 0|1,
  "use_master_add_ons": 0|1,
  "enable_schedule_selection": 0|1,
  "schedule_selection_type": "Single|Multiple",
  "max_schedule_selections": "int",
  "registration_approval_required": 0|1,
  "edition_categories": [{"registration_category": "name", "price": 0, "early_bird_price": 0, "last_minute_price": 0, "on_site_price": 0, "capacity": 0, "current_count": 0, "is_available": 1}],
  "edition_add_ons": [{"add_on": "name", "price": 0, "stock": null}],
  "edition_variables": [{"event_variable": "name"}],
  "refund_tiers": [{"days_before": 30, "refund_percent": 80}]
}
```

### Registration Category

```json
{
  "category_name": "string (required)",
  "category_code": "string (required)",
  "description": "text",
  "is_active": 1,
  "display_order": 0,
  "has_capacity_limit": 0|1,
  "default_capacity": 128,
  "eligibility_rules": [{"eligibility_rule": "rule name"}],
  "allowed_organizations": [{"organization": "org name"}],
  "required_variables": [
    {
      "event_variable": "Variable Name (Link to Event Variable)",
      "is_required": 1,
      "display_order": 0,
      "field_label": "Custom Label (optional)",
      "help_text": "Help text (optional)"
    }
  ]
}
```

**NOTE**: `required_variables` is the Category Variable Link child table.
Only variables with `variable_type: "Participant Field"` will render on the portal form.
Use `save_registration_category_full` API to set both `eligibility_rules` and `required_variables`.

### Eligibility Rule

```json
{
  "rule_name": "string (required)",
  "rule_code": "string (required)",
  "description": "text",
  "is_active": 1,
  "use_custom_formula": 0|1,
  "custom_formula": "python expression",
  "has_price_modifier": 0|1,
  "price_modifier_type": "Flat|Percentage",
  "price_modifier_value": 0.0,
  "conditions": [{"variable": "Age", "operator": ">=", "value": "18"}]
}
```

### Add On

```json
{
  "add_on_name": "string (required)",
  "add_on_code": "string (required)",
  "add_on_type": "Product|Service|Accommodation|Insurance",
  "add_on_scope": "Event Based|Category Specific",
  "default_price": 0.0,
  "is_active": 1,
  "description": "text",
  "pricing_type": "Fixed|Per Day|Variable",
  "max_quantity_per_registration": 1,
  "has_stock_limit": 0|1,
  "stock_quantity": 0,
  "eligible_categories": [{"registration_category": "name"}],
  "eligibility_rules": [{"eligibility_rule": "name"}],
  "variables": [{"variable_name": "name", "options": [...]}]
}
```

### Event Variable

```json
{
  "variable_name": "string (required)",
  "variable_code": "string (required)",
  "variable_type": "Participant Field|Edition Setting|Computed",
  "data_type": "Number|Text|Select|Date|Check",
  "is_active": 1,
  "field_label": "string (display label)",
  "description": "text",
  "options": "newline-separated values for Select type"
}
```

### Event Registration

```json
{
  "event_edition": "link (required)",
  "registration_status": "Pending|Confirmed|Cancelled|Waiting List|Pending Refund|Refunded",
  "first_name": "string",
  "last_name": "string",
  "email": "email",
  "date_of_birth": "YYYY-MM-DD",
  "gender": "Male|Female|Other",
  "country": "country code",
  "nationality": "string",
  "organization": "string",
  "registration_categories": [{ "registration_category": "name" }],
  "add_ons": [{ "add_on": "name", "quantity": 1, "price": 0 }],
  "variable_values": [{ "event_variable": "name", "value": "val" }],
  "schedule_items": [{ "schedule_item": "name" }],
  "total_amount": 0.0,
  "amount_paid": 0.0,
  "payment_status": "Unpaid|Paid|Partially Paid|Refunded",
  "payment_method": "string"
}
```
