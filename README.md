# ContextRail — Minimum Governed Harness

**ContextRail** is the project name; **Minimum Governed Harness** describes the pattern.

A lightweight, repo-local system map and project-memory harness for coding agents.

## v0.3 cross-platform runner experiment

This version adds a canonical Python check runner plus thin Linux, Windows CMD, and PowerShell wrappers. Project-native checks can be declared in `harness.json` while the core memory model remains `SYSTEM`, `BOARD`, `NOTES`, and `HISTORY`.

The wrappers intentionally contain no separate validation logic; they all delegate to `scripts/check.py`.

```text
AGENTS -> SYSTEM -> BOARD -> exact TASK in NOTES -> code/tests -> HISTORY/SYSTEM
```

This experiment is retained in history to show the path toward the later runtime-free OS-native validators.

See [docs/GOVERNANCE.md](docs/GOVERNANCE.md).

## License

MIT
