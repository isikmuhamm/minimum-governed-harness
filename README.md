# ContextRail — Minimum Governed Harness

**ContextRail** is the project name; **Minimum Governed Harness** describes the pattern.

A lightweight, repo-local project memory and system context template for coding agents.

> Give the agent the minimum reliable context needed to understand the current system, select current work, retrieve the right detail, and preserve completion evidence.

## Core structure

```text
AGENTS.md
project-memory/
  SYSTEM.md
  BOARD.md
  NOTES.md
  HISTORY.md
scripts/
  validate_memory.py
```

- `SYSTEM.md` — current implemented system truth.
- `BOARD.md` — proposed, active, and blocked tasks.
- `NOTES.md` — task detail, rationale, decisions, requirements, and risks.
- `HISTORY.md` — completed or cancelled work and evidence.

The value comes from the information contract:

```text
SYSTEM  -> current truth
BOARD   -> current work
NOTES   -> detail and rationale
HISTORY -> completed evidence
```

## Why add SYSTEM.md?

A Board becomes noisy when it carries both work items and architectural truth. Open or disputed design choices stay in Notes. Once accepted and implemented, their concise current truth is reflected in System.

## Session flow

```text
AGENTS -> SYSTEM -> BOARD -> exact TASK in NOTES -> relevant code/tests -> implementation -> HISTORY/SYSTEM update
```

The coding agent keeps its native planner. ContextRail supplies only a governed context and memory layer.

## Governance

1. Search before create.
2. Keep Board actionable; move architecture truth to System and detail to Notes.
3. Keep one stable identity for the same work.
4. Do not keep a task in both Board and History.
5. Reference records instead of duplicating them.
6. Complete lifecycle updates atomically.

See [docs/GOVERNANCE.md](docs/GOVERNANCE.md).

## License

MIT
