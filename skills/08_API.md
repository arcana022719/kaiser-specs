# 08 — API

**Purpose:** API response envelope, route inventory, auth rules, and sync payload contracts.

**Confidence note:** Initial pre-code placeholder on 2026-11-23; `kaiser-api` has no source files yet. The code wins (see 16).

## Contracts Inherited from Baseline

- **Backend role:** `kaiser-api` mediates between Supabase Postgres and `kaiser-web` / `kaiser-android`.
- **Payload hygiene:** strip `id` from all push/pull sync payloads; exclude `created_by` and action actor columns (`rated_by`, `approved_by`, etc.) from push allowlists.
- **Route inventory:** *(To be documented when endpoints are implemented.)*
