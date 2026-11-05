---
paths:
  - "**/*.py"
---

# Python rules

- PEP 8, matching ROS 2 `ament_flake8`: 99-character lines, single quotes, Google import order. The edit hook enforces this; fix whatever it reports.
- PEP 257 docstrings in reST (Sphinx) style on every module, class, function, and method: a summary plus `:param:`/`:type:` per argument, `:returns:`/`:rtype:`, and `:raises:` as applicable. Multi-line docstrings put the summary on the line after the opening `"""` (ament_pep257 expects D213); one-line docstrings stay on one line. Don't use Google `Args:`/`Returns:` sections: `colcon test` on Humble rejects them (D406/D407).
  ```python
  def turtle_twist(xdot, omega):
      """
      Create a twist suitable for a turtle.

      :param xdot: the forward velocity
      :type xdot: float
      :param omega: the angular velocity
      :type omega: float
      :returns: a 2D twist object
      :rtype: geometry_msgs.msg.Twist
      :raises ValueError: if a velocity is not finite
      """
  ```
- A ROS node module's docstring documents its ROS API. Include each section that applies. Use `PARAMS:`, not `Parameters:`, which pep257 treats as a NumPy section:
  ```python
  """
  One-line summary of the node.

  Longer description of its behavior.

  PUBLISHERS:
    + topic_name (pkg/msg/Type) - What it publishes

  SUBSCRIBERS:
    + topic_name (pkg/msg/Type) - What the data is used for

  SERVICES:
    + service_name (pkg/srv/Type) - What it does

  CLIENTS:
    + service_name (pkg/srv/Type) - What it does

  PARAMS:
    + param_name (type) - What it does

  """
  ```
- No `print` debugging. Keep useful output as `self.get_logger().debug(...)`.
- No `time.sleep()` or arbitrary delays; use timers, callbacks, or futures.
- Use relative ROS names (`'cmd_vel'`, not `'/cmd_vel'`) unless a global name is required.
