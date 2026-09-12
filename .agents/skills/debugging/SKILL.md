---
name: debugging
description: "Evidence-driven root cause debugging methodology, preventing symptom masking and ensuring regression tests."
---

# Debugging & Error Recovery Skill

## Purpose

Enforce strict evidence-driven root-cause debugging. Prohibits superficial symptom patching, exception swallowing, or random trial-and-error code edits.

## Evidence-Driven Debugging Workflow

```text
1. Reproduce      ──> Run the exact failing build or test command to confirm failure.
       ↓
2. Observe        ──> Read the full, un-truncated error log or traceback output.
       ↓
3. Collect        ──> Inspect source code lines and variables at the failure site.
       ↓
4. Formulate      ──> Form a single diagnostic hypothesis based strictly on empirical log evidence.
       ↓
5. Test           ──> Validate the hypothesis before modifying code.
       ↓
6. Fix Root Cause ──> Implement the minimal fix addressing the root cause (not just symptom).
       ↓
7. Regression     ──> Add or update a test assertion verifying the fix.
       ↓
8. Verify         ──> Re-run full build and test suite to confirm zero regressions.
```

## Prohibited Behaviors

- **No Symptom Masking**: Never wrap failing code in silent `try/catch` blocks or return empty fallback data to hide errors.
- **No Test Disabling**: Never comment out or delete failing assertions.
- **No Blind Retries**: Never re-run the exact same failing command without analyzing log output first.

## Rationalizations to Avoid

| Excuse | Reality |
| :--- | :--- |
| "Adding a null check makes the crash go away." | If data is null, trace upstream to find why invalid state was passed. Fix the root cause. |
| "I'll guess what failed without reading the log." | Log inspection is mandatory step #2. Never diagnose blindly. |

## Verification

- Failure is fixed at the root cause level.
- Build compiles cleanly and test suite passes.
- Regression test added or entry recorded in `13 Bugs/`.
