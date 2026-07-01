# ContextRail Repository Agent Guide

This repository develops and publishes ContextRail.

## Reusable baseline

Read and follow [`template/AGENTS.md`](template/AGENTS.md) as the reusable operating contract. This file adds rules specific to developing ContextRail itself.

## Repository roles

- `template/` — canonical source for every file distributed to user repositories.
- `README.md` and `docs/` — public explanation, adoption, and governance documentation.
- `tests/fixtures/` — deliberately valid or invalid memory examples used to test validators.
- `.github/workflows/validate-memory.yml` — tests validator parity and detects same-version drift between `template/` and the published template repository.
- `.github/workflows/release.yml` — synchronizes the published template, builds and round-trip verifies the release archive, and creates the official GitHub Release.
- `project-memory/` — ContextRail's own current system model and work lifecycle.

## Distribution rules

- Edit reusable files only under `template/`.
- Do not manually maintain a second canonical copy in `contextrail-template`.
- The template repository is a published mirror, not a development source.
- Files outside `template/` must not be copied into user projects unless the adoption documentation explicitly says so.
- A template release must not include this repository's README, license, changelog, contribution guide, test fixtures, or development history.
- A release is valid only when `template/`, `contextrail-template`, and the extracted release ZIP are identical.
- The release tag, changelog section, and `template/.contextrail-version` must name the same version.

## Validator parity

Linux, macOS, and Windows validators implement the same governance contract.

When adding or changing a rule:

1. update the canonical scripts under `template/scripts/`;
2. update all operating-system implementations in the same task;
3. add or update an invalid fixture that proves the rule fails;
4. verify the empty template passes;
5. verify the invalid fixture fails on all three platforms;
6. update public documentation and the changelog.

## Canonical verification

For changes in this repository, the canonical verification is the GitHub Actions workflow `Validate ContextRail distribution`. Locally, run the matching commands for the current OS.

Linux:

```sh
sh template/scripts/validate-linux.sh --root template --strict
sh template/scripts/validate-linux.sh --root . --strict
if sh template/scripts/validate-linux.sh --root tests/fixtures/invalid; then exit 1; fi
```

macOS:

```sh
sh template/scripts/validate-macos.sh --root template --strict
sh template/scripts/validate-macos.sh --root . --strict
if sh template/scripts/validate-macos.sh --root tests/fixtures/invalid; then exit 1; fi
```

Windows:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File template\scripts\validate-windows.ps1 -Root template -Strict
powershell -NoProfile -ExecutionPolicy Bypass -File template\scripts\validate-windows.ps1 -Root . -Strict
powershell -NoProfile -ExecutionPolicy Bypass -File template\scripts\validate-windows.ps1 -Root tests\fixtures\invalid
if ($LASTEXITCODE -eq 0) { exit 1 }
```
