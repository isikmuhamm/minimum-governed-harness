# Adoption Guide

## New repository

Create a project from the clean template repository:

[`isikmuhamm/contextrail-template`](https://github.com/isikmuhamm/contextrail-template)

The template contains no ContextRail README, license, changelog, fixtures, or development history. Every distributed file is intended to remain in the new project.

On first use, the coding agent should:

1. inspect and preserve the current working tree;
2. discover the language, build, test, lint, static-analysis, smoke, and CI entrypoints;
3. inspect `handoffs/incoming/` and adopt any explicitly provided external package through `handoffs/HANDOFF.md`;
4. populate `SYSTEM.md` only from repository evidence;
5. record unfinished work in `BOARD.md`;
6. put task detail, durable rationale, requirements, decisions, risks, and source provenance in `NOTES.md`;
7. integrate the matching ContextRail validator into one canonical verification command;
8. record that command in `AGENTS.md`.

## Existing repository or pinned version

Download the clean archive from the official GitHub Release in `minimum-governed-harness`:

```text
contextrail-template-vX.Y.Z.zip
```

The release also provides:

```text
contextrail-template-vX.Y.Z.zip.sha256
contextrail-template-vX.Y.Z.manifest.sha256
```

Verify the archive checksum before extracting it. The per-file manifest can be used to audit or compare installed files later.

Copy or extract the clean payload into the repository root. The required payload is:

```text
AGENTS.md
CLAUDE.md
GEMINI.md
.contextrail-version
.github/copilot-instructions.md
.github/workflows/contextrail.yml
.cursor/rules/00-agents.mdc
handoffs/HANDOFF.md
handoffs/incoming/.gitkeep
handoffs/processed/.gitkeep
project-memory/
scripts/validate-linux.sh
scripts/validate-macos.sh
scripts/validate-windows.ps1
```

Convert existing information by role:

- current implemented architecture and boundaries -> `SYSTEM.md`;
- unfinished tasks -> `BOARD.md`;
- task detail and durable rationale -> `NOTES.md`;
- completed work and verification -> `HISTORY.md`;
- external specifications and work packages awaiting adoption -> `handoffs/incoming/`.

Do not migrate every historical note on day one. Start with current truth, active work, decisions required to continue safely, and any external package that directly governs the requested implementation.

## External package adoption

Place each external package under one stable path:

```text
handoffs/incoming/<package-id>/
```

Then instruct the coding agent to follow `handoffs/HANDOFF.md` before implementation. The agent should:

1. search current local records and relevant code;
2. detect overlap and conflicts;
3. preserve external identifiers as provenance;
4. convert durable requirements, decisions, risks, acceptance criteria, and rationale into Notes;
5. create one short local task per independently verifiable unfinished outcome;
6. run canonical validation;
7. move the source package to `processed/` only when retention remains useful, or remove it according to repository policy.

The raw package is not project memory. Board and Notes become the governed working context.

## Task-linked code trace adoption

Use task-linked comments only for durable behavior boundaries, not every edited line.

```text
ContextRail: TASK-0042
Invariant: Persistent mutation requires explicit authorization.
```

Place the comment before the declaration when the task governs the entire symbol, or before the narrow block or statement when it governs only that behavior. Add the same task marker to the principal regression test when the behavior is testable.

The marker identifies the task that best explains the current behavior. Do not append every task that historically touched the function. Mechanical refactors that preserve the behavior contract do not replace the pointer.

Commentless formats, generated output, vendor sources, binaries, and lock files should not be modified for traceability. Record those boundaries in the corresponding Notes task instead.

## Template and release equivalence

The GitHub Template Repository and versioned release ZIP are derived from the same canonical `template/` directory.

For each release, automation verifies:

1. the version tag, changelog heading, and `.contextrail-version` agree;
2. a fresh clone of `contextrail-template` matches the canonical payload;
3. the generated ZIP extracts to the same payload;
4. checksums and the file manifest are attached to the release.

When the source and published repositories declare the same version, normal CI fails on any file difference.

## Verification integration

The standalone `.github/workflows/contextrail.yml` is an initial safety net. It validates memory and task-linked code-reference integrity on push and pull request.

When a repository already has established CI:

1. add the matching ContextRail validator to the existing canonical verification job;
2. ensure the local canonical command runs both native project checks and ContextRail validation;
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

The bounded project-memory core remains:

```text
AGENTS.md
project-memory/SYSTEM.md
project-memory/BOARD.md
project-memory/NOTES.md
project-memory/HISTORY.md
```

`handoffs/HANDOFF.md` is the generic external-intake contract, and native code comments provide minimal implementation pointers into that core. Neither creates another canonical memory store.

The published template also includes small tool adapters, OS-native validators, a minimal CI safety net, and empty handoff staging directories so users do not need to design the integration surface themselves.
