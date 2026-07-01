#!/usr/bin/env python3
"""Cross-platform check entrypoint for Minimum Governed Harness."""
from __future__ import annotations
import argparse, json, os, subprocess, sys
from pathlib import Path
from typing import Any

def run_command(name: str, argv: list[str], cwd: Path) -> int:
    print(f"\n==> {name}")
    print("    " + " ".join(argv))
    try:
        completed = subprocess.run(argv, cwd=cwd, check=False)
    except FileNotFoundError:
        print(f"ERROR: executable not found: {argv[0]}", file=sys.stderr)
        return 127
    if completed.returncode != 0:
        print(f"FAIL: {name} exited with {completed.returncode}", file=sys.stderr)
    else:
        print(f"PASS: {name}")
    return completed.returncode

def load_config(path: Path) -> dict[str, Any]:
    if not path.exists():
        return {"version": 1, "project_checks": []}
    data = json.loads(path.read_text(encoding="utf-8"))
    if data.get("version") != 1:
        raise ValueError("harness.json must contain version: 1")
    checks = data.get("project_checks", [])
    if not isinstance(checks, list):
        raise ValueError("project_checks must be a list")
    return data

def command_for_platform(check: dict[str, Any]) -> list[str]:
    key = "windows_command" if os.name == "nt" else "posix_command"
    command = check.get(key, check.get("command"))
    if not isinstance(command, list) or not command or not all(isinstance(item, str) and item for item in command):
        raise ValueError(f"Check '{check.get('name', '<unnamed>')}' requires a command array")
    return command

def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--skip-project", action="store_true")
    args = parser.parse_args()
    root = args.root.resolve()
    commands = [
        ("Harness unit tests", [sys.executable, "-m", "unittest", "discover", "-s", "tests", "-v"], root),
        ("Project-memory validation", [sys.executable, "scripts/validate_memory.py", "--strict"], root),
    ]
    if not args.skip_project:
        try:
            for check in load_config(root / "harness.json").get("project_checks", []):
                commands.append((f"Project check: {check['name']}", command_for_platform(check), root / check.get("cwd", ".")))
        except (ValueError, KeyError, json.JSONDecodeError) as exc:
            print(f"CONFIG ERROR: {exc}", file=sys.stderr)
            return 2
    for name, argv, cwd in commands:
        code = run_command(name, argv, cwd)
        if code != 0:
            return code
    print("\nAll checks passed.")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
