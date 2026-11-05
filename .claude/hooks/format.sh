#!/usr/bin/env bash
# PostToolUse hook: format and lint the file Claude just edited.
# Prints nothing on success. On problems, prints them to stderr and exits 2 so Claude sees them.
set -uo pipefail

file=$(python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_input",{}).get("file_path",""))' 2>/dev/null)
[[ -n "$file" && -f "$file" ]] || exit 0
dir=$(dirname "$file")
claude_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

# find_up <name>...: true if any name exists in the file's directory or an ancestor.
find_up() {
  local d=$dir n
  while :; do
    for n in "$@"; do [[ -e "$d/$n" ]] && return 0; done
    [[ "$d" == / || "$d" == . ]] && return 1
    d=$(dirname "$d")
  done
}

problems=""
report() { problems+="$1"$'\n'; }

in_ros_pkg=false
find_up package.xml && in_ros_pkg=true

case "$file" in
  *.py)
    if command -v ruff >/dev/null; then
      cfg=()
      if ! find_up ruff.toml .ruff.toml; then cfg=(--config "$claude_dir/ruff.toml"); fi
      ruff format -q ${cfg[@]+"${cfg[@]}"} "$file" >/dev/null 2>&1
      out=$(ruff check -q --fix --output-format concise ${cfg[@]+"${cfg[@]}"} "$file" 2>&1) || report "$out"
    elif $in_ros_pkg; then
      out=$(ament_flake8 "$file" 2>&1) || report "$(grep -E '^[^ ].*:[0-9]+:[0-9]+:' <<<"$out")"
      out=$(ament_pep257 "$file" 2>&1) || report "$(grep -E '^[^ ].*:[0-9]+' <<<"$out")"
    fi
    ;;
  *.cpp|*.cc|*.cxx|*.hpp|*.hh|*.h)
    if find_up .clang-format _clang-format && command -v clang-format >/dev/null; then
      clang-format -i "$file"
    elif $in_ros_pkg && command -v ament_uncrustify >/dev/null; then
      ament_uncrustify --reformat "$file" >/dev/null 2>&1
    fi
    if $in_ros_pkg && command -v ament_cpplint >/dev/null; then
      # Copyright headers are a per-project choice (ros2 pkg create skips that check by default).
      out=$(ament_cpplint --filters=-legal/copyright "$file" 2>&1) || report "$(grep -E ':[0-9]+:' <<<"$out")"
    fi
    case "$file" in
      *.hpp|*.hh|*.h)
        grep -qE '^\s*#\s*pragma\s+once' "$file" && report "$file: use include guards, not #pragma once"
        grep -qE '^using ' "$file" && report "$file: no file-scope 'using' in headers"
        ;;
      *)
        grep -qE '^\s*using\s+namespace\s+std\s*;' "$file" && report "$file: no 'using namespace std'"
        ;;
    esac
    ;;
esac

if [[ -n "${problems//[$'\n']/}" ]]; then
  printf 'Lint problems in %s:\n%s' "$file" "$problems" >&2
  exit 2
fi
exit 0
