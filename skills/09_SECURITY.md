# 09 — Security

**Purpose:** Threat model, authentication, authorization, privacy-by-design rules, and secrets handling.

**Confidence note:** Verified against `business-logic-v1.0.md` and `db-design-choices.md` on 2026-11-23. Runtime code not yet written. The code wins (see 16).

## Authentication & Authorization

- **Auth:** Google Sign-In integration required by `business-logic-v1.0.md`.
- **Ownership stamping:** server stamps `created_by` and action actor columns from the authenticated session; never trust client-supplied actor UUIDs.

## Privacy by Design (Required Solution Layers)

- Data Privacy Act compliance.
- Location protection, retention limits, no per-user trails, aggregation thresholds, and explicit consent for any data resale.
- Enforcement via community-guideline hits instead of visible reputation.

## Secrets Handling

- Never commit `.env` values, API keys, passwords, or SSH private keys. Document env var **names** only.
