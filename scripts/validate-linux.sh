#!/usr/bin/env sh
set -eu
STRICT=0
ROOT=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --strict) STRICT=1 ;;
    --root) shift; [ "$#" -gt 0 ] || { echo "ERROR --root requires a path" >&2; exit 2; }; ROOT=$1 ;;
    *) echo "ERROR unknown argument: $1" >&2; exit 2 ;;
  esac
  shift
done
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
[ -n "$ROOT" ] || ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
MEMORY="$ROOT/project-memory"
TMP=$(mktemp -d "${TMPDIR:-/tmp}/contextrail.XXXXXX")
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
ERRORS="$TMP/errors"; WARNINGS="$TMP/warnings"; : > "$ERRORS"; : > "$WARNINGS"
error(){ printf 'ERROR %s\n' "$*" | tee -a "$ERRORS" >&2; }
warn(){ printf 'WARN  %s\n' "$*" | tee -a "$WARNINGS" >&2; }
SYSTEM="$MEMORY/SYSTEM.md"; BOARD="$MEMORY/BOARD.md"; NOTES="$MEMORY/NOTES.md"; HISTORY="$MEMORY/HISTORY.md"
for f in "$SYSTEM" "$BOARD" "$NOTES" "$HISTORY"; do [ -f "$f" ] || error "Missing required file: ${f#"$ROOT/"}"; done
[ ! -s "$ERRORS" ] || exit 1
for h in "## Purpose and Scope" "## Components" "## Primary Flows" "## Boundaries and Sources of Truth" "## Invariants" "## External Interfaces" "## Known Limits"; do grep -Fqx "$h" "$SYSTEM" || error "SYSTEM.md missing section: $h"; done
if grep -nE '^## (TASK|DEC|REQ|RISK)-[0-9]{4}([[:space:]]|$)' "$SYSTEM" > "$TMP/system-records"; then while IFS= read -r x; do error "SYSTEM.md must not contain lifecycle records: $x"; done < "$TMP/system-records"; fi
extract(){ awk '/^## (TASK|DEC|REQ|RISK)-[0-9][0-9][0-9][0-9][[:space:]]/ {print $2}' "$1"; }
extract "$BOARD" > "$TMP/board"; extract "$NOTES" > "$TMP/notes"; extract "$HISTORY" > "$TMP/history"
for pair in "Board:$TMP/board" "Notes:$TMP/notes" "History:$TMP/history"; do name=${pair%%:*}; file=${pair#*:}; sort "$file" | uniq -d | while IFS= read -r id; do [ -n "$id" ] && error "Duplicate ID in $name: $id"; done; done
awk '
function flush(){if(id=="")return;if(id!~/^TASK-[0-9][0-9][0-9][0-9]$/)print "Board may contain only TASK records: " id;if(status!~/^(proposed|active|blocked)$/)print id " has invalid Board status: " (status==""?"missing":status)}
/^## (TASK|DEC|REQ|RISK)-[0-9][0-9][0-9][0-9][[:space:]]/{flush();id=$2;status="";next}
id!=""&&/^- Status:[[:space:]]*/{status=$0;sub(/^- Status:[[:space:]]*/,"",status)} END{flush()}' "$BOARD" | while IFS= read -r x; do error "$x"; done
awk '
function flush(){if(id=="")return;if(id!~/^TASK-[0-9][0-9][0-9][0-9]$/)print "E History may contain only TASK records: " id;if(status!~/^(completed|cancelled)$/)print "E " id " has invalid History status: " (status==""?"missing":status);if(status=="completed"&&completed!~/^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$/)print "E " id " requires Completed: YYYY-MM-DD";if(status=="completed"&&evidence=="")print "W " id " has no Evidence"}
/^## (TASK|DEC|REQ|RISK)-[0-9][0-9][0-9][0-9][[:space:]]/{flush();id=$2;status="";completed="";evidence="";next}
id!=""&&/^- Status:/{status=$0;sub(/^- Status:[[:space:]]*/,"",status)} id!=""&&/^- Completed:/{completed=$0;sub(/^- Completed:[[:space:]]*/,"",completed)} id!=""&&/^- Evidence:/{evidence=$0;sub(/^- Evidence:[[:space:]]*/,"",evidence)} END{flush()}' "$HISTORY" | while IFS= read -r x; do case "$x" in 'E '*) error "${x#E }";; 'W '*) warn "${x#W }";; esac; done
sort -u "$TMP/board" > "$TMP/b"; sort -u "$TMP/history" > "$TMP/h"; awk '/^TASK-/' "$TMP/notes" | sort -u > "$TMP/n"; cat "$TMP/b" "$TMP/h" | sort -u > "$TMP/lifecycle"
comm -12 "$TMP/b" "$TMP/h" | while IFS= read -r id; do [ -n "$id" ] && error "$id exists in both BOARD.md and HISTORY.md"; done
comm -23 "$TMP/b" "$TMP/n" | while IFS= read -r id; do [ -n "$id" ] && warn "$id is on the Board but has no Notes detail"; done
comm -23 "$TMP/n" "$TMP/lifecycle" | while IFS= read -r id; do [ -n "$id" ] && warn "$id has Notes detail but no lifecycle record"; done
cat "$TMP/board" "$TMP/notes" "$TMP/history" | sort -u > "$TMP/known"
awk '/^## (TASK|DEC|REQ|RISK)-[0-9][0-9][0-9][0-9][[:space:]]/{source=$2;next} source!=""&&/^- (Related|Supersedes|Replacement):/{line=$0;gsub(/`|,|;|\(|\)|\[|\]/," ",line);n=split(line,a,/[^A-Z0-9-]+/);for(i=1;i<=n;i++)if(a[i]~/^(TASK|DEC|REQ|RISK)-[0-9][0-9][0-9][0-9]$/)print source,a[i]}' "$BOARD" "$NOTES" "$HISTORY" > "$TMP/refs"
awk 'NR==FNR{k[$1]=1;next}!k[$2]{print $1,$2}' "$TMP/known" "$TMP/refs" | while read -r s t; do error "$s references missing $t"; done
e=$(wc -l < "$ERRORS" | tr -d ' '); w=$(wc -l < "$WARNINGS" | tr -d ' '); printf '\nSummary: %s error(s), %s warning(s)\n' "$e" "$w"
[ "$e" -eq 0 ] || exit 1
[ "$STRICT" -eq 0 ] || [ "$w" -eq 0 ] || exit 2
echo "PASS  Project memory contract is valid"
