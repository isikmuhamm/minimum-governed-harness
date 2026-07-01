# Board

The short, canonical view of unfinished ContextRail work.

Allowed statuses: `proposed`, `active`, `blocked`.

## TASK-0004 — Harden published version synchronization
- Status: active
- Priority: P0
- Owner: unassigned
- Related: DEC-0004
- Summary: Ensure the published template stages and commits `.contextrail-version` before release round-trip verification.
- Acceptance: The workflow force-stages the declared version, proves the staged and published values match the source, and successfully publishes `v1.0.0` without bypassing equality gates.
