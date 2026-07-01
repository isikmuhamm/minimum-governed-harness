# System

This file describes the current implemented system. Keep it concise, stable, and free of task planning.

## Purpose and Scope

Describe what the system does, who or what it serves, and what is outside its scope.

## Components

List the major components and their responsibilities.

- `component-a` — replace with a real component and one-line responsibility.

## Primary Flows

Describe the few flows an agent must understand before changing the system.

1. Input enters through the public boundary.
2. Domain logic validates and transforms it.
3. Persistence or external systems receive the result.

## Boundaries and Sources of Truth

State where authoritative information lives.

- Runtime behavior — source code and tests.
- Active work — `project-memory/BOARD.md`.
- Task detail and rationale — `project-memory/NOTES.md`.
- Completed evidence — `project-memory/HISTORY.md`.
- Public behavior — `README.md` and user-facing documentation.

## Invariants

List conditions that must remain true across changes.

- A completed task must not remain on the Board.
- Current architecture must not be inferred from old History records.

## External Interfaces

List APIs, queues, files, databases, providers, protocols, or human handoffs that form system boundaries.

- None documented yet.

## Known Limits

List current, implemented limitations. Do not put future tasks here.

- The initial template has no semantic search or external task-system integration.

## Decision References

- `DEC-0001` — current memory and system-context separation.
