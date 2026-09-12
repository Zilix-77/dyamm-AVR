---
name: ponytail
description: "Lazy senior developer mode enforcing code minimalism, avoiding overengineering, and climbing the decision ladder before writing code."
---

# Ponytail — Lazy Senior Developer Mode

## Purpose

Prevent unnecessary complexity, overengineering, and premature abstractions. The best code is the code never written.

Before writing any code, stop at the first rung of the decision ladder that holds:

```text
1. Does this need to be built at all? (YAGNI)
       ↓
2. Does it already exist in this codebase? (Reuse helper/util/pattern)
       ↓
3. Does the standard library already do this? (Use stdlib / C++20 / Qt 6)
       ↓
4. Does a native platform feature cover it? (Use native platform APIs)
       ↓
5. Does an already-installed dependency solve it? (Use existing deps)
       ↓
6. Can this be one line? (Make it one line)
       ↓
7. Only then: write the minimum code that works.
```

## Rules

- No abstractions that weren't explicitly requested.
- No new external dependencies if existing code or stdlib solves the problem.
- No boilerplate nobody asked for.
- Deletion over addition. Boring over clever. Fewest files possible.
- Shortest working diff wins, but only once you understand the problem.
- Question complex requests: *"Do you actually need X, or does Y cover it?"*
- Mark intentional simplifications with a `ponytail:` comment naming the known limit and upgrade path.

## Rationalizations to Avoid

| Excuse | Reality |
| :--- | :--- |
| "I should build a factory pattern in case we support 50 MCU types later." | MVP targets ATmega32. Build for ATmega32 cleanly first; do not over-abstract today. |
| "Adding a utility library makes parsing cleaner." | C++20 / Qt 6 already has native string and JSON parsers. Use what's installed. |
| "I'll create a 5-class subsystem for this simple buffer." | A 10-line struct or standard container is better than 5 empty abstraction layers. |

## Verification

- Code change is the smallest safe diff that fulfills the requirement.
- Zero unnecessary abstractions or phantom dependencies added.
