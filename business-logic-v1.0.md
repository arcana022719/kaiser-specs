# Business Logic

> Development of an Android-based Crowdsourced Hyperlocal Utility, Commute, and Hazard Status Platform using Flutter and Supabase for Baybay City

- Allowed Platforms: Android (primary client), Web (Compliance & Consent Portal)

## Project Details

- Company/Startup/Team Name: `Studio402`
- Project Code Name: `kaiser`
- Project Short Code: `kaiser`
- Short Description: Crowdsourced hyperlocal utility, commute, ATM cash, and road hazard status platform for Baybay City with privacy-by-design zone snapping and consensus verification.
- Long Description: Kaiser is an Android-first, offline-capable crowdsourced civic status platform for Baybay City (including VSU campus and 92 barangay hex cells). Guests and authenticated users view live consensus statuses alongside static baseline emergency/transit info, while authenticated users submit 3-tap zone-snapped status reports and 1-tap verifications protected by rotating ephemeral actor hashes, consensus thresholds, TTL expiration, and a web compliance portal.

## User Levels

| User Level              | Description |
| ----------------------- | ----------- |
| A. System Administrator | Maintains/overrides system/server configurations, zone seeds, TTL rules, and performs regular backups. |
| B. Administrator        | Manages general system settings, baseline reference data, and generates periodic system analytics and reports. |
| C. Moderator            | Reviews flagged abuse patterns, guideline strikes, and manages disputed baseline/incident states. |
| D. Contributor          | Authenticated Baybay City / VSU user who submits 3-tap zone-snapped status reports, 1-tap confirmations, and manages their consent settings. |
| E. Guest                | Users who do not log in, viewing the interactive Baybay map, consensus statuses, and static baseline reference info. |

## System Requirements

1. The app shall allow users to authenticate using Google Sign-In integration (via Supabase Auth).
2. The app shall display an interactive Baybay City map pre-seeded with 92 barangay hex cells, major transit hubs (VSU Upper Main Gate, VSU Lower Market Gate, Baybay Terminal), Poblacion/VSU bank nodes, major road corridors, and static baseline info (CDRRMO/LEYECO IV numbers, bank hours, transit routes) usable offline by guests and authenticated users.
3. The app shall allow authenticated users to submit 3-tap zone-snapped status reports (Category, Status Enum, Confirmed Zone) with no free text, snapping raw GPS to the nearest pre-seeded `zone_uuid` on-device before transmission.
4. The app shall strip permanent user identifiers from public/raw signal trails in favor of a 24-hour rotating salted HMAC (`ephemeral_actor_hash`).
5. The app shall compute consensus thresholds (>= 3 distinct reporters in urban/campus zones; >= 2 in low-density rural barangays) before shifting map pins to `CONFIRMED`, and provide a 1-tap "Nearby? Confirm / Back to Normal" verification loop.
6. The app shall enforce automatic Time-to-Live (TTL) expiration and hard-delete raw signal records after 45 minutes (Commute), 90 minutes (ATM Cash), 4 hours (Utilities), and 6–12 hours (Road & Weather Hazards), extending `valid_until` on fresh confirmations or resolving early on "Back to Normal" consensus.
7. The app shall enforce hidden abuse prevention via an internal `guideline_strikes` log applying silent escalating cooldowns (15 minutes to 24 hours) for repeatedly contradicted pings or impossible cross-city jumps, and host a Web Compliance & Consent Portal (`kaiser-web`) for Data Privacy Act disclosures, deletion schedules, and revocable `consent_records` with data resale disabled by default.

## Required Solution Layers

1. Security and privacy by design: Philippine Data Privacy Act (RA 10173) compliance, on-device location snapping (no raw GPS stored), TTL retention limits with hard-delete of raw signals, no per-user movement trails (`ephemeral_actor_hash`), aggregation consensus thresholds, silent guideline-strike enforcement without visible reputation, and explicit revocable consent for any data resale (disabled by default).

## MVP Features and Access

| Feature | Access |
| --- | --- |
| 1. Interactive Baybay Map & Baseline Reference Layer (Zero-Ping Utility) | A,B,C,D,E |
| 2. 3-Tap Zone-Snapped Status Reporting (No Free Text) | A,B,C,D |
| 3. 1-Tap Consensus Verification Loop ("Nearby? Confirm / Back to Normal") | A,B,C,D |
| 4. Compliance & Consent Web Portal (`kaiser-web`) | A,B,C,D,E |
| 5. Hidden Abuse Enforcement (`guideline_strikes` & Cooldowns) | A,B,C |
| 6. Automatic TTL Expiration & Hard-Delete Scheduler | A,B |
| 7. Zone Seed, Threshold & System Configuration Management | A |

## Notes
- Android client built with Flutter + local SQLite (offline-first baseline layer and queued reports).
- Backend API (`kaiser-api`) mediates between clients and Supabase PostgreSQL.
- Web portal (`kaiser-web`) serves Data Privacy Act disclosures, retention schedules, and revocable `consent_records`.
