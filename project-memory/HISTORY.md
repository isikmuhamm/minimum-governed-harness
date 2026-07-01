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

## TASK-0002 — Add synchronized template and release distribution
- Status: completed
- Completed: 2026-07-01
- Related: DEC-0004
- Evidence: Pull-request Actions run 28522311524 passed Linux, macOS, Windows, and published-template consistency jobs; the gated release workflow created tag `v0.5.0`, whose tagged tree declares version `0.5.0` and contains the synchronized release workflow.
- Outcome: Added official clean GitHub Release archives in parallel with the Template Repository, with tag/version/changelog agreement, fresh-clone and archive round-trip equality gates, ZIP checksum, per-file manifest, and same-version drift detection.

## TASK-0003 — Add handoff adoption and task-linked code trace
- Status: completed
- Completed: 2026-07-01
- Related: DEC-0005, DEC-0006
- Evidence: Pull-request Actions run 28544540035 passed clean-template validation, source-repository validation, the valid implementation/test trace fixture, exact invalid-fixture assertions, and the published-template version guard on Linux, macOS, and Windows.
- Outcome: Added generic external handoff adoption, minimal TASK-plus-invariant code trace for implementation and principal tests, normalized-title identity guards, code-pointer validation, cross-platform fixtures, stable 1.0 documentation, and synchronized 1.0.0 release preparation.

## TASK-0004 — Harden published version synchronization
- Status: completed
- Completed: 2026-07-01
- Related: DEC-0004
- Evidence: The first release attempt stopped before tag creation when fresh-clone equality detected the stale mirror version; pull-request Actions run 28545034563 then passed Linux, macOS, Windows, and the published-template version guard after workflow hardening.
- Outcome: The release workflow now explicitly copies and stages `.contextrail-version`, checks worktree and staged values against the requested release, and retains fresh-clone plus archive round-trip gates.
