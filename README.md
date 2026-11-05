# claude-setup

A minimal Claude Code template for Python, C++, and ROS 2 projects. Everything lives in `.claude/`.

## What loads when

| File | Loaded | Purpose |
|---|---|---|
| `.claude/CLAUDE.md` | Every session | Working rules, response style, git rules, per-project commands |
| `.claude/rules/cpp.md` | When C++ files or `CMakeLists.txt` are touched | C++ standards |
| `.claude/rules/python.md` | When `.py` files are touched | Python standards |
| `.claude/rules/ros.md` | When ROS package files are touched | Package layout, launch files, `package.xml` |
| `.claude/hooks/format.sh` | After every Edit/Write (output only on failure) | Formats and lints the edited file |
| `.claude/settings.json` | Config | Allows build/test/lint commands; blocks reads of secrets and build output |

The rule files stay out of context until they're relevant, and the hook catches style problems without spending tokens on prose rules.

## Hook behavior

- **Python:** if `ruff` is installed, the hook runs `ruff format` and `ruff check --fix`. It uses the project's ruff config, or `.claude/ruff.toml` (which matches ament_flake8/ament_pep257) if there isn't one. Without ruff, inside a ROS package, it falls back to `ament_flake8` and `ament_pep257`.
- **C++:** the hook runs `clang-format` if the project has a `.clang-format`. Otherwise, inside a ROS package, it runs `ament_uncrustify --reformat`. Inside ROS packages it also runs `ament_cpplint`. In every C++ project it rejects `#pragma once`, file-scope `using` in headers, and `using namespace std`.

Recommended: `curl -LsSf https://astral.sh/ruff/install.sh | sh` (much faster than the ament linters).

## Usage

New project: copy this repo's `.claude/` into it, or use this repo as a GitHub template.

Existing project:

```bash
./install.sh /path/to/project
```

The script never overwrites files. It merges `settings.json` and lists any files it kept so you can merge them by hand. Afterwards, fill in the `# Project` section of `CLAUDE.md`.

Personal, machine-only overrides go in `.claude/settings.local.json` and `.claude/CLAUDE.local.md` (both gitignored).
