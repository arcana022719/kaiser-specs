# 12 — Performance

**Purpose:** Known limits, indexing strategy, and hot-path considerations.

**Confidence note:** Initial pre-code placeholder on 2026-11-23. Based on `db-design-choices.md`. The code wins (see 16).

## Database Indexing Baseline

- Server tables use `id bigint GENERATED ALWAYS AS IDENTITY` for dense B-tree appends, plus `UNIQUE (uuid)`.
- Index every `*_uuid` column walked by scoped pulls, and use partial unique indexes (`WHERE archived_at IS NULL`) for live-row uniqueness.
- Client SQLite tables index `(<parent>_uuid, archived_at)` for gated reads.
