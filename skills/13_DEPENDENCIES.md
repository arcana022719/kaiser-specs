# 13 — Dependencies

**Purpose:** Dependency policy, chosen services, and upgrade traps.

**Confidence note:** Initial pre-code placeholder on 2026-11-23. No package manifests exist yet. The code wins (see 16).

## Baseline Platform Services

- **Database:** Supabase (PostgreSQL) on server; SQLite on Android client.
- **Auth:** Google Sign-In.
- *(Framework dependencies for `kaiser-web`, `kaiser-api`, and `kaiser-android` to be recorded once chosen in `business-logic`.)*
