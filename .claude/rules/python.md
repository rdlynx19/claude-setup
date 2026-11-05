---
paths:
  - "**/*.py"
---

# Python rules

- PEP 8, matching ROS 2 `ament_flake8`: 99-character lines, single quotes, Google import order. The edit hook enforces this; fix whatever it reports.
- PEP 257 docstrings, Google style, on every module, class, function, and method: a summary plus `Args:`, `Returns:`, and `Raises:` as applicable. Multi-line docstrings put the summary on the line after the opening `"""` (ament_pep257 expects D213).
- A ROS node module's docstring documents its ROS API, each entry with its type and purpose:
  ```python
  """
  What the node does.

  PUBLISHERS:
    topic (pkg/msg/Type): what it publishes
  SUBSCRIBERS:
    topic (pkg/msg/Type): what the data is used for
  SERVICES:
    name (pkg/srv/Type): what it does
  CLIENTS:
    name (pkg/srv/Type): what it does
  PARAMETERS:
    name (type): what it does
  """
  ```
- No `print` debugging. Keep useful output as `self.get_logger().debug(...)`.
- No `time.sleep()` or arbitrary delays; use timers, callbacks, or futures.
- Use relative ROS names (`'cmd_vel'`, not `'/cmd_vel'`) unless a global name is required.
