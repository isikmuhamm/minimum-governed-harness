# Notes

Task details, rationale, decisions, requirements, and risks.

Search by exact ID. Do not read the entire file unless broad discovery is genuinely required.

## TASK-0001 — Replace the sample with the first real task
- Status: proposed
- Related: none
- Last updated: 2026-06-28

### Context

Explain why the task exists and what problem it solves.

### Decisions

Record what is already settled. Link a standalone `DEC-####` record when the decision deserves an independent identity.

### Requirements

List the behavior and constraints that must hold.

### Risks

List likely failure modes, unknowns, and boundaries.

### Next slice

Define the smallest useful implementation step and how it will be verified.

## DEC-0001 — Keep project memory in three lifecycle files
- Status: accepted
- Related: TASK-0000
- Last updated: 2026-06-28

### Context

One large file can become difficult to maintain, while file-per-feature can create orphan, duplicate, and discovery problems.

### Decision

Use one folder with Board for unfinished work, Notes for detail and rationale, and History for completed evidence.

### Consequences

The repository stays simple, but lifecycle discipline and validation remain necessary.
