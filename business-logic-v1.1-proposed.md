# Business Logic (v1.1 Proposed Revisions)

> Development of an Android-based Crowdsourced Hyperlocal Utility, Commute, and Hazard Status Platform using Flutter and Supabase for Baybay City

## Gaps Identified in v1.0 & Proposed MVP Additions

1. **Authentication vs. Ephemeral Actor Separation:**
   - **Gap:** `v1.0` specifies Google Sign-In and `ephemeral_actor_hash`, but does not define how `guideline_strikes` and `consent_records` link to an account without exposing movement trails.
   - **Proposal:** Keep `account` (`auth.users` / Google Sign-In) for `consent_records` and `guideline_strikes` (server-side only, never exposed to public/map endpoints), while `raw_signals` stores only `ephemeral_actor_hash = HMAC-SHA256(daily_rotating_salt, account_uuid)` so raw signals cannot be joined across days.

2. **Offline Queuing & Stale-Ping Guard:**
   - **Gap:** Offline-first clients can queue a 3-tap report while disconnected, then sync it hours later after the real-world condition or TTL window has already passed.
   - **Proposal:** Stamp `created_at` on-device at tap time; if `now() - created_at` exceeds the category TTL on push, the API acknowledges and discards the expired raw signal without extending active consensus.

3. **Consensus State Machine & Hysteresis:**
   - **Gap:** `v1.0` defines `CONFIRMED` (>= 3 urban/campus, >= 2 rural) and "Back to Normal", but leaves unconfirmed (`PENDING`) visibility and conflicting votes undefined.
   - **Proposal:** Expose `PENDING` aggregates only as subtle low-confidence indicators (or hold until threshold), require >= 2 "Back to Normal" confirmations (or >= 50% of active confirmations) to resolve early, and prevent the same `ephemeral_actor_hash` from voting twice on the same `(zone_uuid, category, status_enum)` within one TTL window.

4. **Impossible Cross-City Jump & Contradicted-Ping Rules:**
   - **Gap:** Silent cooldowns (15m to 24h) need concrete trigger thresholds to avoid false-positive strikes.
   - **Proposal:** Trigger a strike only when (a) two reports from the same `account_uuid` in < 5 minutes span zones > 10 km apart, or (b) >= 3 consecutive reports are overturned by "Back to Normal" consensus within 30 minutes.

5. **Zero-Ping Utility & Baseline Seed Versioning:**
   - **Gap:** Pre-seeded 92 barangay hex cells, transit hubs, banks, and emergency numbers need offline updates without app-store releases.
   - **Proposal:** Store baseline nodes and zones in synced `zone` and `baseline_node` tables (`updated_at` dirty pull) bundled with a local SQLite seed on first install.

6. **Out-of-Scope (Deferred to Post-MVP):**
   - Free-text comments, photo uploads, public user profiles/leaderboards, and third-party data resale integrations (consent toggle remains `false` by default).
