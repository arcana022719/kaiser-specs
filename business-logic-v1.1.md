# Business Logic (v1.1)

> Development of an Android-based Crowdsourced Hyperlocal Utility, Commute, and Hazard Status Platform using Flutter and Supabase for Baybay City

- Allowed Platforms: Android (Flutter primary client), Web (`kaiser-web` Compliance & Consent Portal)

## Project Details

- Company/Startup/Team Name: `Studio402`
- Project Code Name: `kaiser`
- Project Short Code: `kaiser`
- Short Description: Crowdsourced hyperlocal utility, commute, ATM cash, and road hazard status platform for Baybay City with privacy-by-design zone snapping and consensus verification.
- Long Description: Kaiser is an Android-first, offline-capable crowdsourced civic status platform for Baybay City (92 barangay hex cells, VSU campus, transit hubs, bank nodes, and road corridors). Guests and authenticated users view live consensus statuses and static baseline emergency/transit info offline. Authenticated users submit 3-tap zone-snapped reports and 1-tap verifications protected by 24-hour rotating `ephemeral_actor_hash`, density-aware consensus thresholds, category TTL expiration, silent `guideline_strikes`, and a Web Compliance & Consent Portal.

## User Levels

| User Level | Description |
| --- | --- |
| A. System Administrator | Maintains system/server configs, zone seeds, TTL/threshold rules, rotating HMAC salts, and backups. |
| B. Administrator | Manages baseline reference nodes, monitors aggregate platform health, and generates compliance reports. |
| C. Moderator | Reviews internal `guideline_strikes` anomalies and manages disputed baseline/incident states. |
| D. Contributor | Authenticated Baybay City / VSU user who submits 3-tap zone-snapped reports, 1-tap verifications, and manages `consent_records`. |
| E. Guest | Unauthenticated user who views the interactive Baybay map, consensus statuses, and static baseline reference info offline/online. |

## System Requirements

1. **Authentication:** The app shall authenticate contributors via Google Sign-In (Supabase Auth) while allowing guests zero-login read access to the map and baseline layer.
2. **Interactive Map & Zero-Ping Baseline Layer:** The app shall pre-seed 92 Baybay City barangay hex cells, transit hubs (VSU Upper Main Gate, VSU Lower Market Gate, Baybay Terminal), Poblacion/VSU bank nodes, road corridors, and static baseline info (CDRRMO/LEYECO IV contacts, bank hours, Kilimtoda/Bastoda/VSU multicab routes) in local SQLite for offline use.
3. **3-Tap Zone-Snapped Reporting:** Authenticated users shall report via 3 taps — Category (`utilities`, `commute`, `atm_cash`, `road_hazard`), Status Enum (`power_out`, `no_water`, `scarce_rides`, `offline_no_cash`, `flooded`, etc.), and Confirmed Zone — with no free text, snapping raw GPS to the nearest `zone_uuid` on-device before transmission.
4. **Ephemeral Identity & Stale-Ping Guard:** The API shall derive a 24-hour rotating salted HMAC (`ephemeral_actor_hash`) for `raw_signals` so no per-user movement trail is stored, and discard queued offline reports whose `created_at` already exceeds category TTL on arrival.
5. **Consensus Thresholding & 1-Tap Verification:** Public pins shall shift to `CONFIRMED` only upon reaching >= 3 distinct `ephemeral_actor_hash` reports in urban/campus zones or >= 2 in rural barangays, with a 1-tap "Nearby? Confirm / Back to Normal" loop (one vote per actor per active aggregate).
6. **Automatic TTL Expiration:** Raw signals and aggregates shall expire and hard-delete raw records after 45 min (Commute), 90 min (ATM Cash), 4 hr (Utilities), and 6–12 hr (Road & Weather Hazards); fresh confirmations extend `valid_until`, while "Back to Normal" consensus resolves early.
7. **Silent Abuse Enforcement & Web Compliance Portal:** An internal `guideline_strikes` log shall apply silent escalating cooldowns (15 min to 24 hr) for impossible cross-city jumps (> 10 km in < 5 min) or repeatedly contradicted pings, while `kaiser-web` hosts RA 10173 disclosures, deletion schedules, and revocable `consent_records` (data resale disabled by default).

## Required Solution Layers

1. Security and privacy by design: Philippine Data Privacy Act (RA 10173) compliance, on-device zone snapping (zero raw GPS storage), TTL hard-deletion of raw signals, 24-hour rotating `ephemeral_actor_hash` (no per-user trails), density-aware aggregation thresholds, silent `guideline_strikes` (no public karma/rewards), and revocable `consent_records` with data resale disabled by default.

## MVP Features and Access

| Feature | Access |
| --- | --- |
| 1. Interactive Baybay Map & Baseline Reference Layer (Zero-Ping Utility) | A,B,C,D,E |
| 2. 3-Tap Zone-Snapped Status Reporting (No Free Text) | A,B,C,D |
| 3. 1-Tap Consensus Verification Loop ("Nearby? Confirm / Back to Normal") | A,B,C,D |
| 4. Compliance & Consent Web Portal (`kaiser-web`) | A,B,C,D,E |
| 5. Hidden Abuse Enforcement (`guideline_strikes` & Escalating Cooldowns) | A,B,C |
| 6. Automatic TTL Expiration & Raw Signal Hard-Delete Scheduler | A,B |
| 7. Zone Seed, Threshold & Rotating Salt Configuration | A |
