#!/usr/bin/env python3
"""Validate Minimum Governed Harness project-memory files."""
from __future__ import annotations
import argparse, difflib, re, sys
from collections import Counter, defaultdict
from dataclasses import dataclass, field
from datetime import date
from pathlib import Path
from typing import Iterable

ID_PATTERN = re.compile(r"\b(?:TASK|DEC|REQ|RISK)-\d{4}\b")
HEADING_PATTERN = re.compile(r"^##\s+((?:TASK|DEC|REQ|RISK)-\d{4})\s+[—-]\s+(.+?)\s*$")
FIELD_PATTERN = re.compile(r"^-\s+([A-Za-z][A-Za-z ]*):\s*(.*?)\s*$")
DATE_PATTERN = re.compile(r"^\d{4}-\d{2}-\d{2}$")
BOARD_STATUSES = {"proposed", "active", "blocked"}
HISTORY_STATUSES = {"completed", "cancelled"}
NOTE_STATUSES = {"draft", "proposed", "active", "blocked", "accepted", "superseded", "rejected", "completed", "cancelled", "open", "mitigated", "closed"}

@dataclass
class Record:
    record_id: str
    title: str
    path: Path
    line: int
    fields: dict[str, str] = field(default_factory=dict)
    @property
    def status(self) -> str: return self.fields.get("status", "").strip().lower()
    def references(self) -> set[str]:
        refs = set()
        for name in ("related", "supersedes", "replacement"):
            value = self.fields.get(name, "")
            if value.strip().lower() not in {"", "none", "n/a", "-"}: refs.update(ID_PATTERN.findall(value))
        return refs

@dataclass
class Finding:
    level: str
    message: str
    def __str__(self) -> str: return f"{self.level:<5} {self.message}"

def parse_records(path: Path):
    findings, records = [], []
    if not path.exists(): return records, [Finding("ERROR", f"Missing required file: {path}")]
    lines = path.read_text(encoding="utf-8").splitlines()
    current = None
    for index, line in enumerate(lines, 1):
        heading = HEADING_PATTERN.match(line)
        if heading:
            current = Record(heading.group(1), heading.group(2).strip(), path, index)
            records.append(current); continue
        if line.startswith("## ") and ID_PATTERN.search(line) and not heading:
            findings.append(Finding("ERROR", f"{path}:{index}: malformed record heading: {line}"))
        if current:
            field_match = FIELD_PATTERN.match(line)
            if field_match:
                key, value = field_match.group(1).strip().lower(), field_match.group(2).strip()
                if key in current.fields: findings.append(Finding("ERROR", f"{path}:{index}: duplicate field '{key}' in {current.record_id}"))
                current.fields[key] = value
    counts = Counter(r.record_id for r in records)
    for record_id, count in sorted(counts.items()):
        if count > 1:
            locations = ", ".join(str(r.line) for r in records if r.record_id == record_id)
            findings.append(Finding("ERROR", f"{path}: duplicate ID {record_id} at lines {locations}"))
    return records, findings

def normalized_title(title: str) -> str:
    words = re.findall(r"[a-z0-9]+", title.lower())
    stop = {"add", "create", "implement", "update", "fix", "the", "a", "an", "for"}
    return " ".join(w for w in words if w not in stop)

def validate(root: Path):
    memory = root / "project-memory"
    paths = {"board": memory / "BOARD.md", "notes": memory / "NOTES.md", "history": memory / "HISTORY.md"}
    findings, parsed = [], {}
    for role, path in paths.items():
        records, local = parse_records(path); parsed[role] = records; findings.extend(local)
    board, notes, history = parsed["board"], parsed["notes"], parsed["history"]
    for record in board:
        if not record.record_id.startswith("TASK-"): findings.append(Finding("ERROR", f"{record.path}:{record.line}: Board may contain only TASK records"))
        if record.status not in BOARD_STATUSES: findings.append(Finding("ERROR", f"{record.path}:{record.line}: {record.record_id} has invalid Board status '{record.status or 'missing'}'"))
    for record in history:
        if not record.record_id.startswith("TASK-"): findings.append(Finding("ERROR", f"{record.path}:{record.line}: History may contain only TASK records"))
        if record.status not in HISTORY_STATUSES: findings.append(Finding("ERROR", f"{record.path}:{record.line}: {record.record_id} has invalid History status '{record.status or 'missing'}'"))
        completed = record.fields.get("completed", "")
        if record.status == "completed":
            if not DATE_PATTERN.match(completed): findings.append(Finding("ERROR", f"{record.path}:{record.line}: completed {record.record_id} requires Completed: YYYY-MM-DD"))
            else:
                try: date.fromisoformat(completed)
                except ValueError: findings.append(Finding("ERROR", f"{record.path}:{record.line}: invalid completion date '{completed}'"))
            if not record.fields.get("evidence", "").strip(): findings.append(Finding("WARN", f"{record.path}:{record.line}: completed {record.record_id} has no Evidence"))
    for record in notes:
        if record.status and record.status not in NOTE_STATUSES: findings.append(Finding("ERROR", f"{record.path}:{record.line}: {record.record_id} has unsupported Notes status '{record.status}'"))
    board_ids, note_ids, history_ids = {r.record_id for r in board}, {r.record_id for r in notes}, {r.record_id for r in history}
    known_ids = board_ids | note_ids | history_ids
    for record_id in sorted(board_ids & history_ids): findings.append(Finding("ERROR", f"{record_id} exists in both BOARD.md and HISTORY.md"))
    task_note_ids = {r.record_id for r in notes if r.record_id.startswith("TASK-")}
    for record_id in sorted(board_ids - task_note_ids): findings.append(Finding("WARN", f"{record_id} is active on the Board but has no Notes detail"))
    for record_id in sorted(task_note_ids - (board_ids | history_ids)): findings.append(Finding("WARN", f"{record_id} has Notes detail but no Board or History lifecycle record"))
    incoming = defaultdict(set)
    for record in board + notes + history:
        for ref in record.references():
            if ref not in known_ids: findings.append(Finding("ERROR", f"{record.path}:{record.line}: {record.record_id} references missing {ref}"))
            else: incoming[ref].add(record.record_id)
    for record in notes:
        if record.record_id.startswith(("DEC-", "REQ-", "RISK-")) and not incoming.get(record.record_id): findings.append(Finding("WARN", f"{record.record_id} in Notes has no incoming Related/Supersedes reference"))
    active = [r for r in board if r.record_id.startswith("TASK-")]
    for i, left in enumerate(active):
        a = normalized_title(left.title)
        for right in active[i+1:]:
            b = normalized_title(right.title)
            if a and b:
                ratio = difflib.SequenceMatcher(None, a, b).ratio()
                if ratio >= .84: findings.append(Finding("WARN", f"Suspiciously similar active tasks: {left.record_id} '{left.title}' and {right.record_id} '{right.title}' ({ratio:.0%})"))
    if not findings: findings.append(Finding("PASS", "Project memory contract is valid"))
    elif not any(f.level == "ERROR" for f in findings): findings.append(Finding("PASS", f"No errors; {sum(f.level == 'WARN' for f in findings)} warning(s) require review"))
    return findings

def main(argv: Iterable[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path.cwd())
    parser.add_argument("--strict", action="store_true")
    args = parser.parse_args(list(argv) if argv is not None else None)
    findings = validate(args.root.resolve())
    for finding in findings: print(finding)
    errors, warnings = sum(f.level == "ERROR" for f in findings), sum(f.level == "WARN" for f in findings)
    print(f"\nSummary: {errors} error(s), {warnings} warning(s)")
    return 1 if errors else (2 if args.strict and warnings else 0)

if __name__ == "__main__": sys.exit(main())
