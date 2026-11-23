# 04 — Change Rules

**Purpose:** Lockstep sets, hidden dependencies, and retest rules when modifying shared contracts.

**Confidence note:** Verified against `db-design-choices.md` on 2026-11-23; runtime code not yet written. The code wins (see 16).

## Lockstep Sets

### 1. Synced Table Schema (Postgres ↔ SQLite ↔ API)
1. `kaiser-specs/db-schema/v1.x.x.sql` (Postgres DDL)
2. `kaiser-android/` SQLite schema & migrations
3. `kaiser-api/` sync allowlists and DTOs
*Miss →* Sync silently drops columns, fails on missing fields, or overwrites backfilled server data with `NULL`.

### 2. Business Logic & Specs
1. `kaiser-specs/business-logic-v1.x.md`
2. `kaiser-specs/db-schema/`
3. `kaiser-specs/skills/07_DATABASE.md` and `08_API.md`
*Miss →* Schema and API drift from agreed MVP requirements.

## Safe Evolution Rules

- **Additive first:** add columns/tables and backfill before deploying code that reads them; drop legacy columns only after all clients upgrade.
- **Never edit applied migrations:** always create a new forward migration (`v1.0.x`).
