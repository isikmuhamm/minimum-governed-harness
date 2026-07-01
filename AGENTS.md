# Agent Operating Guide

This repository uses Minimum Governed Harness for repo-local system context and project memory.

## Source roles

- `project-memory/SYSTEM.md` — canonical current system model.
- `project-memory/BOARD.md` — canonical unfinished work queue.
- `project-memory/NOTES.md` — task detail, rationale, decisions, requirements, and risks.
- `project-memory/HISTORY.md` — canonical completion and cancellation evidence.
- Source code and tests remain canonical for runtime behavior.
- `README.md` and user-facing documentation remain canonical for public claims.

## Session bootstrap

1. Run `git status --short`.
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

It may contain purpose, components, flows, boundaries, invariants, interfaces, and known limits. It must not contain active tasks, implementation plans, chronological logs, unresolved design debates, or speculative future architecture presented as current truth.

Open design work belongs in `NOTES.md`. When a decision is accepted and implemented, update the concise current truth in `SYSTEM.md`.

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

## Completing work

1. Implement and verify the task.
2. Remove it from `BOARD.md`.
3. Update its detail and related records in `NOTES.md`.
4. Add completion evidence to `HISTORY.md`.
5. Update `SYSTEM.md` when current architecture or invariants changed.
6. Update public docs when user-visible behavior changed.
7. Run relevant tests and `python scripts/validate_memory.py --strict`.
