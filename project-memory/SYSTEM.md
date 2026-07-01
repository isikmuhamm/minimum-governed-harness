# System

This file describes the current implemented ContextRail development and distribution system.

## Purpose and Scope

ContextRail provides a minimal governed system map and project-memory layer for coding-agent repositories. This repository develops, tests, documents, versions, and publishes the reusable template. It does not manage application requirements or replace project-native verification.

## Components

- `template/` — canonical source for every file distributed to user repositories.
- `project-memory/` — ContextRail's own system model, active work, rationale, and completion evidence.
- `docs/` — public adoption and governance documentation.
- `tests/fixtures/` — deliberately invalid memory examples used to prove validator failures.
- `.github/workflows/validate-memory.yml` — Linux, macOS, and Windows validation plus same-version published-template drift detection.
- `.github/workflows/release.yml` — tag-gated synchronization, archive creation, round-trip verification, checksums, manifest generation, and GitHub Release publication.
- `isikmuhamm/contextrail-template` — clean published mirror used as the GitHub Template Repository.
- GitHub Releases — immutable version announcements and clean downloadable template archives.

## Primary Flows

1. Reusable changes are made under `template/`.
2. Validators and fixtures verify the same governance contract on Linux, macOS, and Windows.
3. Documentation, changelog, and `.contextrail-version` are updated with the behavior change.
4. A `vX.Y.Z` tag pointing to `main` starts the release workflow.
5. The workflow requires the tag, changelog heading, and `.contextrail-version` to agree.
6. The workflow synchronizes `template/` to `isikmuhamm/contextrail-template` when needed and verifies a fresh clone against the source payload.
7. A clean ZIP is built from `template/`, extracted, and compared back to the source before the GitHub Release is created.
8. Users either create a new repository from the clean template or download the matching release archive.

## Boundaries and Sources of Truth

- Reusable distribution payload — `template/`.
- Current ContextRail system model — this file.
- Active ContextRail work — `project-memory/BOARD.md`.
- Task detail and rationale — `project-memory/NOTES.md`.
- Completed evidence — `project-memory/HISTORY.md`.
- Public behavior and adoption claims — `README.md` and `docs/`.
- Published user template — generated mirror at `isikmuhamm/contextrail-template`; it is not independently edited.
- Official versions and downloadable archives — GitHub Releases in `minimum-governed-harness`.

## Invariants

- `template/` is the only canonical source for distributed files.
- The published template contains only files intended to remain in a user's repository.
- The published template excludes this repository's README, license, changelog, contribution guide, fixtures, and development history.
- Linux, macOS, and Windows validators implement the same governance contract.
- The empty clean template passes strict validation.
- Deliberately invalid fixtures fail validation.
- If source and published repositories declare the same `.contextrail-version`, their payloads are byte-equivalent.
- A GitHub Release is created only after the source payload, fresh published-template clone, and extracted release ZIP compare equal.
- Release tag, changelog section, and `.contextrail-version` identify the same semantic version.
- A completed task does not remain on the Board.
- Project-native tests remain authoritative for runtime behavior; ContextRail validation only governs project memory.

## External Interfaces

- GitHub repository `isikmuhamm/contextrail-template`.
- GitHub Releases API and `gh` CLI.
- GitHub Actions runners for Linux, macOS, and Windows.
- Repository secret `CONTEXTRAIL_TEMPLATE_TOKEN` when cross-repository content must be updated.

## Known Limits

- Cross-repository writes require a fine-grained repository token configured as `CONTEXTRAIL_TEMPLATE_TOKEN`; a release can proceed without it only when the published template already matches the canonical payload.
- Existing user repositories do not receive template updates automatically.
- Validator implementations are intentionally OS-native and therefore require parity maintenance across shell and PowerShell.

## Decision References

- `DEC-0001` — four bounded memory files separate current truth, work, rationale, and evidence.
- `DEC-0002` — `template/` is the canonical distribution source; the separate template repository is a generated mirror.
- `DEC-0003` — ContextRail validation joins one project-native canonical verification pipeline instead of creating a parallel test system.
- `DEC-0004` — template creation and versioned release archives are parallel distribution channels derived from one verified payload.
