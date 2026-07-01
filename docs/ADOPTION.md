# Adoption Guide

## New repository

Use this repository as a GitHub template, then:

1. replace the sample System, Board, Notes, and History content,
2. adapt project-specific rules in `AGENTS.md`,
3. keep adapter files as short redirects,
4. add the project's own build and test commands to `AGENTS.md`,
5. run the validator for the current operating system.

## Existing repository

Copy:

```text
AGENTS.md
CLAUDE.md
GEMINI.md
project-memory/
scripts/validate-linux.sh
scripts/validate-macos.sh
scripts/validate-windows.ps1
.github/copilot-instructions.md
.cursor/rules/00-agents.mdc
.github/workflows/validate-memory.yml
```

Convert existing information by role:

- current implemented architecture and boundaries -> `SYSTEM.md`,
- unfinished tasks -> `BOARD.md`,
- task detail and durable rationale -> `NOTES.md`,
- completed work and verification -> `HISTORY.md`.

Do not migrate every historical note on day one. Start with the current system map, active work, and decisions needed to continue safely.

## Validation commands

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

No project-language runtime is required. The scripts use utilities included with the operating system.

## Gradual adoption

The smallest useful adoption is:

```text
SYSTEM.md
BOARD.md
NOTES.md
HISTORY.md
AGENTS.md
```

Avoid semantic search, graph databases, orchestration, or file-per-feature structures before measured need appears.
