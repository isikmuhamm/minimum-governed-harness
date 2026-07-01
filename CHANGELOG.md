# Changelog

All notable changes to ContextRail are documented here.

## 1.0.0

- Added a generic `handoffs/HANDOFF.md` adoption contract with `incoming/` and `processed/` staging directories.
- Defined how external specifications, assessments, plans, and exports are deduplicated and converted into local Notes records and independently verifiable Board tasks before implementation.
- Added a minimal language-native code trace contract using `ContextRail: TASK-####` plus a short current invariant.
- Defined trace placement for complete symbols, narrow blocks, statements, and principal regression tests without storing full code history in comments.
- Added validator checks for code markers that reference missing lifecycle or Notes records and for markers without a nearby non-empty invariant.
- Added deterministic normalized-title checks that reject duplicate record identities and inconsistent titles for the same stable ID.
- Added a valid implementation-and-test trace fixture and exact CI assertions for duplicate titles, orphan Notes details, and broken code pointers on Linux, macOS, and Windows.
- Declared the four bounded memory roles, generic handoff intake, task-linked code trace, OS-native validation, canonical verification integration, and synchronized distribution as the stable ContextRail 1.0 contract.

## 0.5.0

- Split the development repository from the clean user-project template distribution.
- Added `template/` as the canonical source for the published `contextrail-template` repository.
- Added root-cause-before-patch guidance to prevent accumulating input-specific guards and `if/else` exceptions.
- Added independent self-review and evidence-grounded completion rules.
- Added controlled handling for incidental bugs and risks without silent scope expansion.
- Added first-adoption discovery and canonical verification integration.
- Added required-field validation for Board, Notes, and History records.
- Added a minimal template CI workflow while keeping validator development fixtures and three-OS testing in the source repository.
- Added synchronized GitHub Releases with a clean ZIP, archive checksum, file manifest, published-template round-trip verification, and same-version drift detection.
- Hardened Windows validation for Windows PowerShell 5.1 compatibility.

## 0.4.0

- Removed the Python/runtime dependency from harness validation.
- Added OS-native validators for Linux, macOS, and Windows.
- Added Claude Code, Gemini CLI, GitHub Copilot, and Cursor adapters that redirect to `AGENTS.md`.
- Added valid/invalid fixture checks and a three-platform GitHub Actions workflow.
- Expanded the public documentation and ContextRail branding.

## 0.3.0

- Added a cross-platform Python check runner and project-native check configuration.
- Added Linux, Windows CMD, and PowerShell wrapper experiments.

## 0.2.0

- Added `SYSTEM.md` to separate implemented system truth from active work and design discussion.
- Expanded adoption and governance documentation.

## 0.1.0

- Added the initial `BOARD.md`, `NOTES.md`, and `HISTORY.md` lifecycle model.
- Added the canonical `AGENTS.md` operating guide.
