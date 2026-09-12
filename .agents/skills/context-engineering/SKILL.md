---
name: context-engineering
description: "Targeted context loading hierarchy to prevent token waste and keep context windows clean and precise."
---

# Context Engineering Skill

## Purpose

Enforce strict context retrieval discipline. Load only the targeted documentation, decision records, and source files necessary to perform the active task.

## Context Loading Hierarchy (AVR Studio Next)

```text
1. AGENTS.md & .agent/CONTINUITY.md (Mandatory project state & rules authority)
       ↓
2. Relevant Project Documentation (00 Project/Product Requirements.md)
       ↓
3. Relevant Architecture Documentation (07 Architecture/ or 04 Simulator/)
       ↓
4. Relevant Decision Records (12 Decisions/)
       ↓
5. Relevant Source Code Files (Only files directly touched or called)
       ↓
6. Relevant Unit / Integration Tests
```

## Rules

- Do **NOT** read the entire knowledge base (`docs/knowledge/`) for every task.
- Retrieve specific knowledge notes based on task scope (e.g. UART task $\to$ `01 AVR Platform/AVR UART.md` $\to$ `05 Visualization/UART Monitor.md`).
- Do not inspect un-truncated source files unless line ranges or symbol definitions require it.

## Rationalizations to Avoid

| Excuse | Reality |
| :--- | :--- |
| "I'll read every file in docs/ to be thorough." | Flooding context wastes tokens and distracts the agent from the specific task. |
| "I don't need to read CONTINUITY.md." | CONTINUITY.md is the single source of truth for current project progress and decisions. Always read it first. |

## Verification

- Agent context window contains only targeted, relevant files.
