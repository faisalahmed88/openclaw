# OpenClaw Repository Research Report

## 1. Source Structure (`src/`)

50 top-level directories under `src/`, with 1,875 non-test TS source files totaling 325,346 LOC.

| Directory | Purpose |
|---|---|
| `src/agents/` | AI agent loop, tool definitions, sandbox, model scanning, embedded runner |
| `src/gateway/` | Gateway server, WS connections, OpenAI-compatible HTTP API, protocol, control UI |
| `src/cli/` | CLI wiring (Commander + clack/prompts) |
| `src/commands/` | Individual CLI commands (auth, config, models, etc.) |
| `src/config/` | Config loading/writing, Zod schemas for all providers and core settings |
| `src/infra/` | Infrastructure: heartbeat, outbound sessions, state migrations, update checks, exec approvals |
| `src/channels/` | Shared channel plugin system: registry, allowlists, typing, ack-reactions, onboarding adapters |
| `src/plugin-sdk/` | Plugin SDK surface area (432-line barrel export file + helpers) |
| `src/plugins/` | Plugin runtime, HTTP registry, config schema management |
| `src/routing/` | Message routing, session key resolution |
| `src/providers/` | LLM provider integrations |
| `src/telegram/` | Built-in Telegram channel implementation |
| `src/discord/` | Built-in Discord channel implementation |
| `src/slack/` | Built-in Slack channel implementation |
| `src/signal/` | Built-in Signal channel implementation |
| `src/imessage/` | Built-in iMessage channel implementation |
| `src/web/` | Built-in WhatsApp web channel implementation |
| `src/whatsapp/` | WhatsApp integration |
| `src/line/` | Built-in LINE channel implementation |
| `src/auto-reply/` | Reply chunking, streaming coalesce, queue, tokens |
| `src/tui/` | Terminal UI (rich interactive TUI) |
| `src/browser/` | Browser tool (Playwright-based) |
| `src/media/` | Media pipeline: MIME detection, storage |
| `src/media-understanding/` | Media understanding (PDF, images) |
| `src/memory/` | Memory/QMD manager, sync ops, batch processing |
| `src/sessions/` | Session management |
| `src/security/` | Audit, formal verification |
| `src/markdown/` | Markdown IR/rendering |
| `src/tts/` | Text-to-speech |
| `src/cron/` | Cron job scheduling |
| `src/hooks/` | Lifecycle hooks |
| `src/terminal/` | Terminal utilities: tables, themes/palette, ANSI, links |
| `src/acp/` | Agent Client Protocol SDK integration |
| `src/canvas-host/` | Canvas/A2UI hosting |
| `src/wizard/` | Setup wizard |
| `src/process/` | Process exec, tau-rpc bridges |
| `src/pairing/` | Device pairing |
| `src/node-host/` | Node host invoke layer |
| `src/logging/` | Logging transports |
| `src/link-understanding/` | URL/link content extraction |
| `src/macos/` | macOS-specific integration |
| `src/daemon/` | Daemon/background process management |
| `src/compat/` | Legacy compatibility |
| `src/auth/` | Authentication and authorization |
| `src/models/` | Model management and selection |
| `src/sandbox/` | Sandbox execution environment |
| `src/storage/` | Storage abstraction layer |
| `src/utils/` | Shared utility functions |
| `src/types/` | Common TypeScript type definitions |
| `src/errors/` | Error handling and custom error types |

## 2. Extensions

36 extensions under `extensions/`. Completeness audit:

| Extension | Tests | README | Notes |
|---|---|---|---|
| bluebubbles | 8 | Y | Well-covered |
| copilot-proxy | 0 | Y | No tests |
| device-pair | 0 | N | No tests, no README |
| ... | ... | ... | ... |

Summary: 105 extension test files total. 13/36 extensions have a README. 14/36 extensions have zero tests, including major channels like discord, signal, slack, telegram, imessage.

## 3. Test Coverage

- Coverage provider: V8 via Vitest
- Thresholds: lines 70%, functions 70%, branches 55%, statements 70%
- Test file counts: 1,121 in `src/`, 105 in `extensions/` → 1,226 total
- Coverage scope: Only `src/**/*.ts` counted (not extensions). Massive exclusion list in vitest.config.ts: CLI, commands, all channels, all agents, all gateway, TUI, wizard, browser, many infra modules
- Only files actually imported by tests are counted — files with zero test imports are invisible to coverage

Key concern: The 70% threshold is cosmetically healthy but the exclusion list is so extensive that most of the codebase's complex code (agents, gateway, channels, CLI) is not measured. Effective coverage of the full `src/` codebase is likely well below 70%.

## 4. Code Quality — Large Files

130 files exceed 500 LOC (the project guideline). Top 20 offenders:

| LOC | File |
|---|---|
| 1,156 | src/memory/qmd-manager.ts |
| 1,142 | src/agents/pi-embedded-runner/run/attempt.ts |
| ... | ... |

## 5. Documentation

326 English docs (excluding zh-CN/ja-JP translations). The Mintlify nav config in docs/docs.json is 1,859 lines and covers:
- 10 top-level tabs (English): Get Started, Install, Channels, Agents, Tools, Models, Platforms, Gateway & Ops, Reference, Help
- i18n: Full zh-CN (Chinese) mirror of all tabs; minimal ja-JP (Japanese, 2 pages only)
- ~100 redirects from old paths
- No empty docs found (all .md files have content > 100 bytes)

Notable: Some newer extensions (e.g., tlon, nostr, nextcloud-talk, bluebubbles) don't yet appear in the channels nav. Only voice-call and zalouser appear in the "Extensions" group under Tools.

## 6. CI/CD and Issue Patterns

- 9 GitHub Actions workflows: main CI, Docker, install smoke, sandbox, formal conformance, labeler, stale, auto-response, workflow sanity
- CI is scope-aware, cross-platform, dual runtime (Node/Bun), artifact sharing, secret scanning, test reporting
- 3 issue templates, PR template, labeler config covers all channels/extensions

## 7. Plugin SDK

The plugin SDK at src/plugin-sdk/index.ts is 432 lines, almost entirely re-exports. It exposes everything an extension channel needs to integrate fully (auth, messaging, outbound, config, onboarding, status, heartbeat, etc.), but has no dedicated SDK documentation or getting-started guide beyond individual extension READMEs.

## 8. CHANGELOG — Recent Velocity

CHANGELOG.md is 2,060 lines. Latest releases show:
- 2026.2.15 (Unreleased): ~10 fixes (TUI, auto-reply, gateway security, session redaction, agent timeout, OpenAI store, CLI compat)
- 2026.2.14: 6 changes + 35+ fixes (TUI, agents, cron, gateway, channels, CLI, media)
- Velocity: Very high — daily releases, heavy community contribution, focus on TUI, agent robustness, channel edge cases

## 9. Dependencies

- 46 key runtime dependencies (AI/agent, messaging SDKs, cloud, AI protocol, web, media, schema, CLI, other)
- Dev dependencies: build, test, TypeScript, lint/format, UI
- Notable: Dual schema (zod + typebox), pnpm overrides, peer deps, pinned pre-release/alpha versions

## 10. GitHub Actions CI Summary

- ci.yml is 690 lines, very mature: docs-scope, changed-scope, check, check-docs, build-artifacts, release-check, checks (matrix), secrets, checks-windows, macos, ios (disabled), android
- CI sophistication: High. Scope-aware, cross-platform, dual runtime, artifact sharing, retry logic, secret scanning. iOS CI is currently disabled.

---

## Summary of Key Findings for Improvement Suggestions

1. 130 files exceed the 500-LOC guideline — top offenders are 1,100+ lines in agents, memory, config, and telegram
2. 14/36 extensions have zero tests — including major channels (discord, signal, slack, telegram, imessage)
3. 23/36 extensions lack a README
4. Coverage exclusion list is massive — agents, gateway, all channels, CLI, commands, TUI, wizard are all excluded from coverage measurement
5. Plugin SDK lacks standalone documentation — 432-line barrel with no getting-started guide for extension authors
6. Dual schema libraries (Zod v4 + TypeBox) create cognitive overhead
7. iOS CI is disabled — gap in mobile quality assurance
8. Several alpha/beta/RC pinned dependencies (node-pty, sqlite-vec, rolldown) — stability risk
9. Only 2 extensions appear in the docs navigation "Extensions" group — most extension channels are undocumented in the nav
10. Japanese i18n is minimal (2 pages) vs complete zh-CN mirror — either expand or remove the stub
