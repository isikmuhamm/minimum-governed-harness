# Notes

Task details, rationale, decisions, requirements, and risks.

## TASK-0001 — Publish ContextRail v0.5 clean template distribution
- Status: active
- Related: DEC-0002, DEC-0003
- Last updated: 2026-07-01

### Context

The original repository was both the ContextRail product source and a GitHub template. New projects therefore inherited ContextRail's own README, license, changelog, fixtures, and development history. Reusable files also existed at repository root, making it unclear which copy should be maintained.

### Decisions

Use `template/` as the only canonical distribution payload. Publish that payload to a separate clean template repository. Keep validator development fixtures and three-platform CI only in this source repository.

### Requirements

- Add root-cause-before-patch, independent review, incidental-finding, and canonical-verification rules to the distributed `AGENTS.md`.
- Validate required fields in Board, Notes, and History records.
- Keep a minimal memory-validation workflow in the user template.
- Test validator parity on Linux, macOS, and Windows in this repository.

### Risks

- Cross-repository automated publishing requires a repository-scoped credential that cannot be created by the repository contents API.
- Shell and PowerShell validators may drift unless changed and tested together.

### Next slice

Run the v0.5 pull-request workflow, correct any platform differences, publish the verified payload to `contextrail-template`, and then close the lifecycle record with CI evidence.

## DEC-0001 — Separate current truth, work, rationale, and evidence
- Status: accepted
- Related: TASK-0000
- Last updated: 2026-07-01
- Reflected in: project-memory/SYSTEM.md — Boundaries and Sources of Truth

### Decision

Use `SYSTEM.md`, `BOARD.md`, `NOTES.md`, and `HISTORY.md` as four bounded information roles.

## DEC-0002 — Maintain one canonical template payload
- Status: accepted
- Related: TASK-0001
- Last updated: 2026-07-01
- Reflected in: project-memory/SYSTEM.md — Components, Primary Flows, and Invariants

### Decision

Maintain reusable files only under `template/`. Treat `isikmuhamm/contextrail-template` as a published mirror rather than a separate development source.

## DEC-0003 — Integrate memory validation into canonical project verification
- Status: accepted
- Related: TASK-0001
- Last updated: 2026-07-01
- Reflected in: project-memory/SYSTEM.md — Invariants

### Decision

On first substantive use, discover the repository's existing native verification entrypoint and add ContextRail validation to the same canonical command. Use the standalone template workflow only as an initial safety net or when no established CI exists.
