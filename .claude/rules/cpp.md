---
paths:
  - "**/*.cpp"
  - "**/*.cc"
  - "**/*.cxx"
  - "**/*.hpp"
  - "**/*.hh"
  - "**/*.h"
  - "**/CMakeLists.txt"
---

# C++ rules

## Build
- C++23 with `-Wall -Wextra -Wpedantic`, zero warnings. CMake: `set(CMAKE_CXX_STANDARD 23)`, `set(CMAKE_CXX_STANDARD_REQUIRED ON)`, `add_compile_options(-Wall -Wextra -Wpedantic)`.
- A segfault means memory corruption: find and fix the cause immediately.

## Style
- Braces around every control-flow body, even one-liners.
- `//` comments, not `/* */`.
- No `this->` unless required.

## Doxygen (`///`)
- Every function/method: `\brief`, `\param` per parameter, `\tparam` per template parameter, `\returns`, `\throws` where applicable.
- Every class: a `\brief` block, and every public member documented. Private members get plain `//` comments, not Doxygen.
- A `.cpp` that is a ROS node starts with:
  ```cpp
  /// \file
  /// \brief What the node does
  ///
  /// PARAMETERS:
  ///     name (type): description
  /// PUBLISHES:
  ///     topic (type): description
  /// SUBSCRIBES:
  ///     topic (type): description
  /// SERVERS:
  ///     service (type): description
  /// CLIENTS:
  ///     service (type): description
  ```

## Headers and namespaces
- Include guards in every header; never `#pragma once`.
- Include project headers as `#include "package/header.hpp"`.
- Forward-declare instead of including where possible.
- No file-scope `using` in headers.
- No `using namespace std`; use one `using std::name;` per name. Exception: literal namespaces (e.g. `using namespace std::chrono_literals;`), in `.cpp` files only.

## Variables and math
- `const`/`constexpr` everywhere possible, but no `const` on by-value parameters in header declarations (fine in the definition).
- Declare variables in the narrowest scope.
- Globals are `static` or in an anonymous namespace; never `extern`.
- Almost always `auto`.
- `double`, not `float`. Double literals always have a decimal point (`1.0`, not `1`).
- Comment non-trivial math with its derivation or source; split long expressions into named `const`/`constexpr` intermediates.

## Classes
- Initialize members in the constructor initializer list, in declaration order.
- Single-argument constructors are `explicit`.
- Don't inherit from a class unless it has a `virtual` or `protected` destructor.

## Memory and containers
- RAII: no `new`/`delete`. Use `std::make_unique`/`std::make_shared`, or more likely `std::vector`.
- Pass by `const&`, not by pointer. No raw pointers.
- No C arrays; the default container is `std::vector`.
- Index with `.at()`, not `[]`.
- Prefer `std::ranges` and `<algorithm>` over hand-written loops.
