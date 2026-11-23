# 05 — Debugging Playbook

**Purpose:** Log locations, known symptom diagnostics, and useful commands.

**Confidence note:** Initial pre-code placeholder on 2026-11-23. No runtime logs or services exist yet. The code wins (see 16).

## Log Locations

- *(To be populated once `kaiser-api`, `kaiser-web`, and `kaiser-android` are scaffolded.)*

## Expected Sync Failure Modes (from `db-design-choices.md`)

- **Row silently stops syncing:** check whether a local mutation forgot to bump `updated_at`, or non-sync code wrote `synchronized_at`.
- **Infinite push retry on empty stamp:** server must acknowledge rows with an empty change stamp that it already holds.
- **Child batch rejected:** verify server table does not declare a strict `REFERENCES` FK on an offline-synced parent.
