# Notes

Task details, rationale, decisions, requirements, and risks.

## TASK-0001 — Publish ContextRail v0.5 clean template distribution
- Status: completed
- Related: DEC-0002, DEC-0003
- Last updated: 2026-07-01

### Result

The clean payload, v0.5 operating contract, required-field validation, minimal template CI, source-repository parity CI, documentation, and publication workflow were implemented and passed all three operating-system jobs.

## TASK-0002 — Add synchronized template and release distribution
- Status: active
- Related: DEC-0004
- Last updated: 2026-07-01

### Context

The Template Repository is the correct new-project installation channel, while GitHub Releases provide immutable versions, release notes, checksums, and a clean archive for existing or manually installed projects. Maintaining them as independent outputs would create drift risk.

### Decisions

A release tag triggers one gated workflow. The workflow derives every output from `template/`, synchronizes the published template when needed, verifies a fresh clone, builds a clean ZIP, extracts and compares it, then creates the GitHub Release with checksum and file-manifest assets.

### Requirements

- The tag must point to a commit contained in `main`.
- `vX.Y.Z`, `template/.contextrail-version`, and the changelog heading must agree.
- Same-version source and published payloads must compare equal in normal CI.
- The release must not be created before fresh-clone and archive round-trip verification succeeds.
- The template repository may be updated only with `CONTEXTRAIL_TEMPLATE_TOKEN`.

### Risks

- The release workflow itself is exercised fully only by creating a tag.
- Cross-repository synchronization fails safely when content differs and the token is unavailable.

### Next slice

Run pull-request CI, merge the workflow, create the `v0.5.0` tag on main, and verify the release assets.

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

## DEC-0004 — Derive template and releases from one verified payload
- Status: accepted
- Related: TASK-0002
- Last updated: 2026-07-01
- Reflected in: project-memory/SYSTEM.md — Primary Flows and Invariants

### Decision

Keep the GitHub Template Repository as the new-project channel and publish versioned clean ZIP archives from the same `template/` payload. Block release creation unless source, published mirror, and extracted archive are identical.
