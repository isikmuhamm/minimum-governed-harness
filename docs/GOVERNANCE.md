# Governance Contract

ContextRail separates current system truth, unfinished work, reasoning, completion evidence, external intake, and runtime behavior without creating parallel sources of truth.

## System

`project-memory/SYSTEM.md` answers: **What is the implemented system now?**

It contains a concise map of purpose, components, flows, boundaries, invariants, external interfaces, and current limits. It excludes open tasks, chronological logs, unresolved debates, and speculative future architecture.

## Board

`project-memory/BOARD.md` answers: **What unfinished work exists now?**

It contains only `TASK-####` records with `proposed`, `active`, or `blocked` status. Each task requires `Status`, `Priority`, `Owner`, `Related`, `Summary`, and `Acceptance`.

## Notes

`project-memory/NOTES.md` answers: **What does this work mean, why does it exist, and what has been decided?**

Task, decision, requirement, and risk records require `Status`, `Related`, and `Last updated`. Accepted decisions should identify where the resulting current truth is reflected. External source identifiers, implementation boundaries that cannot carry comments, and handoff provenance also belong in the relevant Notes record.

## History

`project-memory/HISTORY.md` answers: **What was completed or cancelled, and what evidence supports that state?**

History contains only task records. Every record requires `Status`, `Related`, `Evidence`, and `Outcome`. Completed records require `Completed: YYYY-MM-DD`; cancelled records require `Cancelled: YYYY-MM-DD`.

## External handoffs

`handoffs/HANDOFF.md` defines how external specifications, assessments, plans, and exports enter the governed local model.

Raw packages under `handoffs/incoming/` are non-canonical source evidence. Before implementation, the agent searches existing records, preserves external provenance, converts durable meaning into Notes, derives independently verifiable local Board tasks, records conflicts, and validates the result. Adopted packages may move to `handoffs/processed/` when retention remains useful.

## Lifecycle

```text
proposed -> active -> blocked -> active -> completed
                \-> cancelled
```

The stable identity does not change when priority, milestone, owner, or status changes.

## Stable identities and titles

- Search before creating a task, decision, requirement, or risk.
- Reuse the same identity for the same work or durable meaning.
- The same stable identity should use the same normalized title wherever it appears.
- Do not create two identities of the same record type with the same normalized title.
- When later work changes prior behavior, relate or supersede the earlier record rather than opening an indistinguishable duplicate.

Title normalization ignores case, repeated whitespace, and punctuation. It is a deterministic identity guard, not semantic search.

## Canonical ownership

- current architecture and boundaries: System;
- unfinished task state: Board;
- task detail and rationale: Notes;
- completion and cancellation evidence: History;
- external intake procedure: `handoffs/HANDOFF.md`;
- raw handoff packages: non-canonical source evidence under `handoffs/`;
- runtime behavior: source code and native tests;
- public promise: README and user-facing documentation;
- agent workflow: AGENTS.

A task may appear in Board and Notes because they serve different roles. A task must not appear in Board and History simultaneously.

## Task-linked code trace

When a task creates or materially changes a durable behavior boundary, the smallest stable implementation scope carries a language-native comment:

```text
ContextRail: TASK-####
Invariant: <current behavior or constraint>
```

The marker points to the task that best explains the current invariant. It does not list every task that historically touched the code. The same task marker belongs on the principal regression test when the behavior is testable.

Place the marker before the complete symbol when the task governs the symbol, or immediately before the narrower block or statement when it governs only that behavior. Preserve it through refactoring, replace it when a later task changes the invariant, and leave it unchanged for mechanical edits that preserve the behavior contract.

Generated code, vendor code, binaries, lock files, and formats that cannot safely carry comments are not modified for traceability. Record those implementation boundaries in the task's Notes section.

Validators confirm that code markers point to a task with a Board or History lifecycle record and matching Notes detail. They do not prove that the stated invariant is semantically correct.

## Root cause before patch

A defect should be traced to the violated invariant, domain rule, state transition, parser contract, policy, or ownership boundary before an input-specific condition is added. Regression tests should cover the failure class, not only the reported phrase.

## Independent review

The implementing agent is also the first reviewer and QA layer. It must inspect its diff, verify acceptance criteria against evidence, state test limits, check relevant failure paths and system invariants, and confirm task-linked traces still point to the correct current scope before claiming completion.

## Incidental findings

Unrelated findings must be reported but should not silently expand the current task. Immediate scope expansion is reserved for security, data loss, verification blockers, or findings that invalidate the current result.

## Atomic completion

Complete implementation, native tests, code-trace maintenance, Board removal, Notes update, History evidence, System updates, public docs, self-review, and canonical verification as one lifecycle change.

## Adapter governance

`AGENTS.md` is the only canonical agent instruction file in a user project. Tool-specific files remain thin pointers.

## When to add another memory file

Add one only when a separate owner, security boundary, lifecycle, independent reuse need, or enough search noise creates a real boundary. Do not split merely because a section is long. External handoffs and implementation traces should point into the existing four memory roles rather than creating new canonical stores.
