# Git Guidelines

Combined reference for commit messages and release versioning.

## Contents

- [Part 1 — Commit Message Standard](#part-1--commit-message-standard)
  - [Required Format](#required-format)
  - [Format Breakdown](#format-breakdown)
  - [Full Commit Structure](#full-commit-structure)
  - [Good vs Bad Examples](#good-vs-bad-examples)
  - [Breaking Changes](#breaking-changes)
  - [Quick Reference](#quick-reference)
  - [The One-Sentence Test](#the-one-sentence-test)
- [Part 2 — Versioning Guidelines](#part-2--versioning-guidelines)
  - [Notes](#notes)
  - [Branching Models](#branching-models)
  - [Release Testing and Approval](#release-testing-and-approval)
  - [Production Support and Maintenance](#production-support-and-maintenance)
  - [Format](#format)
  - [Rules](#rules)
  - [Release Tags](#release-tags)

---

## Part 1 — Commit Message Standard

### Required Format

Every commit message **must** begin with:

```
scope: Imperative summary
```

---

### Format Breakdown

#### `scope:`

The part of the codebase this commit affects. Prefer a product and major
subsystem scope for changes to the actual applications. Use lowercase names;
use `product/subsystem:` when the change is focused, and `product:` when it
spans multiple subsystems within that application.

#### Preferred application scopes

Choose the most specific scope that still describes the whole commit:

| Scope | When to use |
|---|---|
| `kaiser-api/<feature>:` | Back-end API feature or major subsystem |
| `kaiser-web/<feature>:` | Front-end web app feature or major subsystem |
| `kaiser-app/<feature>:` | Android app feature or major subsystem |
| `kaiser-specs/<feature>:` | Specification content for a feature or major subsystem (the documents themselves, not code) |
| `kaiser-api:` | Cross-feature back-end API change |
| `kaiser-web:` | Cross-feature front-end web app change |
| `kaiser-app:` | Cross-feature Android app change |
| `kaiser-specs:` | Cross-feature specification change (shared conventions, structure, or templates) |

Use established feature names where applicable. Because every product belongs
to one ecosystem, feature scopes are listed once and shared by all products
(`kaiser-api/auth:`, `kaiser-web/auth:`, `kaiser-app/auth:`, and so on):

`auth`, `sync`, `security`, `backup`, `restore`, `map`, `signals`, `consensus`, `strikes`, `consent`

`kaiser-specs` is a version-controlled repository of specifications, so
its commits change the spec documents themselves, not code. A feature scope
there (`kaiser-specs/auth:`) means the specification *of* that feature. It
also accepts spec-kind scopes that name the type of document being changed:
`requirements`, `design`, `schema`, `contracts`. Use the feature scope when
the change belongs to one feature, and the spec-kind scope when it applies
across features.

Examples:

```
kaiser-app/map: Snap GPS to nearest zone before upload
kaiser-app/sync: Retry failed record pulls
kaiser-web/consent: Show RA 10173 deletion schedule
kaiser-web/auth: Keep password errors beside the field
kaiser-web: Align shared page spacing across routes
kaiser-specs/auth: Define Google Sign-In flow
kaiser-specs/design: Add spacing tokens to the style guide
kaiser-specs/schema: Clarify soft-delete columns
```

Do not use generic scopes such as `ui:`, `api:`, or `core:` when a
product/feature scope communicates the affected application more clearly.
For changes that genuinely span products or are not application-specific, use
the general scopes below. If a commit genuinely touches multiple independent
scopes, split it.

#### General scopes

Use these only when a product/feature scope does not fit:

| Scope | When to use |
|---|---|
| `kaiser-specs` | Cross-repository specifications, design specs, schema snapshots, migration docs |
| `kaiser-api` | Backend/API changes in the server repository |
| `db` | Database-only changes not specific to one application |
| `config` | Shared configuration or environment conventions |
| `test` | Cross-cutting test utilities or test infrastructure |
| `docs` | Documentation not specific to an application or subsystem |
| `ci` | Cross-repository CI/CD or build infrastructure |
| `deps` | Dependency updates not scoped to one application |

---

#### `Imperative summary`

- Written in imperative mood: reads as *"If applied, this commit will — [summary]"*
- Sentence case — capitalize only the first word
- No period at the end
- **50 characters or fewer** (hard limit for display in tools)
- Describes **what** the commit does, not what you did
- For specification changes, describes the change to the spec itself (for example `Define`, `Clarify`, `Revise`, `Deprecate`), not the implementation it will drive

```
auth: Add OAuth2 PKCE flow for mobile clients    ✓
auth: Added OAuth2 PKCE flow                     ✗  (past tense)
auth: oauth pkce                                 ✗  (too vague)
auth: TT-4821                                    ✗  (ticket number only)
```

---

### Full Commit Structure

The first line is the only required field. Everything below is optional but encouraged for non-trivial changes.

```
scope: Imperative summary

Why this change was necessary and what problem it solves. Wrap
at 72 characters. Focus on the reasoning, not the mechanics —
the diff already shows what changed.

Fixes #1234 — Short description of the ticket
See-also #1201 — Related prior change
```

#### Section rules

| Section | Required | Placement | Notes |
|---|---|---|---|
| `scope: Summary` | **Yes** | Line 1 | The entire format above applies |
| Blank line | If body follows | Line 2 | Never skip this — tools break without it |
| Body | No | Lines 3+ | Explain why; wrap at 72 chars |
| References | No | After body | Always include a human-readable description beside the ticket number |

---

### Breaking Changes

If a commit introduces a breaking change, add `!` after the scope bracket and include a `BREAKING CHANGE:` trailer.

```
api:! Remove deprecated /v1/login endpoint

BREAKING CHANGE: /v1/login is no longer available. Clients must
migrate to /v2/auth before this version is deployed.
```

---

### Quick Reference

```
scope: Imperative summary                 ← required, ≤50 chars
                                          ← blank line if body follows
Why this was necessary. Wrap at 72.       ← optional body

Fixes #NNN — ticket description           ← optional references
```

---

### The One-Sentence Test

> Read the summary alone, with no context. Would a developer who joins the team next year understand what this commit did and why it mattered?

If not, rewrite it.

---

### Exclusion of AI Agent

> Any AI agent should not be added as author of any commits, tags, releases, or PRs.

---

## Part 2 — Versioning Guidelines

### Notes

#### Ecosystem-wide identity

All products share one identity, so a tag shows which product it belongs to
from its prefix alone.

- **Code Name**: `kaiser`
- **Short Code**: `KS`

#### Product prefixes

The prefix is one letter for the product followed by the ecosystem short code.

| Product | Prefix | Formula |
|---|---|---|
| Web App Front-end (`kaiser-web`) | `WKS` | `W` + `KS` |
| Server/Back-end API (`kaiser-api`) | `BKS` | `B` + `KS` |
| Android App (`kaiser-android`) | `AKS` | `A` + `KS` |
| Specifications (`kaiser-specs`) | `SKS` | `S` + `KS` |

### Branching Models

#### Maturity-based branching model

The project follows a **maturity-based branching model**. The branches represent
controlled workflow stages, and code is promoted only after it passes the gate
for its current stage:

`main` → `beta` → `release` → production

| Branch | Role | Permitted work |
|---|---|---|
| `main` | Development | Feature development, integration of completed changes, and developer unit testing. |
| `beta` | QA / system testing | System testing against major product claims, defect correction, and stabilization of the development build. |
| `release` | Bundled release testing | Builds published to the release website for independent integration testing, candidate iteration, and final production approval. |

### Format

`<prefix>.0X.Y.00Z`

First release tags: `WKS.01.0.001`, `BKS.01.0.001`, `AKS.01.0.001`,
`SKS.01.0.001`.

### Release Tags

#### Creating a release

1. **Start at the first commit's week.** The first tag (`001`) always goes on the ISO week of the repository's first commit.
2. **No commits, no tag.**
3. **Never tag an ongoing week.** Do not create a tag for the current ISO week until it is **Friday 5:00 PM or later on your local clock**.
4. **Bundle commits into the week they fall in.**
5. **Only tag weeks that don't have a tag yet.**
6. **Tags are always chronological.**

#### kaiser-android — Android (AKS)

| Tag | ISO week | Release date | Commit |
| --- | --- | --- | --- |
|  |  |  |  |

Next release: **`AKS.01.0.001`**.

#### kaiser-web — web front-end (WKS)

| Tag | ISO week | Release date | Commit |
| --- | --- | --- | --- |
|  |  |  |  |

Next release: **`WKS.01.0.001`**.

#### kaiser-api — back-end api (BKS)

| Tag | ISO week | Release date | Commit |
| --- | --- | --- | --- |
|  |  |  |  |

Next release: **`BKS.01.0.001`**.

#### kaiser-specs — specifications (SKS)

| Tag | ISO week | Release date | Commit |
| --- | --- | --- | --- |
|  |  |  |  |

Next release: **`SKS.01.0.001`**.
