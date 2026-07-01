# Changelog

All notable changes to ContextRail are documented here.

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
