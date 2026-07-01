# System

This file describes the current implemented ContextRail development and distribution system.

## Purpose and Scope

ContextRail provides a minimal governed system map and project-memory layer for coding-agent repositories. This repository develops, tests, documents, and publishes the reusable template. It does not manage application requirements or replace project-native verification.

## Components

- `template/` — canonical source for every file distributed to user repositories.
- `project-memory/` — ContextRail's own system model, active work, rationale, and completion evidence.
- `docs/` — public adoption and governance documentation.
- `tests/fixtures/` — deliberately invalid memory examples used to prove validator failures.
- `.github/workflows/validate-memory.yml` — Linux, macOS, and Windows validation of the template, this repository, and negative fixtures.
- `.github/workflows/publish-template.yml` — release publication from `template/` to `isikmuhamm/contextrail-template` when the required repository secret is configured.
- `isikmuhamm/contextrail-template` — clean published mirror used as the GitHub Template Repository.

## Primary Flows

1. Reusable changes are made under `template/`.
2. Validators and fixtures verify the same governance contract on Linux, macOS, and Windows.
3. Documentation and changelog are updated with the behavior change.
4. A release publishes the exact `template/` payload to `isikmuhamm/contextrail-template`.
5. Users create new repositories from the clean template and integrate ContextRail validation into their project-native verification pipeline.

## Boundaries and Sources of Truth

- Reusable distribution payload — `template/`.
- Current ContextRail system model — this file.
- Active ContextRail work — `project-memory/BOARD.md`.
- Task detail and rationale — `project-memory/NOTES.md`.
- Completed evidence — `project-memory/HISTORY.md`.
- Public behavior and adoption claims — `README.md` and `docs/`.
- Published user template — generated mirror at `isikmuhamm/contextrail-template`; it is not independently edited.

## Invariants

- `template/` is the only canonical source for distributed files.
- The published template contains only files intended to remain in a user's repository.
- The published template excludes this repository's README, license, changelog, contribution guide, fixtures, and development history.
- Linux, macOS, and Windows validators implement the same governance contract.
- The empty clean template passes strict validation.
- Deliberately invalid fixtures fail validation.
- A completed task does not remain on the Board.
- Project-native tests remain authoritative for runtime behavior; ContextRail validation only governs project memory.

## External Interfaces

- GitHub repository `isikmuhamm/contextrail-template`.
- GitHub Actions runners for Linux, macOS, and Windows.
- Repository secret `CONTEXTRAIL_TEMPLATE_TOKEN` for automated cross-repository publication.

## Known Limits

- Automated publication requires a fine-grained repository token configured as `CONTEXTRAIL_TEMPLATE_TOKEN`; GitHub's default workflow token is scoped to this repository and cannot publish to the separate template repository.
- Existing user repositories do not receive template updates automatically.
- Validator implementations are intentionally OS-native and therefore require parity maintenance across shell and PowerShell.

## Decision References

- `DEC-0001` — four bounded memory files separate current truth, work, rationale, and evidence.
- `DEC-0002` — `template/` is the canonical distribution source; the separate template repository is a generated mirror.
- `DEC-0003` — ContextRail validation joins one project-native canonical verification pipeline instead of creating a parallel test system.
