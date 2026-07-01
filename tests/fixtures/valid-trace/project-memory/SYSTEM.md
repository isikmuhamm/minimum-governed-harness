# System

## Purpose and Scope

Validate a minimal task-linked code trace fixture.

## Components

- `src/policy.ts` — sample implementation.
- `tests/policy.test.ts` — sample principal regression test.

## Primary Flows

A task-linked policy is implemented and verified by a task-linked test.

## Boundaries and Sources of Truth

Project memory owns rationale; source and tests own runtime behavior.

## Invariants

Specification state remains unchanged during read-only handling.

## External Interfaces

None.

## Known Limits

This fixture exists only to validate ContextRail trace parsing.
