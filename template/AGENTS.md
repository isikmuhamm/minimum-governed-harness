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
- `handoffs/HANDOFF.md` — canonical procedure for adopting external work packages into local records.
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
5. If a package exists under `handoffs/incoming/`, or external handoff adoption was explicitly requested, read `handoffs/HANDOFF.md` and adopt the package into local records before implementation.
6. Select exactly one active or explicitly requested task.
7. Search `project-memory/NOTES.md` by the exact task ID.
8. Read only the matching Notes section and directly related records.
9. Inspect only the code, tests, logs, and configuration needed for that task.
10. Use the agent's native planner for implementation steps.

Do not read all of `HISTORY.md` by default. Search it by exact task or related ID only when prior implementation evidence is needed.

## System model rules

`SYSTEM.md` describes the system as it exists now.

It may contain purpose and scope, components and ownership, primary flows, boundaries and sources of truth, invariants, interfaces, and known limits.

It must not contain active tasks, implementation plans, chronological logs, unresolved design debates, or speculative future architecture presented as current truth.

Open design work belongs in `NOTES.md`. When a decision is accepted and implemented, update the concise current truth in `SYSTEM.md`.

## Work rules

- Search before creating a task, decision, requirement, or risk.
- Reuse the existing identity when the work already exists.
- Keep Board entries short and actionable.
- Put detail and rationale in Notes.
- Keep stable architecture truth in System.
- Do not duplicate full decision text across files.
- Treat raw external handoffs as non-canonical staging inputs.
- Maintain task-linked code trace when a task creates or changes a durable behavior boundary.
- Prefer one small, reversible, verifiable implementation slice.
- Do not broaden scope silently.
- Do not claim completion without evidence.
- Do not assume another reviewer will catch mistakes.

## External handoff adoption

When a specification, assessment, plan, export, or other work package is placed under `handoffs/incoming/`, follow `handoffs/HANDOFF.md` before implementing it.

The adoption step must:

1. search current local records and relevant code before creating identities;
2. preserve external source identifiers as provenance rather than using them as local identities;
3. convert durable requirements, decisions, risks, rationale, acceptance criteria, and source evidence into `NOTES.md`;
4. derive short local `TASK-####` Board entries only for independently verifiable unfinished outcomes;
5. record conflicts instead of silently overriding implemented truth or accepted decisions;
6. run canonical verification before moving or removing the source package.

Do not implement directly from a raw package while bypassing Board and Notes. The package is source evidence; local records become the governed working context.

## Task-linked code trace

Use a short language-native comment to connect durable implementation boundaries back to the local task context:

```text
ContextRail: TASK-####
Invariant: <the current behavior or constraint that must remain true>
```

The task record carries the full rationale, related requirements, decisions, risks, acceptance criteria, and evidence. The comment is a pointer and a concise protection against incorrect local changes; it is not a second specification or a substitute for Git history.

Add or update a trace when a task:

- creates a function, method, class, module, handler, policy, procedure, resource, migration, or principal test whose existence is explained by a durable behavior or constraint;
- changes the current external behavior, domain invariant, state transition, authorization or security boundary, ownership boundary, or deliberate compatibility exception;
- introduces a small but important implementation boundary, even when the function or statement is short.

Place the trace at the smallest stable scope governed by the task:

- before a declaration when the complete symbol is governed by the task;
- immediately before a block or statement when only that narrower behavior is governed;
- before the principal regression test that proves the same invariant when the behavior is testable.

Do not append every task that historically touched a function. Keep the task that best explains the current invariant. Replace the pointer when a later task materially changes that invariant; leave it unchanged for formatting, renaming, performance work, dependency adaptation, or bug fixes that preserve the same behavior contract. Independent current invariants may carry separate pointers at their own smallest scopes.

During refactoring, move, split, update, or remove the trace together with the behavior it governs. Do not add fake fields to commentless formats, generated files, vendor code, lock files, or binaries; record those implementation boundaries in the task's Notes section instead.

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
5. confirm task-linked code traces still point to the correct current task and scope;
6. confirm documentation and project memory match actual behavior;
7. do not use assumption, intention, or a passing unrelated test as evidence.

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

The ContextRail validator checks project-memory governance and task-linked code-reference integrity only. It does not replace native project tests.

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
