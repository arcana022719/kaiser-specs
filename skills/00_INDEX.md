# 00 — Index

**Purpose:** Reading order by task, inventory of all skills documents, contribution guide, and changelog.

**Confidence note:** Verified against initial repository setup (pre-code) on 2026-11-23. The code wins (see 16).

## Reading Order by Task

- **New to the project:** `01_ARCHITECTURE.md` → `02_PROJECT_STRUCTURE.md` → `16_ENGINEERING_PRINCIPLES.md`
- **Database / sync work:** `07_DATABASE.md` → `../db-design-choices.md` → `04_CHANGE_RULES.md`
- **API / client work:** `08_API.md` → `09_SECURITY.md` → `04_CHANGE_RULES.md`
- **Debugging / incidents:** `05_DEBUGGING_PLAYBOOK.md` → `06_FAILURE_STORIES.md`
- **Shipping / testing:** `11_TESTING.md` → `10_DEPLOYMENT.md` → `14_DEVELOPER_WORKFLOWS.md`

## Document Inventory

| File | Topic | Last Verified | Status |
| --- | --- | --- | --- |
| `00_INDEX.md` | Index and changelog | 2026-11-23 | Initial |
| `INBOX.md` | Contributor intake queue | 2026-11-23 | Initial |
| `01_ARCHITECTURE.md` | System model and boundaries | 2026-11-23 | Initial (pre-code) |
| `02_PROJECT_STRUCTURE.md` | Workspace and repo layout | 2026-11-23 | Initial (pre-code) |
| `03_CODE_STYLE.md` | Style and conventions | 2026-11-23 | Initial (pre-code) |
| `04_CHANGE_RULES.md` | Lockstep sets and blast radius | 2026-11-23 | Initial (pre-code) |
| `05_DEBUGGING_PLAYBOOK.md` | Logs and symptom lookup | 2026-11-23 | Initial (pre-code) |
| `06_FAILURE_STORIES.md` | Incident postmortems | 2026-11-23 | Initial (pre-code) |
| `07_DATABASE.md` | Offline-first Postgres/SQLite rules | 2026-11-23 | Initial (from `db-design-choices.md`) |
| `08_API.md` | API contracts and auth | 2026-11-23 | Initial (pre-code) |
| `09_SECURITY.md` | Privacy, auth, and secrets | 2026-11-23 | Initial (pre-code) |
| `10_DEPLOYMENT.md` | Release order and targets | 2026-11-23 | Initial (pre-code) |
| `11_TESTING.md` | Test strategy and drills | 2026-11-23 | Initial (pre-code) |
| `12_PERFORMANCE.md` | Limits and hot paths | 2026-11-23 | Initial (pre-code) |
| `13_DEPENDENCIES.md` | Dependency policy | 2026-11-23 | Initial (pre-code) |
| `14_DEVELOPER_WORKFLOWS.md` | Setup and recipes | 2026-11-23 | Initial (pre-code) |
| `15_KNOWN_LIMITATIONS.md` | Gaps and deferred work | 2026-11-23 | Initial (pre-code) |
| `16_ENGINEERING_PRINCIPLES.md` | Core engineering rules | 2026-11-23 | Initial (pre-code) |

## How to Contribute

Add rough notes to `INBOX.md` using its template, or edit a target document directly with evidence.

## Changelog

- **2026-11-23:** Initial skills set generated from `handoff.md`, `AGENTS.md`, `business-logic-v1.0.md`, and `db-design-choices.md` before application code exists.
