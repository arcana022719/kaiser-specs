# 11 — Testing

**Purpose:** Test strategy, required invariants, and manual verification drills.

**Confidence note:** Initial pre-code placeholder on 2026-11-23. No tests exist yet. The code wins (see 16).

## What Must Be Tested (Once Implemented)

- **Offline sync round-trip:** create/edit/soft-delete offline → push → pull on second client.
- **LWW conflict & tie-break:** edit vs delete in same second (delete must win).
- **Orphan guard & natural-key adoption:** child arriving before parent retries cleanly without batch failure.
- **Client SQLite upgrades:** run every migration on both fresh installs and upgraded datasets.
