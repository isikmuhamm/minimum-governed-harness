# Board

The short, canonical view of unfinished ContextRail work.

Allowed statuses: `proposed`, `active`, `blocked`.

## TASK-0002 — Add synchronized template and release distribution
- Status: active
- Priority: P0
- Owner: isikmuhamm
- Related: DEC-0004
- Summary: Publish versioned clean release archives in parallel with the GitHub Template Repository while preventing same-version drift.
- Acceptance: CI detects same-version differences; a tag release verifies version metadata, synchronizes the template repository when required, round-trip checks a fresh clone and extracted ZIP, publishes checksum and manifest assets, and creates the GitHub Release only after all equality checks pass.
