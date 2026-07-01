# Governance Contract

Minimum Governed Harness separates current system truth, work state, reasoning, and evidence.

## System

`project-memory/SYSTEM.md` answers: **What is the implemented system now?**

It contains a concise map of purpose, components, flows, boundaries, invariants, external interfaces, and current limits. It excludes open tasks, chronological logs, unresolved debates, and speculative future architecture.

## Board

`project-memory/BOARD.md` answers: **What unfinished work exists now?**

It contains only `TASK-####` records with `proposed`, `active`, or `blocked` status. Board entries remain short.

## Notes

`project-memory/NOTES.md` answers: **What does this work mean, why does it exist, and what has been decided?**

It may contain task detail, decisions, requirements, risks, and unresolved design work. Accepted and implemented decisions are summarized as current truth in System; Notes retain the rationale.

## History

`project-memory/HISTORY.md` answers: **What was completed or cancelled, and what evidence supports that state?**

It contains only task records with `completed` or `cancelled` status.

## Lifecycle

```text
proposed -> active -> blocked -> active -> completed
                \-> cancelled
```

The stable identity does not change when priority, milestone, owner, or status changes.

## Canonical ownership

- current architecture and boundaries: System,
- unfinished task state: Board,
- task detail and rationale: Notes,
- completion and cancellation evidence: History,
- runtime behavior: source code and native tests,
- public promise: README and user-facing documentation,
- agent workflow: AGENTS.

A task may appear in Board and Notes because they serve different roles. A task must not appear in Board and History simultaneously.

## Search before create

Search exact and related terms, likely IDs, and similar active tasks. Update an existing record when it describes the same work. A new identity is justified when the work has an independent acceptance condition.

## Atomic completion

Complete implementation, native tests, Board removal, Notes update, History evidence, System updates, public docs, and OS-specific harness validation together.

## Adapter governance

`AGENTS.md` is the only canonical agent instruction file. Tool-specific files must remain pointers; duplicating rules across adapters creates drift.

## When to add another memory file

Add one only when there is a separate owner, security boundary, lifecycle, independent reuse need, or enough search noise to harm targeted retrieval. Do not split merely because a section is long.
