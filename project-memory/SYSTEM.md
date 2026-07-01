# System

This file describes the current implemented ContextRail development and distribution system.

## Purpose and Scope

ContextRail provides a minimal governed system map, project-memory layer, external-handoff intake contract, and task-linked implementation trace for coding-agent repositories. This repository develops, tests, documents, versions, and publishes the reusable template. It does not generate specifications, manage projects, perform semantic retrieval, or replace project-native verification.

## Components

- `template/` — canonical source for every file distributed to user repositories.
- `template/handoffs/HANDOFF.md` — generic procedure for adopting external packages into local Board and Notes records.
- `template/scripts/` — OS-native project-memory and code-trace validators.
- `project-memory/` — ContextRail's own system model, active work, rationale, and completion evidence.
- `docs/` — public adoption and governance documentation.
- `tests/fixtures/valid-trace/` — valid implementation and principal-test task trace.
- `tests/fixtures/invalid/` — deliberately invalid memory, identity, and code-trace examples.
- `.github/workflows/validate-memory.yml` — Linux, macOS, and Windows contract validation, exact failure assertions, and same-version published-template drift detection.
- `.github/workflows/release.yml` — tag-gated synchronization, archive creation, round-trip verification, checksums, manifest generation, and GitHub Release publication.
- `isikmuhamm/contextrail-template` — clean published mirror used as the GitHub Template Repository.
- GitHub Releases — immutable version announcements and clean downloadable template archives.

## Primary Flows

1. Reusable changes are made under `template/`.
2. External packages in a user repository are staged under `handoffs/incoming/`, deduplicated, and converted into local Notes records and independently verifiable Board tasks before implementation.
3. Durable implementation boundaries and principal regression tests may carry a local `TASK-####` pointer and short invariant.
4. Validators confirm memory lifecycle, identity, references, and task-linked code-pointer integrity on Linux, macOS, and Windows.
5. Documentation, changelog, and `.contextrail-version` are updated with the behavior change.
6. A `vX.Y.Z` tag pointing to `main` starts the release workflow.
7. The workflow requires the tag, changelog heading, and `.contextrail-version` to agree.
8. The workflow synchronizes `template/` to `isikmuhamm/contextrail-template` when needed and verifies a fresh clone against the source payload.
9. A clean ZIP is built from `template/`, extracted, and compared back to the source before the GitHub Release is created.
10. Users either create a new repository from the clean template or download the matching release archive.

## Boundaries and Sources of Truth

- Reusable distribution payload — `template/`.
- Current ContextRail system model — this file.
- Active ContextRail work — `project-memory/BOARD.md`.
- Task detail and rationale — `project-memory/NOTES.md`.
- Completed evidence — `project-memory/HISTORY.md`.
- External-handoff intake procedure — `template/handoffs/HANDOFF.md`.
- Raw external packages in user repositories — non-canonical source evidence under `handoffs/`.
- Runtime behavior — source code and native tests.
- Public behavior and adoption claims — `README.md` and `docs/`.
- Published user template — generated mirror at `isikmuhamm/contextrail-template`; it is not independently edited.
- Official versions and downloadable archives — GitHub Releases in `minimum-governed-harness`.

## Invariants

- `template/` is the only canonical source for distributed files.
- The published template contains only files intended to remain in a user's repository.
- The published template excludes this repository's README, license, changelog, contribution guide, fixtures, and development history.
- External packages are adopted into local records before implementation and do not become another canonical memory store.
- Stable record identities do not reuse the same normalized title under different IDs.
- Task-linked code markers resolve to a local Board or History lifecycle record and matching Notes detail.
- Code comments point to the task that best explains the current invariant rather than accumulating full edit history.
- Linux, macOS, and Windows validators implement the same governance contract.
- The empty clean template and valid trace fixture pass strict validation.
- Deliberately invalid fixtures emit and fail on the expected identity, orphan, and code-pointer findings.
- If source and published repositories declare the same `.contextrail-version`, their payloads are byte-equivalent.
- A GitHub Release is created only after the source payload, fresh published-template clone, and extracted release ZIP compare equal.
- Release tag, changelog section, and `.contextrail-version` identify the same semantic version.
- A completed task does not remain on the Board.
- Project-native tests remain authoritative for runtime behavior; ContextRail validation governs memory and pointer integrity.

## External Interfaces

- GitHub repository `isikmuhamm/contextrail-template`.
- GitHub Releases API and `gh` CLI.
- GitHub Actions runners for Linux, macOS, and Windows.
- Repository secret `CONTEXTRAIL_TEMPLATE_TOKEN` for cross-repository template publication.

## Known Limits

- Existing user repositories do not receive template updates automatically.
- Validator implementations are intentionally OS-native and therefore require parity maintenance across shell and PowerShell.
- Code-trace validation proves pointer integrity and nearby invariant text, not semantic correctness or test adequacy.
- Commentless, generated, vendor, lock, and binary files rely on task Notes for implementation mapping.

## Decision References

- `DEC-0001` — four bounded memory files separate current truth, work, rationale, and evidence.
- `DEC-0002` — `template/` is the canonical distribution source; the separate template repository is a generated mirror.
- `DEC-0003` — ContextRail validation joins one project-native canonical verification pipeline instead of creating a parallel test system.
- `DEC-0004` — template creation and versioned release archives are parallel distribution channels derived from one verified payload.
- `DEC-0005` — external packages are non-canonical staging inputs adopted into local Board and Notes records.
- `DEC-0006` — durable implementation boundaries use one governing task pointer and short current invariant.
