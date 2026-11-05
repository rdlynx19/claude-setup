# Working rules

- Make the smallest change that solves the task. No unrelated refactors, renames, or reformatting.
- Don't create docs, READMEs, or summary files unless asked.
- Fix every compiler and linter warning you introduce; warnings usually mean bugs.
- No leftover debug prints; log through the project's logger (ROS: `get_logger().debug()` / `RCLCPP_DEBUG`).
- Never use sleeps or arbitrary delays to make code work; fix the synchronization.
- No hard-coded absolute or machine-specific paths.
- No commented-out code unless a comment states why it's kept.
- Before calling a task done, build and run the tests (commands below). If you couldn't run them, say so.
- Language and ROS rules load from `.claude/rules/` when matching files are touched; a hook formats and lints each edited file. Fix what it reports.

# Responses

- Be concise. Don't restate diffs or narrate tool calls. Report what changed, how it was verified, and what's still open.

# Git

- Don't commit unless asked. Commits are small, one idea each, with a meaningful message.
- Never commit build output (`build/`, `install/`, `log/`), generated files (e.g. URDF from xacro), `__pycache__/`, `.vscode/`, or editor backups.
- `main` at HEAD must always compile. A WIP commit that doesn't compile goes on a branch and its message says `DOES NOT COMPILE`.

# Project

<!-- Fill in per project; delete lines that don't apply. -->
- Build:
- Test:
- Notes:
