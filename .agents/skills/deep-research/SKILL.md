---
name: deep-research
description: "Comprehensive technical research methodology using multi-source investigation and knowledge base recording."
---

# Deep Research Skill

## Purpose

Perform systematic technical research across multiple authoritative sources to resolve technical uncertainties, toolchain behaviors, library APIs, or platform specifics.

## Hierarchy of Sources

```text
1. Official Documentation (Microchip ATmega32 Datasheet, Qt 6 Docs, CMake Manual)
       ↓
2. Official GitHub Repositories (simavr source, AVR-GCC source, Qt source)
       ↓
3. Official Issue Trackers & Release Notes
       ↓
4. Reputable Technical Sources & Peer-Reviewed Embedded Benchmarks
       ↓
5. Community Discussions & Forums (AVRfreaks, Stack Overflow)
```

## When to Use

- Evaluating third-party library capabilities or API signatures.
- Investigating simavr undocumented behaviors or C API functions.
- Cross-platform build issues or compiler flag differences (`avr-gcc` vs GCC vs Clang).
- Hardware peripheral timing or register quirks on ATmega32.

## Process

1. **Query Definition**: Formulate clear, precise technical queries.
2. **Multi-Source Fetch**: Search and cross-reference official documentation, source headers, and issue trackers.
3. **Fact Synthesis**: Clearly separate confirmed facts from assumptions or unverified claims.
4. **Knowledge Base Recording**: Record findings in `docs/knowledge/14 Research/<Topic>.md` or `docs/knowledge/12 Decisions/` when affecting architecture.

## Rationalizations to Avoid

| Excuse | Reality |
| :--- | :--- |
| "I remember how simavr works from training data." | AI memory can hallucinate API signatures. Always verify against source code or official docs. |
| "A blog post says X, so it must be true." | Verify blog claims against official datasheets or official source repos. |

## Verification

- Findings backed by direct citations to datasheets, official docs, or verified source lines.
- Knowledge base updated with clean markdown notes.
