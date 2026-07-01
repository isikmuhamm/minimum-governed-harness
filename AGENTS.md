# Agent Operating Guide

This repository uses ContextRail, a Minimum Governed Harness for repo-local system context and project memory.

## Canonical instruction file

This file is the canonical operating guide for all coding agents.

Tool-specific entry files such as `CLAUDE.md`, `GEMINI.md`, Copilot instructions, and Cursor rules must only direct the tool here. Do not duplicate operating rules across adapters.

## Source roles

- `project-memory/SYSTEM.md` — canonical current system model.
- `project-memory/BOARD.md` — canonical unfinished work queue.
- `project-memory/NOTES.md` — task detail, rationale, decisions, requirements, and risks.
- `project-memory/HISTORY.md` — canonical completion and cancellation evidence.
- Source code and native project tests remain canonical for runtime behavior.
- `README.md` and user-facing documentation remain canonical for public claims.

## Session bootstrap

1. Inspect the working tree before changing anything.
2. Read this file.
3. Read `project-memory/SYSTEM.md` once as the bounded system map.
4. Read `project-memory/BOARD.md`.
5. Select exactly one active or explicitly requested task.
6. Search `project-memory/NOTES.md` by the exact task ID.
7. Read only the matching Notes section and directly related records.
8. Inspect only the code, tests, and configuration needed for that task.
9. Use the agent's native planner for implementation steps.

Do not read all of `HISTORY.md` by default. Search it by exact task or related ID only when prior implementation evidence is needed.

## System model rules

`SYSTEM.md` describes the system as it exists now.

It may contain purpose and scope, components and ownership, primary flows, boundaries and sources of truth, invariants, external interfaces, and known limits.

It must not contain active tasks, implementation plans, chronological logs, unresolved design debates, or speculative future architecture presented as current truth.

Open design work belongs in `NOTES.md`. When a decision is accepted and implemented, update the concise current truth in `SYSTEM.md` and set the decision's `Reflected in` field.

## Work rules

- Search before creating a task, decision, requirement, or risk.
- Reuse the existing identity when the work already exists.
- Keep Board entries short and actionable.
- Put detail and rationale in Notes.
- Keep stable architecture truth in System.
- Do not duplicate full decision text across files.
- Prefer one small, verifiable implementation slice.
- Do not broaden scope silently.
- Do not claim completion without evidence.

## Creating work

Before creating a record, use the agent's repository search capability to search titles, keywords, and likely IDs.

1. Add one `TASK-####` entry to `BOARD.md`.
2. Add the matching detail entry to `NOTES.md`.
3. Add or reference related `DEC-####`, `REQ-####`, or `RISK-####` records.
4. Run the operating-system-specific memory validator.

## Completing work

1. Implement and verify the task using the project's native toolchain.
2. Remove it from `BOARD.md`.
3. Update its detail and related records in `NOTES.md`.
4. Add completion or cancellation evidence to `HISTORY.md`.
5. Update `SYSTEM.md` when current architecture, flow, interface, ownership, or invariants changed.
6. Update public docs when user-visible behavior changed.
7. Run the project's own tests.
8. Run exactly one matching harness validator.

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

The harness validator checks project-memory governance only. It does not replace the project's native tests.
