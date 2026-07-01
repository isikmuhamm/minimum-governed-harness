# Adoption Guide

## New repository

Create a project from the clean template repository:

[`isikmuhamm/contextrail-template`](https://github.com/isikmuhamm/contextrail-template)

The template contains no ContextRail README, license, changelog, fixtures, or development history. Every distributed file is intended to remain in the new project.

On first use, the coding agent should:

1. inspect and preserve the current working tree;
2. discover the language, build, test, lint, static-analysis, smoke, and CI entrypoints;
3. populate `SYSTEM.md` only from repository evidence;
4. record unfinished work in `BOARD.md`;
5. put task detail and durable rationale in `NOTES.md`;
6. integrate the matching ContextRail validator into one canonical verification command;
7. record that command in `AGENTS.md`.

## Existing repository

Copy the clean template payload rather than this development repository. The required payload is:

```text
AGENTS.md
CLAUDE.md
GEMINI.md
.github/copilot-instructions.md
.github/workflows/contextrail.yml
.cursor/rules/00-agents.mdc
project-memory/
scripts/validate-linux.sh
scripts/validate-macos.sh
scripts/validate-windows.ps1
```

Convert existing information by role:

- current implemented architecture and boundaries -> `SYSTEM.md`;
- unfinished tasks -> `BOARD.md`;
- task detail and durable rationale -> `NOTES.md`;
- completed work and verification -> `HISTORY.md`.

Do not migrate every historical note on day one. Start with current truth, active work, and decisions required to continue safely.

## Verification integration

The standalone `.github/workflows/contextrail.yml` is an initial safety net. It validates memory on push and pull request.

When a repository already has established CI:

1. add the matching ContextRail validator to the existing canonical verification job;
2. ensure the local canonical command runs both native project checks and memory validation;
3. remove the standalone ContextRail workflow if it would duplicate the same validation.

Do not create a second independent test system.

## Direct validation commands

Linux:

```sh
sh scripts/validate-linux.sh --strict
```

macOS:

```sh
sh scripts/validate-macos.sh --strict
```

Windows:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\validate-windows.ps1 -Strict
```

The scripts use operating-system-provided utilities and require no project-language runtime.

## Minimal conceptual core

The conceptual core is:

```text
AGENTS.md
project-memory/SYSTEM.md
project-memory/BOARD.md
project-memory/NOTES.md
project-memory/HISTORY.md
```

The published template also includes small tool adapters, OS-native validators, and a minimal CI safety net so users do not need to decide what to delete.
