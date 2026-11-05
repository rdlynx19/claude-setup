#!/usr/bin/env bash
# Install this Claude Code template into a project: ./install.sh /path/to/project
# Never overwrites existing files. Merges settings.json (permissions and hooks unioned).
# Safe to re-run.
set -euo pipefail

src="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.claude"
target="${1:?usage: install.sh /path/to/project}"
dest="$(cd "$target" && pwd)/.claude"
[[ "$src" != "$dest" ]] || { echo "Target is the template itself." >&2; exit 1; }

mkdir -p "$dest"
skipped=()
while IFS= read -r -d '' f; do
  rel="${f#"$src"/}"
  case "$rel" in settings.json|settings.local.json|CLAUDE.local.md) continue ;; esac
  if [[ -e "$dest/$rel" ]]; then
    skipped+=("$rel")
  else
    mkdir -p "$(dirname "$dest/$rel")"
    cp -p "$f" "$dest/$rel"
  fi
done < <(find "$src" -type f -print0)

python3 - "$src/settings.json" "$dest/settings.json" <<'PY'
import json, os, sys

src_path, dest_path = sys.argv[1], sys.argv[2]
src = json.load(open(src_path))
dest = json.load(open(dest_path)) if os.path.exists(dest_path) else {}

def union(a, b):
    out = list(a)
    out += [x for x in b if x not in out]
    return out

for key in ("allow", "deny", "ask"):
    merged = union(dest.get("permissions", {}).get(key, []), src.get("permissions", {}).get(key, []))
    if merged:
        dest.setdefault("permissions", {})[key] = merged
hooks = dest.setdefault("hooks", {})
for event, groups in src.get("hooks", {}).items():
    hooks[event] = union(hooks.get(event, []), groups)
for key, value in src.items():
    dest.setdefault(key, value)
dest = {k: dest[k] for k in sorted(dest, key=lambda k: k != "$schema")}  # $schema first

with open(dest_path, "w") as f:
    json.dump(dest, f, indent=2)
    f.write("\n")
PY

echo "Installed into $dest"
if ((${#skipped[@]})); then
  echo "Kept existing files (merge by hand if needed):"
  printf '  %s\n' "${skipped[@]}"
fi
echo "Next: fill in the '# Project' section of $dest/CLAUDE.md."
