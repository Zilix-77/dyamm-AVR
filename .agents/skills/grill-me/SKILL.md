---
name: grill-me
description: "Stress-tests major plans, architectural changes, and design decisions through relentless, one-at-a-time questioning."
---

# Grill Me Skill

## Purpose

Stress-test technical plans, major architectural decisions, and design proposals before implementation begins. Discovers hidden assumptions, edge case failures, performance bottlenecks, and scope creep.

## When to Use

- Changing software architecture or component boundaries.
- Adding new external dependencies or libraries.
- Changing simulation strategy or replacing simavr backend.
- Redesigning `project.json` or `sandbox.json` file formats.
- Introducing plugin architectures or dynamic extension systems.
- Major refactoring affecting multiple subsystems.

## When NOT to Use

- Trivial bug fixes or minor code edits.
- Routine single-file implementation tasks.
- When an approved plan already exists.

## Interrogation Process

1. **One Question at a Time**: Ask exactly one sharp, challenging question per turn to probe specific assumptions.
2. **Challenge Assumptions**: Focus on:
   - *"What happens if simavr throws an unhandled error or crashes during simulation step execution?"*
   - *"How will this scale when we add another AVR MCU target in Phase 8?"*
   - *"Does this break low-end hardware performance budgets (< 500 MB RAM)?"*
   - *"Why can't we solve this with existing standard library capabilities?"*
3. **Iterate Until Solid**: Continue grilling until all edge cases, failure modes, and architectural implications are resolved.

## Rationalizations to Avoid

| Excuse | Reality |
| :--- | :--- |
| "Grill Me takes too long, I'll just start coding." | Unchecked design flaws take 10x longer to refactor after implementation. |
| "I'll grill the user on 10 things in one giant block." | Ask ONE question at a time to force laser-focused resolution. |

## Verification

- Implementation plan withstands rigorous edge-case analysis.
- Decision is recorded in `12 Decisions/` if architectural boundaries changed.
