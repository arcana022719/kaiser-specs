# 15 — Known Limitations

**Purpose:** Current gaps, deferred work, and architectural constraints.

**Confidence note:** Verified on 2026-11-23. The code wins (see 16).

## Current Gaps

- **Empty app repos:** `kaiser-web`, `kaiser-api`, and `kaiser-android` contain only `AGENTS.md`.

## Architectural Constraints (from `db-design-choices.md`)

- Row-level LWW loses concurrent edits on the same row; fast client clocks can win conflicts.
- No per-edit audit history on base tables unless an append-only audit table is added.
