# Agent Operating Guide

This repository uses ContextRail, a minimum governed harness for repo-local system context and project memory.

## Canonical instruction file

This file is the canonical operating guide for coding agents.

Tool-specific entry files such as `CLAUDE.md`, `GEMINI.md`, Copilot instructions, and Cursor rules must only direct the tool here. Do not duplicate or override operating rules across adapters.

## Source roles

- `project-memory/SYSTEM.md` — canonical current system model.
- `project-memory/BOARD.md` — canonical unfinished work queue.
- `project-memory/NOTES.md` — task detail, rationale, decisions, requirements, and risks.
- `project-memory/HISTORY.md` — canonical completion and cancellation evidence.
- Source code and native project tests — canonical runtime behavior.
- README and user-facing documentation — canonical public claims.

## First adoption bootstrap

When ContextRail is newly added to an existing repository:

1. Inspect the working tree and preserve existing user changes.
2. Discover the repository's language, build system, tests, linting, static analysis, and CI entrypoints.
3. Populate `SYSTEM.md` only from evidence in code, configuration, tests, and existing documentation. Mark unknown areas as `Not documented yet`; do not invent architecture.
4. Record only current unfinished work in `BOARD.md`.
5. Put durable rationale and open design detail in `NOTES.md`.
6. Keep `HISTORY.md` empty unless completion evidence already exists.
7. Integrate the operating-system-appropriate ContextRail validator into the repository's existing verification pipeline.
8. Define one canonical verification command in the Project Verification section below.
9. If the repository has no verification pipeline yet, use the matching ContextRail validator as the temporary canonical command and create a task to establish native project verification.
10. If the ContextRail-only GitHub workflow duplicates an established project CI job, move the validator step into that job and remove the standalone workflow.

## Session bootstrap

1. Inspect the working tree before changing anything.
2. Read this file.
3. Read `project-memory/SYSTEM.md` once as the bounded system map.
4. Read `project-memory/BOARD.md`.
5. Select exactly one active or explicitly requested task.
6. Search `project-memory/NOTES.md` by the exact task ID.
7. Read only the matching Notes section and directly related records.
8. Inspect only the code, tests, logs, and configuration needed for that task.
9. Use the agent's native planner for implementation steps.

Do not read all of `HISTORY.md` by default. Search it by exact task or related ID only when prior implementation evidence is needed.

## System model rules

`SYSTEM.md` describes the system as it exists now.

It may contain purpose and scope, components and ownership, primary flows, boundaries and sources of truth, invariants, external interfaces, and known limits.

It must not contain active tasks, implementation plans, chronological logs, unresolved design debates, or speculative future architecture presented as current truth.

Open design work belongs in `NOTES.md`. When a decision is accepted and implemented, update the concise current truth in `SYSTEM.md`.

## Work rules

- Search before creating a task, decision, requirement, or risk.
- Reuse the existing identity when the work already exists.
- Keep Board entries short and actionable.
- Put detail and rationale in Notes.
- Keep stable architecture truth in System.
- Do not duplicate full decision text across files.
- Prefer one small, reversible, verifiable implementation slice.
- Do not broaden scope silently.
- Do not claim completion without evidence.
- Do not assume another reviewer will catch mistakes.

## Root cause before patch

When fixing a defect, do not default to an input-specific guard or one-off condition.

Before editing, identify:

1. the observed symptom;
2. the underlying cause;
3. the missing or violated invariant, domain rule, state transition, or ownership boundary;
4. the correct layer that owns the fix;
5. other inputs or states in the same failure class;
6. a test that proves the behavior class, not only the reported example.

Prefer a central rule, state transition, policy, parser contract, or handler correction over scattered phrase checks and accumulating `if/else` exceptions. A narrow guard is acceptable only when the domain itself is genuinely narrow and the reason is documented.

## Independent review

Act as if no one else will catch the mistake before it reaches the user.

After implementation and before claiming completion:

1. review the diff as an independent reviewer, not as its author;
2. verify each acceptance criterion against code, tests, logs, or observable output;
3. state what the tests prove and what they do not prove;
4. check edge cases, failure paths, security implications, and relevant `SYSTEM.md` invariants;
5. confirm documentation and project memory match actual behavior;
6. do not use assumption, intention, or a passing unrelated test as evidence.

## Incidental findings

If another bug, risk, smell, or surprising behavior becomes visible while reading code or logs, report it with concrete evidence.

Do not silently expand the current task to fix it. Add or propose a separate `TASK-####` or `RISK-####` record unless it is:

- a security vulnerability;
- a data-loss risk;
- a problem that invalidates the current task's result;
- a failure that prevents meaningful build or test verification.

Even in those cases, explain the scope change before making it.

## Project Verification

Canonical verification command:

```text
Not configured yet.
```

Until the command is configured, run exactly one matching ContextRail validator:

### Linux

```sh
sh scripts/validate-linux.sh --strict
```

### macOS

```sh
sh scripts/validate-macos.sh --strict
```

### Windows

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\validate-windows.ps1 -Strict
```

On the first substantive coding task, discover the existing native verification pipeline and add the matching ContextRail validator to it. Record the resulting single command above.

The canonical verification command should run the relevant project tests, build, lint, static analysis, scenario or smoke checks, and ContextRail validation as appropriate. Do not create a second parallel test system when an established verification entrypoint already exists.

The ContextRail validator checks project-memory governance only. It does not replace native project tests.

## Creating work

Before creating a record, search titles, keywords, likely IDs, and related code.

1. Add one `TASK-####` entry to `BOARD.md`.
2. Add the matching detail entry to `NOTES.md` when detail is needed.
3. Add or reference related `DEC-####`, `REQ-####`, or `RISK-####` records.
4. Run the canonical verification command.

## Completing work

1. Implement and verify the task using the project's native toolchain.
2. Perform the independent review.
3. Remove the task from `BOARD.md`.
4. Update its detail and related records in `NOTES.md`.
5. Add completion or cancellation evidence to `HISTORY.md`.
6. Update `SYSTEM.md` when current architecture, flow, interface, ownership, or invariants changed.
7. Update public docs when user-visible behavior changed.
8. Run the repository's canonical verification command.
9. Do not mark the task complete while verification is failing or evidence is incomplete.
