# Adoption Guide

## New repository

Use this repository as a GitHub template, replace the sample records, adapt `AGENTS.md`, and add project-specific test commands.

## Existing repository

Copy:

```text
AGENTS.md
project-memory/
scripts/validate_memory.py
.github/workflows/validate-memory.yml
```

Migrate only what is needed to continue safely:

- unfinished work to Board;
- task detail and durable rationale to Notes;
- completed work and evidence to History.

Do not migrate every historical note on day one.

## Folder naming

`project-memory/` is domain-neutral. It may be renamed to `business/`, `planning/`, or another existing canonical folder. Update AGENTS, validator configuration, CI, and documentation paths together.
