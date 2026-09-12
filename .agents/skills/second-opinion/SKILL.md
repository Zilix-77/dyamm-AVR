---
name: second-opinion
description: "Adversarial, independent code and architecture review to evaluate major changes, difficult bugs, and structural modifications."
---

# Second Opinion Skill

## Purpose

Provide an independent, objective review of important code implementations, architectural proposals, and bug diagnoses to prevent an agent from "grading its own homework."

## When to Use

- Simulator backend changes or `SimAvrAdapter` modifications.
- Subsystem boundary or architecture changes.
- Major refactoring of core business logic.
- Complex bug diagnoses before committing a fix.
- Security-sensitive logic or file system access paths.

## When NOT to Use

- Trivial one-line fixes or typos.
- Standard formatting or comment updates.

## Review Checklist

1. **Correctness**: Does the change strictly fulfill the requirement without introducing side effects or regressions?
2. **Architecture Boundaries**: Does it maintain clean isolation (UI $\to$ IDE $\to$ Toolchain $\to$ Simulator Adapter $\to$ Sandbox)?
3. **Overengineering Check**: Did it introduce unnecessary abstractions or extra dependencies? (Check against [[ponytail]])
4. **Platform Compatibility**: Does it run on Windows, Linux, and macOS without hardcoded paths or platform `#ifdef`s in shared code?
5. **Verification Evidence**: Is there a concrete build test or test assertion backing the implementation?

## Process

```text
Inspect Implementation Diff
            ↓
Verify against Architecture & PRD
            ↓
Check Boundary Leaks & Overengineering
            ↓
Formulate Independent Review Finding
            ↓
Approve or Request Revisions
```

## Rationalizations to Avoid

| Excuse | Reality |
| :--- | :--- |
| "The build passed, so the design must be good." | A compiling build does not guarantee clean architectural boundaries or lack of side effects. |
| "I wrote the code, so I already know it works." | Self-review suffers from confirmation bias. Step back and audit objectively. |

## Verification

- Review report highlights explicit risks, architectural checks, and verification outcomes.
