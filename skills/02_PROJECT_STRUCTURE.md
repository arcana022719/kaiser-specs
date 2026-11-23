# 02 — Project Structure

**Purpose:** Workspace layout, repository boundaries, and naming conventions.

**Confidence note:** Verified against `kaiser-ecosystem/` directory layout on 2026-11-23. The code wins (see 16).

## Annotated Tree

```text
kaiser-ecosystem/
├── AGENTS.md                 # Root agent instructions
├── handoff.md                # Skills generation/maintenance guide
├── kaiser-specs/             # Product specifications & DB schema
│   ├── AGENTS.md
│   ├── business-logic-v1.0.md
│   ├── db-design-choices.md
│   ├── sense-making.md
│   ├── git-guidelines.md     # (Pending download from VSUEE)
│   └── skills/               # 00_INDEX.md, INBOX.md, 01..16
├── kaiser-web/               # Front-end web application
│   └── AGENTS.md
├── kaiser-api/               # Back-end API (Supabase bridge)
│   └── AGENTS.md
└── kaiser-android/           # Android application
    └── AGENTS.md
```

## Naming Conventions

- **Repositories:** lowercase kebab-case `<code-name>-<suffix>` (`kaiser-specs`, `kaiser-web`, `kaiser-api`, `kaiser-android`).
- **Foreign keys in SQL:** `<parent>_uuid` everywhere; never local integer `*_id`.
- **Database versions:** forward migrations bump patch (`v1.0.0` → `v1.0.1`); full Supabase snapshots bump minor (`v1.0.0` → `v1.1.0`).
