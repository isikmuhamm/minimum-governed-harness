# Agent Operating Guide

This repository uses Minimum Governed Harness for repo-local project memory.

## Source roles

- `project-memory/BOARD.md` — canonical list of proposed, active, and blocked tasks.
- `project-memory/NOTES.md` — task details, rationale, decisions, requirements, and risks.
- `project-memory/HISTORY.md` — canonical completion and cancellation evidence.
- Source code and tests remain canonical for runtime behavior.
- README and user-facing docs remain canonical for public claims.

## Session bootstrap

1. Run `git status --short`.
2. Read this file.
3. Read `project-memory/BOARD.md`.
4. Select exactly one active or explicitly requested task.
5. Search `project-memory/NOTES.md` by the exact task ID.
6. Read only the relevant Notes section and directly related records.
7. Inspect only the code, tests, and configuration needed for that task.
8. Use the agent's native planner for implementation steps.

Do not read all of History by default. Search it by exact ID only when prior evidence is needed.

## Work rules

- Search before creating a task, decision, requirement, or risk.
- Reuse an existing identity when it describes the same work.
- Do not encode priority or milestone into stable IDs.
- Keep Board entries short; put detail in Notes.
- Do not duplicate full rationale in Board or History.
- Prefer one small, verifiable implementation slice.
- Do not broaden scope silently.
- Do not claim completion without evidence.
- Do not add memory files unless the existing files no longer provide a clear canonical owner.

## Creating work

Search first:

```bash
rg -n -i "authentication|login|session" project-memory
```

Then:

1. add one `TASK-####` entry to Board;
2. add the matching task detail to Notes;
3. add or reference any `DEC-####`, `REQ-####`, or `RISK-####` records;
4. run the validator.

## Completing work

Complete the lifecycle update in the same change:

1. remove the task from Board;
2. update its detail and related records in Notes;
3. add a completion or cancellation record with the same task ID to History;
4. update public docs when user-visible behavior changed;
5. run relevant tests;
6. run `python scripts/validate_memory.py --strict`.

A task is not complete until implementation evidence and project-memory validation both pass.
