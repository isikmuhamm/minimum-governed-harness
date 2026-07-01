# Contributing

ContextRail is intentionally small. Changes should solve a demonstrated governance or retrieval problem without turning the repository into a project-management or orchestration framework.

Before proposing a change:

1. explain the concrete failure mode;
2. show why the existing four memory roles cannot handle it;
3. prefer a rule or validator improvement over a new artifact;
4. keep `AGENTS.md` canonical and adapters thin;
5. run the strict validator for your operating system;
6. confirm the invalid fixture is still rejected.

Platform-specific validators should preserve the same contract. A rule added to one validator must be implemented in the others in the same change.
