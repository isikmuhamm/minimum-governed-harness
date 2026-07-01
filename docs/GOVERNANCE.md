# Governance Contract

ContextRail separates current system truth, unfinished work, reasoning, and completion evidence.

## System

`project-memory/SYSTEM.md` answers: **What is the implemented system now?**

It contains a concise map of purpose, components, flows, boundaries, invariants, external interfaces, and current limits. It excludes open tasks, chronological logs, unresolved debates, and speculative future architecture.

## Board

`project-memory/BOARD.md` answers: **What unfinished work exists now?**

It contains only `TASK-####` records with `proposed`, `active`, or `blocked` status. Each task requires `Status`, `Priority`, `Owner`, `Related`, `Summary`, and `Acceptance`.

## Notes

`project-memory/NOTES.md` answers: **What does this work mean, why does it exist, and what has been decided?**

Task, decision, requirement, and risk records require `Status`, `Related`, and `Last updated`. Accepted decisions should identify where the resulting current truth is reflected.

## History

`project-memory/HISTORY.md` answers: **What was completed or cancelled, and what evidence supports that state?**

History contains only task records. Every record requires `Status`, `Related`, `Evidence`, and `Outcome`. Completed records require `Completed: YYYY-MM-DD`; cancelled records require `Cancelled: YYYY-MM-DD`.

## Lifecycle

```text
proposed -> active -> blocked -> active -> completed
                \-> cancelled
```

The stable identity does not change when priority, milestone, owner, or status changes.

## Canonical ownership

- current architecture and boundaries: System;
- unfinished task state: Board;
- task detail and rationale: Notes;
- completion and cancellation evidence: History;
- runtime behavior: source code and native tests;
- public promise: README and user-facing documentation;
- agent workflow: AGENTS.

A task may appear in Board and Notes because they serve different roles. A task must not appear in Board and History simultaneously.

## Root cause before patch

A defect should be traced to the violated invariant, domain rule, state transition, parser contract, policy, or ownership boundary before an input-specific condition is added. Regression tests should cover the failure class, not only the reported phrase.

## Independent review

The implementing agent is also the first reviewer and QA layer. It must inspect its diff, verify acceptance criteria against evidence, state test limits, and check relevant failure paths and system invariants before claiming completion.

## Incidental findings

Unrelated findings must be reported but should not silently expand the current task. Immediate scope expansion is reserved for security, data loss, verification blockers, or findings that invalidate the current result.

## Atomic completion

Complete implementation, native tests, Board removal, Notes update, History evidence, System updates, public docs, self-review, and canonical verification as one lifecycle change.

## Adapter governance

`AGENTS.md` is the only canonical agent instruction file in a user project. Tool-specific files remain thin pointers.

## When to add another memory file

Add one only when a separate owner, security boundary, lifecycle, independent reuse need, or enough search noise creates a real boundary. Do not split merely because a section is long.
