# 16 — Engineering Principles

**Purpose:** Core rules derived from the project's architecture and failure modes.

**Confidence note:** Verified against `handoff.md` and `db-design-choices.md` on 2026-11-23. The code wins.

1. **Every rule has a reason, and every reason names what breaks.** *(Source: `handoff.md`)*
2. **Server-only `id`, client-minted `uuid`.** Never share surrogate `id`s across machines or accept actor columns from clients. *(Source: `db-design-choices.md` §2–§4)*
3. **Soft delete, never hard delete.** Synced tables set `archived_at` and bump `updated_at` so deletions propagate. *(Source: `db-design-choices.md` §5)*
4. **Every local write bumps `updated_at`; only sync writes `synchronized_at`.** Break either and rows silently stop syncing. *(Source: `db-design-choices.md` §6)*
5. **Trust the code over any document, including this one.** *(Source: `handoff.md`)*
