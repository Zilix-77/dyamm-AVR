---
name: code-simplification
description: "Post-implementation code cleanup and complexity reduction without altering external behavior."
---

# Code Simplification Skill

## Purpose

Review freshly implemented code changes to identify opportunities for simplifying logic, deleting dead code, and eliminating unnecessary temporaries or boilerplate without altering behavior.

## When to Use

- Immediately after a feature implementation passes its verification build and tests.
- Before committing a feature or opening a pull request.

## When NOT to Use

- During active debugging or exploration.
- Performing massive unrelated code refactors across untouched files.

## Simplification Checklist

1. **Dead Code Elimination**: Remove unused local variables, redundant includes, and unreachable branches.
2. **Standard Library Substitution**: Replace custom loops or utility functions with C++20 / Qt 6 stdlib methods (`std::find_if`, `QStringView`, etc.).
3. **Control Flow Flattening**: Reduce deep nested `if`/`else` structures using early return guards.
4. **No Behavior Change**: Preserve exact public API signatures, error codes, and functional behaviors.

## Rationalizations to Avoid

| Excuse | Reality |
| :--- | :--- |
| "While simplifying, I might as well refactor this other module." | Keep diffs tightly focused on the current feature. No unrelated refactoring. |
| "More lines of code look more thorough." | Concise, readable code is easier to maintain and less prone to edge-case bugs. |

## Verification

- Code compiles cleanly and all unit/simulator tests pass before and after simplification.
