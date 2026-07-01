# History

The canonical record of completed or cancelled ContextRail tasks.

Allowed statuses: `completed`, `cancelled`.

## TASK-0000 — Bootstrap Minimum Governed Harness
- Status: completed
- Completed: 2026-06-28
- Related: DEC-0001
- Evidence: GitHub Actions validated Linux, macOS, and Windows and rejected the original invalid fixture.
- Outcome: Added the initial system map, Board, Notes, History, canonical agent guide, adapters, OS-native validators, fixture, and cross-platform CI.

## TASK-0001 — Publish ContextRail v0.5 clean template distribution
- Status: completed
- Completed: 2026-07-01
- Related: DEC-0002, DEC-0003
- Evidence: GitHub Actions run 28520073108 passed clean-template validation, source-repository memory validation, and invalid-fixture rejection on Linux, macOS, and Windows.
- Outcome: Established `template/` as the canonical distribution source, added the v0.5 agent contract and required-field validation, documented the two-repository model, and prepared automated publication to the clean template repository.
