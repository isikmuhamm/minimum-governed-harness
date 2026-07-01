# ContextRail — Minimum Governed Harness

[![Validate ContextRail distribution](https://github.com/isikmuhamm/minimum-governed-harness/actions/workflows/validate-memory.yml/badge.svg)](https://github.com/isikmuhamm/minimum-governed-harness/actions/workflows/validate-memory.yml)

**ContextRail** is a small, repo-local system map and governed project-memory layer for coding agents.

> Give an agent the right current truth, active work, task detail, and completed evidence without replacing its native planner or turning the repository into a planning platform.

## Use the clean template

New projects should use the dedicated distribution repository:

**[`isikmuhamm/contextrail-template`](https://github.com/isikmuhamm/contextrail-template)**

This repository is the ContextRail development and documentation source. It is not the clean user-project template.

## Core model

```text
SYSTEM  -> What is true about the implemented system now?
BOARD   -> What unfinished work exists now?
NOTES   -> What does the work mean, and why are decisions being made?
HISTORY -> What was completed or cancelled, and what proves it?
```

`AGENTS.md` tells coding agents how to retrieve and maintain those four bounded sources.

## Why four files?

A single long instruction file mixes architecture, open work, rationale, and old evidence. A file-per-feature model can create duplicate identities, orphan files, stale links, and a large navigation surface.

ContextRail separates information by lifecycle and ownership while keeping retrieval simple:

```text
Read AGENTS
  -> read bounded SYSTEM map
  -> select one TASK from BOARD
  -> retrieve exact TASK and related IDs from NOTES
  -> inspect only relevant code, tests, logs, and configuration
  -> use the agent's native planner
  -> implement and run canonical verification
  -> record evidence in HISTORY
  -> update SYSTEM if current truth changed
```

`HISTORY.md` is searched by exact ID only when prior evidence is needed; it is not loaded by default.

## Clean template contents

The published template contains only files intended to remain in the user's project:

```text
AGENTS.md
CLAUDE.md
GEMINI.md

.github/
  copilot-instructions.md
  workflows/contextrail.yml

.cursor/
  rules/00-agents.mdc

project-memory/
  SYSTEM.md
  BOARD.md
  NOTES.md
  HISTORY.md

scripts/
  validate-linux.sh
  validate-macos.sh
  validate-windows.ps1
```

It deliberately excludes ContextRail's own README, license, changelog, contribution guide, documentation, fixtures, and development history.

## v0.5 operating contract

The current agent guide adds four controls derived from real multi-session project failures:

### Root cause before patch

Agents must identify the violated invariant, domain rule, state transition, or ownership boundary before adding an input-specific guard. Tests should prove a behavior class, not only the reported sentence or example.

### Independent review

After implementation, the agent reviews its own diff as if no other reviewer will catch the mistake. Completion claims must be grounded in code, tests, logs, or observable output.

### Controlled incidental findings

Unrelated bugs and risks are reported with evidence but do not silently expand the current task. Only security, data-loss, verification-blocking, or result-invalidating findings can justify an immediate scope change.

### Canonical verification integration

On first substantive use, the agent discovers the project's existing test, build, lint, static-analysis, smoke, and CI entrypoints. It integrates the matching ContextRail validator into one canonical verification command instead of creating a parallel test system.

## Validation scope

The OS-native validators require no Python, Node.js, Go, Rust, Java, .NET, or project runtime. They validate the project-memory contract, including:

- required files and `SYSTEM.md` sections;
- lifecycle records incorrectly placed in System;
- duplicate IDs;
- invalid statuses;
- required fields for Board, Notes, and History records;
- missing completion or cancellation dates;
- missing completion evidence or outcome;
- Board/History overlap;
- orphan task details;
- broken `Related`, `Supersedes`, and `Replacement` references;
- accepted decisions not reflected in current system truth;
- an oversized System map that may no longer be bounded.

The validator does **not** replace native project tests. It becomes one step inside the repository's canonical verification pipeline.

## Required record fields

### Board task

```markdown
## TASK-0001 — Add user authentication
- Status: active
- Priority: P1
- Owner: unassigned
- Related: DEC-0001
- Summary: Add session-based authentication.
- Acceptance: Login, logout, and protected routes are behavior-tested.
```

### Notes record

```markdown
## TASK-0001 — Add user authentication
- Status: active
- Related: DEC-0001
- Last updated: 2026-07-01
```

Accepted decisions should also include:

```markdown
- Reflected in: project-memory/SYSTEM.md — Authentication boundary
```

### History record

```markdown
## TASK-0001 — Add user authentication
- Status: completed
- Completed: 2026-07-01
- Related: DEC-0001
- Evidence: `pytest tests/auth -q`
- Outcome: Login, logout, and protected routes implemented.
```

Cancelled tasks use `Cancelled: YYYY-MM-DD` instead of `Completed`.

## Distribution architecture

```text
minimum-governed-harness/template/
        canonical distribution source
                    |
                    v
isikmuhamm/contextrail-template
        clean published mirror
```

All reusable changes are developed and tested under `template/`. The template repository is not edited as an independent product source.

## Documentation

- [Governance contract](docs/GOVERNANCE.md)
- [Adoption guide](docs/ADOPTION.md)
- [Release history](CHANGELOG.md)

## What ContextRail is not

ContextRail is not a project-management replacement, specification generator, planning compiler, file-per-feature requirement, multi-agent runtime, semantic database, or substitute for source code and native tests.

It is a minimal governed context layer that lets the coding agent keep using its own planner.

## License

MIT
