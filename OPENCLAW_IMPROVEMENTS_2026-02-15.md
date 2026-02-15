# OpenClaw Fork — Improvement Opportunities (2026-02-15)

## HIGH IMPACT / LOW EFFORT (Quick Wins)

### 1. Extension Test Coverage — 14 extensions have zero tests
Major channel extensions (discord, signal, slack, telegram, imessage) have no tests. Add basic unit tests for message parsing, event handling, config validation.

### 2. Extension READMEs — 23/36 extensions lack one
Many extensions have no README. Add minimal READMEs (purpose, config, setup) for each.

### 3. Docs Navigation — Most extension channels missing from Mintlify nav
Only 2 extensions appear in docs "Extensions" group. Add all extension channels to navigation for discoverability.

---

## HIGH IMPACT / MEDIUM EFFORT

### 4. Real Coverage Measurement — Coverage exclusion list is massive
Vitest config excludes agents, gateway, all channels, CLI, commands, TUI, wizard. Gradually remove exclusions and add tests for exposed code, starting with foundational modules.

### 5. Large File Refactoring — 130 files exceed the 500-LOC guideline
Refactor top offenders (memory, agents, config, telegram, etc.) to keep files under 500 LOC as per project guidelines.

### 6. Plugin SDK Documentation
The SDK is mature but lacks a standalone getting-started guide. Create a `docs/plugins/authoring.md` for extension authors.

---

## MEDIUM IMPACT / MEDIUM EFFORT

### 7. Schema Consolidation — Dual Zod + TypeBox usage
Standardize on one schema library (likely Zod) to reduce complexity.

### 8. iOS CI is Disabled
Re-enable iOS CI for build verification if iOS app is maintained.

### 9. Japanese i18n is a Stub
Expand Japanese translation or remove the stub to avoid misleading users.

### 10. Pre-release Dependency Stabilization
Track and update alpha/beta/RC dependencies to stable releases when available.

---

## LOWER EFFORT / CONTRIBUTOR EXPERIENCE

### 11. GitHub Label + Labeler Coverage
Ensure all extensions have matching labels and auto-labeling rules.

### 12. Contributing Guide Enhancement
Expand CONTRIBUTING.md with extension authoring quickstart, good first issues, and architecture diagram.

### 13. Architectural Documentation
Add a high-level architecture diagram to docs for contributor onboarding.

---

## Recommended Starting Order

1. Extension READMEs
2. Docs nav for extensions
3. Tests for untested extensions
4. Plugin SDK docs
5. Coverage exclusion cleanup
6. Large file refactoring

These steps will make your fork more contributor-friendly and better documented than upstream.