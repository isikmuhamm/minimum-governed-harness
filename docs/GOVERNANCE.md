# Governance Contract

Markdown makes project memory visible. Governance keeps it from decaying.

## Responsibilities

### Board

Answers: **What unfinished work exists now?**

Contains only `TASK-####` records with `proposed`, `active`, or `blocked` status. Entries remain short.

### Notes

Answers: **What does this work mean, why does it exist, and what has been decided?**

Contains matching task details and optional decision, requirement, and risk records. Notes may remain after completion as durable rationale.

### History

Answers: **What was completed or cancelled, and what evidence supports it?**

Contains only task records with `completed` or `cancelled` status.

## Canonical ownership

- Unfinished status: Board.
- Task detail and rationale: Notes.
- Completion evidence: History.
- Runtime truth: source code and tests.
- Public promise: README and user-facing docs.

A task may appear in Board and Notes because they have different responsibilities. It must not appear in Board and History at the same time.

## Search before create

Before adding a record, search exact terms, synonyms, likely IDs, and similar active titles. Create a new identity only when the work has a different acceptance condition and can be completed independently.

## Atomic completion

Update implementation, tests, Board, Notes, History, public docs, and validator result as one logical change.

## When to add another file

Split only when there is a strong boundary: separate owner, security boundary, different lifecycle, independent reuse, or enough size/search noise to harm targeted access. Length alone is not sufficient.

## Validator semantics

Errors break the contract. Warnings indicate a governance risk requiring judgment. Use `--strict` when warnings should block CI.
