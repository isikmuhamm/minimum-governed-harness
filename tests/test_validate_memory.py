from __future__ import annotations
import importlib.util, tempfile, unittest, sys
from pathlib import Path
MODULE_PATH = Path(__file__).resolve().parents[1] / "scripts" / "validate_memory.py"
SPEC = importlib.util.spec_from_file_location("validate_memory", MODULE_PATH)
assert SPEC and SPEC.loader
validate_memory = importlib.util.module_from_spec(SPEC); sys.modules[SPEC.name] = validate_memory; SPEC.loader.exec_module(validate_memory)

class ValidatorTests(unittest.TestCase):
    def make_repo(self, board, notes, history):
        temp = tempfile.TemporaryDirectory(); self.addCleanup(temp.cleanup)
        root = Path(temp.name); memory = root / "project-memory"; memory.mkdir()
        (memory / "BOARD.md").write_text(board, encoding="utf-8")
        (memory / "NOTES.md").write_text(notes, encoding="utf-8")
        (memory / "HISTORY.md").write_text(history, encoding="utf-8")
        return root
    def test_valid_contract(self):
        root = self.make_repo("# Board\n## TASK-0001 — Add login\n- Status: active\n- Related: DEC-0001\n", "# Notes\n## TASK-0001 — Add login\n- Status: active\n- Related: DEC-0001\n## DEC-0001 — Use sessions\n- Status: accepted\n- Related: TASK-0001\n", "# History\n## TASK-0000 — Bootstrap\n- Status: completed\n- Completed: 2026-06-28\n- Related: none\n- Evidence: validator\n")
        self.assertFalse(any(f.level == "ERROR" for f in validate_memory.validate(root)))
    def test_board_history_overlap(self):
        root = self.make_repo("# Board\n## TASK-0001 — Add login\n- Status: active\n- Related: none\n", "# Notes\n## TASK-0001 — Add login\n- Status: active\n- Related: none\n", "# History\n## TASK-0001 — Add login\n- Status: completed\n- Completed: 2026-06-28\n- Related: none\n- Evidence: tests\n")
        self.assertTrue(any("both BOARD.md and HISTORY.md" in f.message for f in validate_memory.validate(root)))
    def test_missing_reference(self):
        root = self.make_repo("# Board\n## TASK-0001 — Add login\n- Status: active\n- Related: DEC-9999\n", "# Notes\n## TASK-0001 — Add login\n- Status: active\n- Related: DEC-9999\n", "# History\n")
        self.assertTrue(any("references missing DEC-9999" in f.message for f in validate_memory.validate(root)))
    def test_orphan_note(self):
        root = self.make_repo("# Board\n", "# Notes\n## TASK-0001 — Add login\n- Status: draft\n- Related: none\n", "# History\n")
        self.assertTrue(any("no Board or History lifecycle record" in f.message for f in validate_memory.validate(root)))
    def test_duplicate_id(self):
        root = self.make_repo("# Board\n## TASK-0001 — Add login\n- Status: active\n- Related: none\n## TASK-0001 — Add logout\n- Status: active\n- Related: none\n", "# Notes\n", "# History\n")
        self.assertTrue(any("duplicate ID TASK-0001" in f.message for f in validate_memory.validate(root)))

if __name__ == "__main__": unittest.main()
