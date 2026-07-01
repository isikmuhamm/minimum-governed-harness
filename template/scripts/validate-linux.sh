#!/usr/bin/env sh
set -eu

STRICT=0
ROOT=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --strict) STRICT=1 ;;
    --root)
      shift
      [ "$#" -gt 0 ] || { echo "ERROR --root requires a path" >&2; exit 2; }
      ROOT=$1
      ;;
    *) echo "ERROR unknown argument: $1" >&2; exit 2 ;;
  esac
  shift
done

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
[ -n "$ROOT" ] || ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
ROOT=$(CDPATH= cd -- "$ROOT" && pwd)
MEMORY="$ROOT/project-memory"
TMP=$(mktemp -d "${TMPDIR:-/tmp}/contextrail.XXXXXX")
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
ERRORS="$TMP/errors"
WARNINGS="$TMP/warnings"
: > "$ERRORS"
: > "$WARNINGS"

error() { printf 'ERROR %s\n' "$*" | tee -a "$ERRORS" >&2; }
warn() { printf 'WARN  %s\n' "$*" | tee -a "$WARNINGS" >&2; }

SYSTEM="$MEMORY/SYSTEM.md"
BOARD="$MEMORY/BOARD.md"
NOTES="$MEMORY/NOTES.md"
HISTORY="$MEMORY/HISTORY.md"

for file in "$SYSTEM" "$BOARD" "$NOTES" "$HISTORY"; do
  [ -f "$file" ] || error "Missing required file: ${file#"$ROOT/"}"
done
[ ! -s "$ERRORS" ] || exit 1

for heading in \
  "## Purpose and Scope" \
  "## Components" \
  "## Primary Flows" \
  "## Boundaries and Sources of Truth" \
  "## Invariants" \
  "## External Interfaces" \
  "## Known Limits"
do
  grep -Fqx "$heading" "$SYSTEM" || error "SYSTEM.md missing section: $heading"
done

if grep -nE '^## (TASK|DEC|REQ|RISK)-[0-9]{4}([[:space:]]|$)' "$SYSTEM" > "$TMP/system-records"; then
  while IFS= read -r line; do error "SYSTEM.md must not contain lifecycle records: $line"; done < "$TMP/system-records"
fi

system_lines=$(wc -l < "$SYSTEM" | tr -d ' ')
[ "$system_lines" -le 250 ] || warn "SYSTEM.md has $system_lines lines; review whether it is still a bounded system map"

extract_ids() {
  awk '/^## (TASK|DEC|REQ|RISK)-[0-9][0-9][0-9][0-9][[:space:]]/ {print $2}' "$1"
}

extract_ids "$BOARD" > "$TMP/board.ids"
extract_ids "$NOTES" > "$TMP/notes.ids"
extract_ids "$HISTORY" > "$TMP/history.ids"

for pair in "Board:$TMP/board.ids" "Notes:$TMP/notes.ids" "History:$TMP/history.ids"; do
  name=${pair%%:*}
  file=${pair#*:}
  sort "$file" | uniq -d | while IFS= read -r id; do
    [ -n "$id" ] && error "Duplicate ID in $name: $id"
  done
done

awk '
function emit(level,msg){print level " " msg}
function required(name,value){if(value=="") emit("E",id " missing required field: " name)}
function flush(){
  if(id=="") return
  if(id !~ /^TASK-[0-9][0-9][0-9][0-9]$/) emit("E","Board may contain only TASK records: " id)
  required("Status",status); required("Priority",priority); required("Owner",owner)
  required("Related",related); required("Summary",summary); required("Acceptance",acceptance)
  if(status!="" && status !~ /^(proposed|active|blocked)$/) emit("E",id " has invalid Board status: " status)
}
/^## (TASK|DEC|REQ|RISK)-[0-9][0-9][0-9][0-9][[:space:]]/ {flush(); id=$2; status=priority=owner=related=summary=acceptance=""; next}
id!="" && /^- Status:[[:space:]]*/ {status=$0; sub(/^- Status:[[:space:]]*/,"",status); next}
id!="" && /^- Priority:[[:space:]]*/ {priority=$0; sub(/^- Priority:[[:space:]]*/,"",priority); next}
id!="" && /^- Owner:[[:space:]]*/ {owner=$0; sub(/^- Owner:[[:space:]]*/,"",owner); next}
id!="" && /^- Related:[[:space:]]*/ {related=$0; sub(/^- Related:[[:space:]]*/,"",related); next}
id!="" && /^- Summary:[[:space:]]*/ {summary=$0; sub(/^- Summary:[[:space:]]*/,"",summary); next}
id!="" && /^- Acceptance:[[:space:]]*/ {acceptance=$0; sub(/^- Acceptance:[[:space:]]*/,"",acceptance); next}
END {flush()}
' "$BOARD" | while IFS= read -r finding; do
  case "$finding" in
    'E '*) error "${finding#E }" ;;
    'W '*) warn "${finding#W }" ;;
  esac
done

awk '
function emit(level,msg){print level " " msg}
function required(name,value){if(value=="") emit("E",id " missing required field: " name)}
function flush(){
  if(id=="") return
  required("Status",status); required("Related",related); required("Last updated",updated)
  if(id ~ /^DEC-/ && status=="accepted" && reflected=="") emit("W",id " is accepted but has no Reflected in field")
}
/^## (TASK|DEC|REQ|RISK)-[0-9][0-9][0-9][0-9][[:space:]]/ {flush(); id=$2; status=related=updated=reflected=""; next}
id!="" && /^- Status:[[:space:]]*/ {status=$0; sub(/^- Status:[[:space:]]*/,"",status); next}
id!="" && /^- Related:[[:space:]]*/ {related=$0; sub(/^- Related:[[:space:]]*/,"",related); next}
id!="" && /^- Last updated:[[:space:]]*/ {updated=$0; sub(/^- Last updated:[[:space:]]*/,"",updated); next}
id!="" && /^- Reflected in:[[:space:]]*/ {reflected=$0; sub(/^- Reflected in:[[:space:]]*/,"",reflected); next}
END {flush()}
' "$NOTES" | while IFS= read -r finding; do
  case "$finding" in
    'E '*) error "${finding#E }" ;;
    'W '*) warn "${finding#W }" ;;
  esac
done

awk '
function emit(level,msg){print level " " msg}
function required(name,value){if(value=="") emit("E",id " missing required field: " name)}
function validdate(value){return value ~ /^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$/}
function flush(){
  if(id=="") return
  if(id !~ /^TASK-[0-9][0-9][0-9][0-9]$/) emit("E","History may contain only TASK records: " id)
  required("Status",status); required("Related",related); required("Evidence",evidence); required("Outcome",outcome)
  if(status!="" && status !~ /^(completed|cancelled)$/) emit("E",id " has invalid History status: " status)
  if(status=="completed" && !validdate(completed)) emit("E",id " requires Completed: YYYY-MM-DD")
  if(status=="cancelled" && !validdate(cancelled)) emit("E",id " requires Cancelled: YYYY-MM-DD")
}
/^## (TASK|DEC|REQ|RISK)-[0-9][0-9][0-9][0-9][[:space:]]/ {flush(); id=$2; status=related=evidence=outcome=completed=cancelled=""; next}
id!="" && /^- Status:[[:space:]]*/ {status=$0; sub(/^- Status:[[:space:]]*/,"",status); next}
id!="" && /^- Related:[[:space:]]*/ {related=$0; sub(/^- Related:[[:space:]]*/,"",related); next}
id!="" && /^- Evidence:[[:space:]]*/ {evidence=$0; sub(/^- Evidence:[[:space:]]*/,"",evidence); next}
id!="" && /^- Outcome:[[:space:]]*/ {outcome=$0; sub(/^- Outcome:[[:space:]]*/,"",outcome); next}
id!="" && /^- Completed:[[:space:]]*/ {completed=$0; sub(/^- Completed:[[:space:]]*/,"",completed); next}
id!="" && /^- Cancelled:[[:space:]]*/ {cancelled=$0; sub(/^- Cancelled:[[:space:]]*/,"",cancelled); next}
END {flush()}
' "$HISTORY" | while IFS= read -r finding; do
  case "$finding" in
    'E '*) error "${finding#E }" ;;
    'W '*) warn "${finding#W }" ;;
  esac
done

sort -u "$TMP/board.ids" > "$TMP/board.unique"
sort -u "$TMP/history.ids" > "$TMP/history.unique"
awk '/^TASK-/' "$TMP/notes.ids" | sort -u > "$TMP/note-tasks.unique"
cat "$TMP/board.unique" "$TMP/history.unique" | sort -u > "$TMP/lifecycle.unique"

comm -12 "$TMP/board.unique" "$TMP/history.unique" | while IFS= read -r id; do
  [ -n "$id" ] && error "$id exists in both BOARD.md and HISTORY.md"
done
comm -23 "$TMP/board.unique" "$TMP/note-tasks.unique" | while IFS= read -r id; do
  [ -n "$id" ] && warn "$id is on the Board but has no Notes detail"
done
comm -23 "$TMP/note-tasks.unique" "$TMP/lifecycle.unique" | while IFS= read -r id; do
  [ -n "$id" ] && warn "$id has Notes detail but no Board or History lifecycle record"
done

cat "$TMP/board.ids" "$TMP/notes.ids" "$TMP/history.ids" | sort -u > "$TMP/known.ids"
awk '
/^## (TASK|DEC|REQ|RISK)-[0-9][0-9][0-9][0-9][[:space:]]/ {source=$2; next}
source!="" && /^- (Related|Supersedes|Replacement):/ {
  line=$0
  gsub(/`|,|;|\(|\)|\[|\]/," ",line)
  count=split(line,parts,/[^A-Z0-9-]+/)
  for(i=1;i<=count;i++) if(parts[i] ~ /^(TASK|DEC|REQ|RISK)-[0-9][0-9][0-9][0-9]$/) print source,parts[i]
}
' "$BOARD" "$NOTES" "$HISTORY" > "$TMP/references"

awk 'NR==FNR {known[$1]=1; next} !known[$2] {print $1,$2}' "$TMP/known.ids" "$TMP/references" | while read -r source target; do
  error "$source references missing $target"
done

error_count=$(wc -l < "$ERRORS" | tr -d ' ')
warning_count=$(wc -l < "$WARNINGS" | tr -d ' ')
printf '\nSummary: %s error(s), %s warning(s)\n' "$error_count" "$warning_count"

[ "$error_count" -eq 0 ] || exit 1
[ "$STRICT" -eq 0 ] || [ "$warning_count" -eq 0 ] || exit 2
echo "PASS  Project memory contract is valid"
