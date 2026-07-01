# External Handoff Adoption

This directory is the staging surface for specifications, assessments, plans, exports, and other work packages created outside the repository.

External packages are inputs, not canonical project memory. Their durable meaning must be adopted into local ContextRail records before implementation begins.

## Directory lifecycle

```text
handoffs/incoming/<package-id>/
        external package awaiting adoption

handoffs/processed/<package-id>/
        package already adopted into local records
```

Packages under `processed/` are retained only when repository policy, audit needs, or source provenance requires them. They are not loaded during normal session bootstrap.

## Adoption procedure

1. Preserve the package under one stable `handoffs/incoming/<package-id>/` path while it is being reviewed.
2. Read `project-memory/SYSTEM.md`, `BOARD.md`, and the relevant exact-ID sections of `NOTES.md` before creating records.
3. Search existing task titles, durable record titles, keywords, source identifiers, and relevant code to detect overlap or conflict.
4. Separate the package into:
   - current implemented facts;
   - requirements and invariants;
   - accepted or proposed decisions;
   - risks and unresolved questions;
   - independently verifiable implementation outcomes;
   - source provenance and acceptance evidence.
5. Reuse existing local identities when the same work or durable meaning already exists.
6. Create or update local `REQ-####`, `DEC-####`, and `RISK-####` records in `NOTES.md` only when the information is durable and useful beyond one task.
7. Create one local `TASK-####` Notes record for each independently verifiable implementation outcome, then add the corresponding short entry to `BOARD.md`.
8. Preserve external identifiers and package provenance inside the relevant Notes records. Do not substitute external identifiers for local ContextRail identities.
9. If the package conflicts with implemented system truth or an accepted decision, do not silently implement either side. Record the conflict as task detail, a proposed decision, or a risk and block the affected task when necessary.
10. Run the canonical verification command. Only after local records pass validation may the package move from `incoming/` to `processed/` or be removed according to repository policy.

## Notes mapping

Use the existing Notes record rather than creating a separate source registry. A task may include a compact provenance section such as:

```markdown
### Source handoff

- Package: `handoffs/processed/example-package/`
- External references: `WORK-17`, `REQ-A12`
- Adopted: 2026-07-01
```

The full external text should not be copied into every local record. Capture the minimum durable context required to understand the work, retain a source pointer, and keep the raw package only when it remains useful.

## Task derivation

A package does not map mechanically to one task.

- Split it when it contains multiple independently verifiable outcomes.
- Merge it into an existing task when it describes work already represented locally.
- Create Notes records without a Board task when the package contributes durable rationale but no unfinished implementation work.
- Do not update `SYSTEM.md` merely because a package proposes a future design. Update System only after implementation makes that design current truth.

## Canonical ownership after adoption

```text
Current implemented truth  -> project-memory/SYSTEM.md
Unfinished local work       -> project-memory/BOARD.md
Detail, rationale, records  -> project-memory/NOTES.md
Completion evidence         -> project-memory/HISTORY.md
Runtime behavior            -> source code and native tests
Raw external package        -> handoffs/ (non-canonical source evidence)
```
