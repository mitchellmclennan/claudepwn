---
name: gitnexus-impact-analysis
description: "Use when the user wants to know what will break if they change something — blast radius, upstream/downstream dependencies, safe refactor boundaries."
---

# GitNexus: Impact Analysis

## When to Use

- "What breaks if I change X?"
- Before any refactor or rename
- Before modifying a shared function/class
- Hardening Wave 4 (dependency audit)

## Workflow

1. **Identify the target symbol:** Function, class, or method you plan to modify
2. **Run impact analysis:** `gitnexus impact({target: "symbolName", direction: "both", depth: 3})`
3. **Review blast radius:**
   - Depth 1: Direct callers/callees
   - Depth 2: Indirect dependents
   - Depth 3: Transitive impact
4. **Check confidence scores:** High confidence = definitely breaks. Low confidence = might break.
5. **Cross-cluster check:** If impact crosses cluster boundaries, flag in ADR

## Pre-Refactor Safety Checklist

- [ ] Impact analysis run on every symbol being modified
- [ ] All depth-1 dependents have test coverage
- [ ] Cross-cluster impacts documented in ADR
- [ ] No circular dependencies introduced
- [ ] Orphaned code identified and removed or documented

## Example

```
gitnexus impact({target: "createUser", direction: "upstream", depth: 2})
```
→ Shows everything that calls createUser, and everything that calls those callers
