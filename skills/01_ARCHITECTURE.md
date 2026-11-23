# 01 — Architecture

**Purpose:** High-level system model, repository ownership, data flow, hard boundaries, and decision records. Read this first.

**Confidence note:** Verified against `AGENTS.md` and `db-design-choices.md` on 2026-11-23. Application code does not exist yet. The code wins (see 16).

## One-Paragraph Model

Kaiser is a multi-repo, offline-first platform split across four repositories: `kaiser-specs` (product specs, schema, planning), `kaiser-api` (backend service mediating between Supabase Postgres and clients), `kaiser-web` (web client with regulatory compliance), and `kaiser-android` (Android client). Clients write locally to SQLite and sync via `kaiser-api` to Supabase Postgres using UUID identity and last-write-wins (`updated_at`).

## Components and Ownership

| Repo | Owns | Must Not Own |
| --- | --- | --- |
| `kaiser-specs` | Business logic, DB schemas, skills docs, planning | Runtime application code |
| `kaiser-api` | Auth/session stamping, sync endpoints, Supabase Postgres access | Client UI |
| `kaiser-web` | Web UI, regulatory compliance views | Direct unauthenticated DB access |
| `kaiser-android` | Android UI, local SQLite storage, offline sync client | Server-only `id` generation or actor stamping |

## Hard Boundaries

- **Server-only `id`:** `bigint GENERATED ALWAYS AS IDENTITY` never leaves Postgres. *Miss → ID collisions across offline clients and enumeration risk.*
- **Server-stamped actors:** `created_by` and action actor columns come from the authenticated session, never from client payloads. *Miss → clients can spoof ownership.*
- **Privacy by design:** Location protection, retention limits, no per-user trails, aggregation thresholds, and explicit consent for any data resale (from `business-logic-v1.0.md`).

## Decision Records

### Decision: Offline-first UUID-native sync with Supabase Postgres (2026-11-23, course baseline)
**Status:** accepted
**Context / Choice / Alternatives / Consequences:** Clients must work offline; use client-minted UUIDs + `updated_at` LWW + `archived_at` soft deletes instead of server-assigned sequential IDs; adds `uuid` index overhead and requires tolerating temporary orphans on server.

## Debt Register

- Application code, `git-guidelines.md`, finalized `business-logic-v1.1.md`, and `db-schema/v1.0.0.sql` are not yet created.
