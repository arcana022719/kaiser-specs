# 10 — Deployment

**Purpose:** Release order across repositories and environment requirements.

**Confidence note:** Initial pre-code placeholder on 2026-11-23. No deployable artifacts exist yet. The code wins (see 16).

## Release Order (from `db-design-choices.md`)

1. Apply additive, idempotent DB migrations to Supabase Postgres (`kaiser-specs/db-schema/`).
2. Deploy `kaiser-api` (must tolerate older clients sending legacy columns or `NULL`s for new columns).
3. Deploy `kaiser-web` and release `kaiser-android` updates.
*Miss →* Clients or API read columns that do not yet exist in Postgres.
