---
paths:
  - "**/package.xml"
  - "**/CMakeLists.txt"
  - "**/setup.py"
  - "**/setup.cfg"
  - "**/launch/**"
  - "**/config/**"
  - "**/urdf/**"
  - "**/msg/**"
  - "**/srv/**"
---

# ROS 2 package rules

- `colcon build` and `colcon test` must pass cleanly. If dependency order is in doubt, use `colcon build --executor sequential`.
- Repo layout is `repository/package/`. Inside a package, create only the directories you use: `config/` (.yaml, .rviz), `launch/` (.launch.xml/.launch.py), `urdf/` (.xacro, .urdf, .gazebo; nothing generated at runtime), `src/`, `msg/`, `srv/`, `include/<pkg>/` (public headers), `tests/`.
- When adding dependencies, nodes, or installed files, update `package.xml` (dependencies, description, author) and `setup.py`/`CMakeLists.txt` to match.
- Launch files: our packages must cause no errors or warnings. Every argument has a `description`. An argument that takes a small fixed set of values sets `choices`.
- No absolute or machine-specific paths: use `$(find-pkg-share pkg)`, `FindPackageShare`, or `get_package_share_directory`.
