# ContextRail — Minimum Governed Harness

[![Validate ContextRail distribution](https://github.com/isikmuhamm/minimum-governed-harness/actions/workflows/validate-memory.yml/badge.svg)](https://github.com/isikmuhamm/minimum-governed-harness/actions/workflows/validate-memory.yml)

**ContextRail** is a small, repo-local system map and governed project-memory layer for coding agents.

> Give an agent the right current truth, active work, task detail, external handoff context, and completed evidence without replacing its native planner or turning the repository into a planning platform.

## Installation channels

### New project: GitHub Template Repository

Create a new repository from the clean distribution mirror:

**[`isikmuhamm/contextrail-template`](https://github.com/isikmuhamm/contextrail-template)**

The template contains only files intended to remain in the resulting project.

### Existing project or pinned version: GitHub Release

Use the official Releases page in this repository and download:

```text
contextrail-template-vX.Y.Z.zip
```

Each release also includes:

```text
contextrail-template-vX.Y.Z.zip.sha256
contextrail-template-vX.Y.Z.manifest.sha256
```

The ZIP is built from the same canonical `template/` payload used to publish the Template Repository.

This repository is the ContextRail development, documentation, and release source. It is not itself the clean user-project template.

## Synchronization guarantee

Template creation and release downloads are parallel distribution channels, not independently maintained packages.

```text
minimum-governed-harness/template/
        canonical payload
              |
              +--> contextrail-template repository
              |
              +--> contextrail-template-vX.Y.Z.zip
```

A versioned release is created only after the workflow verifies all of the following:

1. the release tag is contained in `main`;
2. `vX.Y.Z`, `template/.contextrail-version`, and the matching changelog heading agree;
3. the published Template Repository matches `template/`, after synchronization when required;
4. a fresh clone of the published repository matches `template/`;
5. the generated ZIP is extracted and matches `template/`;
6. the ZIP checksum and per-file checksum manifest are generated;
7. the GitHub Release contains all expected assets.

Normal pull-request CI adds another guard: when the source and published repositories declare the same `.contextrail-version`, any content difference fails validation. This prevents two different payloads from claiming the same version.

## Core model

```text
SYSTEM  -> What is true about the implemented system now?
BOARD   -> What unfinished work exists now?
NOTES   -> What does the work mean, and why are decisions being made?
HISTORY -> What was completed or cancelled, and what proves it?
```

`AGENTS.md` tells coding agents how to retrieve and maintain those four bounded sources.

External work packages enter through `handoffs/`, are deduplicated and converted into local Board and Notes records, and remain non-canonical source evidence.

## Retrieval and implementation flow

```text
Read AGENTS
  -> read bounded SYSTEM map
  -> adopt any requested external handoff
  -> select one TASK from BOARD
  -> retrieve exact TASK and related IDs from NOTES
  -> inspect only relevant code, tests, logs, and configuration
  -> implement with the agent's native planner
  -> link durable code and principal tests back to the TASK
  -> run canonical verification
  -> record evidence in HISTORY
  -> update SYSTEM if current truth changed
```

`HISTORY.md` is searched by exact ID only when prior evidence is needed; it is not loaded by default.

## Why four memory files?

A single long instruction file mixes architecture, open work, rationale, and old evidence. A file-per-feature model can create duplicate identities, orphan files, stale links, and a large navigation surface.

ContextRail separates information by lifecycle and ownership while retaining stable IDs and exact retrieval. External handoffs and code comments point into that model rather than creating parallel sources of truth.

## Clean template contents

The published template and release ZIP contain only files intended to remain in the user's project:

```text
AGENTS.md
CLAUDE.md
GEMINI.md
.contextrail-version

.github/
  copilot-instructions.md
  workflows/contextrail.yml

.cursor/
  rules/00-agents.mdc

handoffs/
  HANDOFF.md
  incoming/.gitkeep
  processed/.gitkeep

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

They deliberately exclude ContextRail's own README, license, changelog, contribution guide, documentation, fixtures, and development history.

## ContextRail 1.0 operating contract

### External handoff adoption

Raw specifications, assessments, plans, and exports are placed under `handoffs/incoming/`. The agent follows `handoffs/HANDOFF.md`, searches before creating local identities, converts durable meaning into Notes, derives independently verifiable Board tasks, records conflicts, validates the result, and only then moves or removes the source package.

### Task-linked code trace

Durable behavior boundaries use a short native comment:

```text
ContextRail: TASK-0042
Invariant: Persistent mutation requires explicit authorization.
```

The task carries the full rationale and relationships. The code comment identifies the task that best explains the current behavior; it does not list every historical edit. The same marker belongs on the principal regression test when the task establishes testable runtime behavior.

### Root cause before patch

Agents identify the violated invariant, domain rule, state transition, parser contract, policy, or ownership boundary before adding an input-specific guard. Tests prove a behavior class, not only the reported sentence or example.

### Independent review

After implementation, the agent reviews its own diff as if no other reviewer will catch the mistake. Completion claims must be grounded in code, tests, logs, or observable output.

### Controlled incidental findings

Unrelated bugs and risks are reported with evidence but do not silently expand the current task. Only security, data-loss, verification-blocking, or result-invalidating findings justify an immediate scope change.

### Canonical verification integration

On first substantive use, the agent discovers the project's existing test, build, lint, static-analysis, smoke, and CI entrypoints. It integrates the matching ContextRail validator into one canonical verification command instead of creating a parallel test system.

## Validation scope

The OS-native validators require no Python, Node.js, Go, Rust, Java, .NET, or project runtime. They validate the ContextRail contract, including:

- required files and `SYSTEM.md` sections;
- lifecycle records incorrectly placed in System;
- duplicate IDs;
- exact normalized record titles reused under different identities;
- inconsistent titles for the same stable identity;
- invalid statuses;
- required fields for Board, Notes, and History records;
- missing completion or cancellation dates;
- missing completion evidence or outcome;
- Board/History overlap;
- orphan task details;
- broken `Related`, `Supersedes`, and `Replacement` references;
- accepted decisions not reflected in current system truth;
- task-linked code comments that point to missing lifecycle or Notes records;
- task-linked comments without a nearby non-empty invariant;
- an oversized System map that may no longer be bounded.

The validator does **not** prove that an invariant is semantically correct or replace native project tests. It verifies that the trace points to governed local context and becomes one step inside the repository's canonical verification pipeline.

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

## Documentation

- [Governance contract](docs/GOVERNANCE.md)
- [Adoption guide](docs/ADOPTION.md)
- [Release history](CHANGELOG.md)

## What ContextRail is not

ContextRail is not a project-management replacement, specification generator, planning compiler, file-per-feature requirement, multi-agent runtime, semantic database, or substitute for source code and native tests.

It is a minimal governed context layer that lets the coding agent keep using its own planner.

## Stability

Version 1.0 freezes the minimal contract: four bounded memory roles, generic handoff adoption, task-linked code trace, OS-native validation, canonical verification integration, and synchronized distribution. New mechanisms should be added only after repeated use demonstrates a real boundary or failure mode.

## License

MIT
