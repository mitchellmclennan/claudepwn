---
name: gitnexus-debugging
description: "Use when the user is debugging a bug, tracing an error, or asking 'why is X failing?'"
---

# GitNexus: Debugging

## When to Use

- "Why is X failing?"
- "Where does this error come from?"
- Tracing a bug through call chains
- Understanding error propagation paths

## Workflow

1. **Identify the failing symbol:** Function or method where the error surfaces
2. **Get context:** `gitnexus context({symbol: "failingFunction"})` — see all callers, callees, and processes
3. **Trace upstream:** `gitnexus impact({target: "failingFunction", direction: "upstream", depth: 3})`
   — What calls this? Where does the bad input originate?
4. **Trace downstream:** `gitnexus impact({target: "failingFunction", direction: "downstream", depth: 2})`
   — What does this affect? Where does the error propagate?
5. **Check processes:** Read the process that includes this function — follow the full execution flow
6. **Detect recent changes:** `gitnexus detect_changes()` — did a recent change break this?

## Checklist

- [ ] Root cause identified (not just the symptom)
- [ ] Full call chain from input to error traced
- [ ] Fix addresses root cause, not just the crash site
- [ ] Regression test added at the root cause location
- [ ] No other callers affected by the fix (checked via impact analysis)
