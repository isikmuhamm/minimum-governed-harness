# ContextRail — Minimum Governed Harness


**ContextRail** is the project name; **Minimum Governed Harness** describes the pattern.
A lightweight, repo-local project memory and governance template for coding agents.

> Give the agent a reliable map of current work, task details, and completed evidence without turning the repository into a planning platform.

## Core model

```text
AGENTS.md
project-memory/
  BOARD.md
  NOTES.md
  HISTORY.md
scripts/
  validate_memory.py
```

| File | Canonical question |
| --- | --- |
| `AGENTS.md` | How should the agent work in this repository? |
| `project-memory/BOARD.md` | What unfinished work exists now? |
| `project-memory/NOTES.md` | What are the details, decisions, requirements, and risks? |
| `project-memory/HISTORY.md` | What was completed or cancelled, and what proves it? |
| `README.md` | What does the project publicly claim and provide? |

The same `TASK-####` identity follows a task through its lifecycle. While work is unfinished, it appears in Board and may have a matching detail record in Notes. Once completed, it leaves Board and receives a completion record in History. Notes may remain as durable rationale.

```text
BOARD + NOTES -> implementation + verification -> HISTORY + retained NOTES
```

## Why governance is included

Neither one large file nor one file per feature solves governance by itself. Both can produce duplicate tasks, orphan notes, stale active work, broken references, contradictory status, or the same feature opened under different names.

Minimum Governed Harness keeps storage simple and adds a dependency-free validator.

## Quick start

1. Create a repository from this template or copy these files into an existing repository.
2. Replace the sample entries under `project-memory/`.
3. Adapt `AGENTS.md` to the project's build, test, and safety rules.
4. Run:

```bash
python scripts/validate_memory.py
python scripts/validate_memory.py --strict
python -m unittest discover -s tests -v
```

Strict mode treats warnings as failures.

## Supported records

- `TASK-####` — work with a lifecycle.
- `DEC-####` — durable decision.
- `REQ-####` — durable requirement.
- `RISK-####` — durable risk.

Priority, milestone, owner, and status are metadata, not identity.

## Lifecycle

```text
proposed -> active -> blocked -> active -> completed
                \-> cancelled
```

- `proposed`, `active`, and `blocked` tasks live in Board.
- Task details live in Notes under the same task ID.
- `completed` and `cancelled` tasks live in History.
- A task must not exist in Board and History at the same time.

## Record examples

### Board

```markdown
## TASK-0001 — Add user authentication
- Status: active
- Priority: P1
- Owner: unassigned
- Related: DEC-0001
- Summary: Add session-based authentication.
- Acceptance: Login, logout, and protected routes are tested.
```

### Notes

```markdown
## TASK-0001 — Add user authentication
- Status: active
- Related: DEC-0001
- Last updated: 2026-06-28

### Context
Why the task exists.

### Decisions
What is already settled.

### Risks
Known constraints and failure modes.

### Next slice
The smallest useful implementation step.
```

### History

```markdown
## TASK-0001 — Add user authentication
- Status: completed
- Completed: 2026-06-28
- Related: DEC-0001
- Evidence: `pytest tests/auth`
- Outcome: Login, logout, and protected routes implemented.
```

## Governance rules

1. Search before create.
2. Reuse the same task identity when the work already exists.
3. Keep Board short and Notes detailed.
4. Remove completed work from Board.
5. Reference durable records instead of copying them.
6. Update Board, Notes, History, public docs, and validation together.
7. Add another memory file only when ownership, lifecycle, security, or independent reuse clearly requires it.

See [`docs/GOVERNANCE.md`](docs/GOVERNANCE.md).

## Validator checks

The validator detects:

- duplicate IDs inside the same file;
- malformed record headings;
- unresolved `Related`, `Supersedes`, and `Replacement` references;
- tasks present in both Board and History;
- Notes task details with no Board or History lifecycle record;
- Board tasks with no matching Notes detail;
- invalid statuses for each lifecycle file;
- completed History records without a valid completion date;
- unreferenced decision, requirement, and risk records;
- suspiciously similar active task titles.

Warnings are review signals, not proof of an error.

## Scope

This is not a project-management replacement, multi-agent runtime, semantic search system, planning compiler, or mandatory file-per-feature scheme. It is a minimal governed memory layer that works with the coding agent's native planner.

## Status

This is an early reference implementation for field testing. Performance, token savings, and task-success improvements should be measured rather than assumed.

## License

MIT
