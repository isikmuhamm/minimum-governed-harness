# Notes

Task details, rationale, decisions, requirements, and risks.

## TASK-0001 — Publish ContextRail v0.5 clean template distribution
- Status: completed
- Related: DEC-0002, DEC-0003
- Last updated: 2026-07-01

### Result

The clean payload, v0.5 operating contract, required-field validation, minimal template CI, source-repository parity CI, documentation, and publication workflow were implemented and passed all three operating-system jobs.

## TASK-0002 — Add synchronized template and release distribution
- Status: completed
- Related: DEC-0004
- Last updated: 2026-07-01

### Context

The Template Repository is the correct new-project installation channel, while GitHub Releases provide immutable versions, release notes, checksums, and a clean archive for existing or manually installed projects. Maintaining them as independent outputs would create drift risk.

### Decisions

A gated release workflow derives every output from `template/`, synchronizes the published template when needed, verifies a fresh clone, builds a clean ZIP, extracts and compares it, then creates the GitHub Release with checksum and file-manifest assets.

### Requirements

- The release target must be contained in `main`.
- `vX.Y.Z`, `template/.contextrail-version`, and the changelog heading must agree.
- Same-version source and published payloads must compare equal in normal CI.
- The release must not be created before fresh-clone and archive round-trip verification succeeds.
- The template repository may be updated only with `CONTEXTRAIL_TEMPLATE_TOKEN`.

### Result

Pull-request CI passed Linux, macOS, Windows, and published-template consistency checks. The merge marker started the gated workflow, which created `v0.5.0` only after source/template, fresh-clone, and extracted-archive equality gates. The official release path now publishes the clean ZIP, archive checksum, and per-file checksum manifest from the same canonical payload.

## TASK-0003 — Add handoff adoption and task-linked code trace
- Status: completed
- Related: DEC-0005, DEC-0006
- Last updated: 2026-07-01

### Context

ContextRail governed project-local work after it entered the repository, but it did not define how an external specification, assessment, or handoff package became local Board and Notes records. Source code and principal tests also had no minimal pointer back to the task context that explained why a durable behavior boundary existed.

### Decisions

- Add one generic `handoffs/HANDOFF.md` intake contract. External packages remain staging inputs and are converted into local records before implementation.
- Add a language-native code comment containing `ContextRail: TASK-####` and a short current invariant at the smallest useful implementation boundary.
- Reuse the same task marker in the principal regression test when a task establishes or changes testable runtime behavior.
- Do not create a separate implementation mapping file, semantic retrieval layer, region marker system, or full code-change history.

### Requirements

- Handoff adoption searches and deduplicates before creating local identities.
- Durable requirements, decisions, risks, rationale, acceptance criteria, and source provenance are captured in Notes.
- Independently verifiable implementation work is represented as short local Board tasks.
- Raw handoff packages do not become canonical project memory.
- Code trace markers resolve to a task with a lifecycle record and Notes detail.
- Exact duplicate task, decision, requirement, or risk titles under different identities are rejected after normalization.
- Linux, macOS, and Windows validators implement the same checks.

### Result

The clean template now includes generic handoff staging and adoption guidance, task-linked code trace rules, positive implementation/test mapping fixtures, and cross-platform validators for title identity, orphan records, code-pointer integrity, and nearby invariant text. Pull-request Actions run `28544540035` passed all validation and exact failure-assertion steps on Linux, macOS, and Windows, along with the published-template version guard.

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

## DEC-0005 — Adopt external handoffs through local records
- Status: accepted
- Related: TASK-0003
- Last updated: 2026-07-01
- Reflected in: project-memory/SYSTEM.md — Components, Primary Flows, Boundaries and Sources of Truth, and Invariants

### Decision

Treat external handoff packages as non-canonical staging inputs. Before implementation, deduplicate them against current project memory and convert durable meaning into local Notes records and independently verifiable local Board tasks.

## DEC-0006 — Trace durable code boundaries to one governing task
- Status: accepted
- Related: TASK-0003
- Last updated: 2026-07-01
- Reflected in: project-memory/SYSTEM.md — Primary Flows, Invariants, and Known Limits

### Decision

Use a minimal language-native comment containing a local `TASK-####` pointer and short current invariant. The pointer identifies the task that best explains the present behavior, not every task that historically touched the code.
