# ContextRail — Minimum Governed Harness

[![Validate project memory](https://github.com/isikmuhamm/minimum-governed-harness/actions/workflows/validate-memory.yml/badge.svg)](https://github.com/isikmuhamm/minimum-governed-harness/actions/workflows/validate-memory.yml)

**ContextRail** is the project name; **Minimum Governed Harness** describes the pattern.

A small, repo-local system map and project-memory harness for coding agents.

> Give the agent the right current truth, active work, task detail, and completed evidence—without turning the repository into a planning platform.

ContextRail sits between two common extremes: one instruction file that cannot reliably preserve project state, and a full planning or orchestration framework that creates many artifacts and its own workflow. It keeps the coding agent's native planner and adds only the smallest durable context and governance layer around it.

## Core idea

```text
SYSTEM  -> What is true about the implemented system now?
BOARD   -> What unfinished work exists now?
NOTES   -> What does the work mean, and why are decisions being made?
HISTORY -> What was completed or cancelled, and what proves it?
```

These roles could live in one document. Four bounded files keep retrieval small and stop current architecture, open work, rationale, and historical evidence from competing in the same surface.

## Repository structure

```text
AGENTS.md                         Canonical operating guide
CLAUDE.md                         Thin adapter to AGENTS.md
GEMINI.md                         Thin adapter to AGENTS.md
.github/copilot-instructions.md   Thin adapter to AGENTS.md
.cursor/rules/00-agents.mdc       Thin adapter to AGENTS.md

project-memory/
  SYSTEM.md                       Current system map
  BOARD.md                        Unfinished work queue
  NOTES.md                        Detail, decisions, requirements, risks
  HISTORY.md                      Completed/cancelled work and evidence

scripts/
  validate-linux.sh               Dependency-free Linux validator
  validate-macos.sh               Dependency-free macOS validator
  validate-windows.ps1            Dependency-free Windows validator
```

## How an agent uses it

```text
Read AGENTS
  -> read bounded SYSTEM map
  -> select one TASK from BOARD
  -> retrieve exact TASK and related IDs from NOTES
  -> inspect only relevant code/tests/config
  -> use the agent's native planner
  -> implement and run the project's own tests
  -> remove completed TASK from BOARD
  -> record evidence in HISTORY
  -> update SYSTEM if current truth changed
  -> run the OS-native memory validator
```

`HISTORY.md` is not loaded by default. It is searched by exact ID only when prior implementation evidence is needed.

## Quick start

1. Click **Use this template** on GitHub.
2. Replace the sample records in `project-memory/`.
3. Add your real build and test commands to `AGENTS.md`.
4. Run the validator for your operating system.

### Linux

```sh
sh scripts/validate-linux.sh --strict
```

### macOS

```sh
sh scripts/validate-macos.sh --strict
```

### Windows

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\validate-windows.ps1 -Strict
```

The harness requires no Python, Node.js, Go, Rust, Java, .NET, or project-specific runtime. The validators use tools supplied with the operating system.

The harness validator checks project-memory governance only. It does **not** replace native project tests such as `go test ./...`, `npm test`, `cargo test`, `dotnet test`, `ctest`, or a project's own runner.

## Stable record identities

- `TASK-####` — work with an independently verifiable outcome.
- `DEC-####` — a durable design or product decision.
- `REQ-####` — a requirement or invariant that must hold.
- `RISK-####` — a tracked uncertainty or failure mode.

Priority, milestone, status, and owner are fields, not part of the stable identity.

## System model versus design discussion

`SYSTEM.md` contains concise, implemented truth: purpose, components, flows, boundaries, invariants, interfaces, and known limits. Unresolved design work stays in `NOTES.md`. When a decision is accepted and implemented, its resulting current truth is reflected in `SYSTEM.md`.

This prevents Board from becoming a mixture of tasks, architecture, discussion, and old evidence.

## Governance rules

1. Search before creating a record.
2. Reuse the same identity for the same work.
3. Keep Board short and actionable.
4. Put task detail and reasoning in Notes.
5. Put implemented system truth in System.
6. Put completion and verification evidence in History.
7. Never keep one task in Board and History simultaneously.
8. Reference records instead of copying their full text.
9. Update implementation, memory, and public documentation as one lifecycle change.
10. Add another memory file only when ownership, lifecycle, security, or independent reuse creates a real boundary.

## What validation catches

The OS-native validators detect missing files or System sections, lifecycle records placed in System, duplicate IDs, invalid statuses, missing dates/evidence, Board/History overlap, orphan task details, unresolved references, accepted decisions without reflection, and an oversized System map.

Warnings become failures in strict mode. A deliberately invalid fixture verifies that CI rejects broken memory rather than only passing a valid sample.

## Agent compatibility

`AGENTS.md` is the single canonical instruction source. Claude Code, Gemini CLI, GitHub Copilot, and Cursor files are thin redirects, avoiding instruction drift.

## Why not file-per-feature?

File-per-feature can improve isolation, but it can also create duplicate features, orphan files, stale links, naming drift, and a large navigation surface. ContextRail uses stable IDs and targeted section retrieval. A logical record can remain modular without requiring a separate physical file.

## What this is not

ContextRail is not a project-management replacement, file-per-feature requirement, specification generator, planning compiler, multi-agent runtime, semantic database, or replacement for source code and native tests.

It is a minimal governed context layer that lets the coding agent keep using its own planner.

## Adoption and documentation

- [Governance contract](docs/GOVERNANCE.md)
- [Adoption guide](docs/ADOPTION.md)
- [Release history](CHANGELOG.md)

## Status

This is an early reference implementation extracted from real multi-session coding-agent workflows. It will be refined through use and measured experiments rather than by adding features pre-emptively.

## License

MIT
