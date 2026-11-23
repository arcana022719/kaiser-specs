# 07 — Database

**Purpose:** Identity strategy, constraints, soft deletes, sync invariants, and migration rules.

**Confidence note:** Verified against `kaiser-specs/db-design-choices.md` and `kaiser-specs/db-schema/v1.0.0.sql` on 2026-11-23. The code wins (see 16).

## MVP Tables (`db-schema/v1.0.0.sql`)

- `zone`: 92 Baybay City barangay hex cells + `density_tier` (`urban_campus` / `rural`) and `consensus_threshold`.
- `baseline_node`: offline-synced static reference nodes (`transit_hub`, `bank_atm`, `road_corridor`, `emergency_contact`).
- `raw_signal`: 3-tap reports & 1-tap verifications using 24h rotating `ephemeral_actor_hash` (no `account_uuid`, no raw GPS; hard-deleted on `expires_at`).
- `status_aggregate`: active consensus state (`PENDING`, `CONFIRMED`, `RESOLVED`) per `(zone_uuid, category, status_enum)`.
- `guideline_strike`: server-only silent abuse log & escalating cooldowns.
- `consent_record`: RA 10173 revocable consent (`data_resale_consent` default `false`).
- `system_config`: settings as `(feature, name, value)` rows.

## Identity & Keys

- **Global identity:** `uuid` (`uuid` in Postgres, `TEXT` in SQLite), minted by the creating client.
- **Server surrogate:** `id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY` — never leaves the server; strip from sync payloads.
- **Foreign keys:** `<parent>_uuid` columns without `REFERENCES` on offline-synced server tables (enforced via SQLite FKs + pull orphan guard + natural-key adoption).

## Soft Delete & Sync Invariants

- **Soft delete:** set `archived_at` and bump `updated_at`; gate normal reads on `archived_at IS NULL`; use partial unique indexes (`WHERE archived_at IS NULL`).
- **Dirty check:** `synchronized_at IS NULL OR synchronized_at <> updated_at`.
- **Two unbreakable rules:** every local mutation bumps `updated_at`; only sync writes `synchronized_at`.
- **LWW tie-breaker:** on push, strictly newer `updated_at` wins, except deletes (`archived_at IS NOT NULL`) win same-second ties.

## Migration Versioning

- Forward migrations (agent/dev alters): `v1.0.0` → `v1.0.1` → `v1.0.2`.
- Full Supabase SQL snapshots: `v1.0.0` → `v1.1.0` → `v1.2.0`.
