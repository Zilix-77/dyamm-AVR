---
name: doubt-driven-development
description: "Adversarial assumption-checking framework (Claim -> Extract -> Doubt -> Reconcile -> Stop) before writing code."
---

# Doubt-Driven Development Skill

## Purpose

Subject non-trivial implementations, hardware assumptions, and API claims to an adversarial review loop (*"Claim $\to$ Extract $\to$ Doubt $\to$ Reconcile $\to$ Stop"*). Prevents building software on unverified or hallucinated assumptions.

## When to Use

- Working with AVR hardware register behaviors or pin multiplexing rules.
- Interfacing with simavr C structures (`avr_t`, `avr_irq_t`).
- Handling cross-platform process spawning (`QProcess`) across Windows, Linux, and macOS.
- Working with third-party libraries or platform-specific OS calls.
- Implementing features based on undocumented or legacy specifications.

## The 5-Step Doubt Loop

```text
1. Claim     ──> State the assumption being made (e.g. "simavr updates PORTB instantly").
       ↓
2. Extract   ──> Identify the exact line of code, datasheet section, or API call involved.
       ↓
3. Doubt     ──> Ask: "What if this assumption is wrong? How does it fail?"
       ↓
4. Reconcile ──> Test or verify against authoritative source code/datasheet.
       ↓
5. Stop      ──> Proceed ONLY when the doubt is empirically resolved.
```

## Rationalizations to Avoid

| Excuse | Reality |
| :--- | :--- |
| "It seems logical, so I don't need to verify." | Logic without empirical check leads to subtle hardware timing bugs. |
| "It works on my machine (Windows)." | Test/verify cross-platform behavior for Linux and macOS. |

## Verification

- All hardware and API assumptions are empirically verified against datasheets, header files, or test runs.
