# 03 — Code Style

**Purpose:** Coding, commenting, and commit conventions across Kaiser repositories.

**Confidence note:** Verified at initial setup on 2026-11-23; no source code exists yet. The code wins (see 16).

## Comment Philosophy

- Comment **why**, not what. Name the invariant or outage a guard prevents.
- Mark known shortcuts with `shortcut: <limit>, <when to upgrade>`.

## Tooling, Formatting, and Commit Conventions

- **Commit format (`git-guidelines.md`):** `scope: Imperative summary` (sentence case, no period, <= 50 chars).
- **Scopes:** `kaiser-specs[/<feature>]`, `kaiser-api[/<feature>]`, `kaiser-web[/<feature>]`, `kaiser-app[/<feature>]`.
- **AI exclusion:** never add any AI agent as author of commits, tags, releases, or PRs.
- *(Code linters/formatters to be filled once `kaiser-web`, `kaiser-api`, and `kaiser-android` tech stacks are scaffolded.)*

## Anti-Patterns Banned by Baseline Rules

- **Accepting `created_by` or `id` from client sync payloads:** allows ownership spoofing and breaks `GENERATED ALWAYS`.
- **Hard `DELETE` on synced tables:** deletions fail to propagate; clients push deleted rows back.
- **Mirroring `*_uuid` into local `*_id` on clients:** drifts on table rebuilds and complicates sync translation.
