---
name: design-before-code
description: No implementation without an approved design.
---

# Design-Before-Code Protocol

## Rule

No implementation begins without an approved design. For any non-trivial task (new feature, architectural change, new integration), answer these 6 questions first:

## 6 Forcing Questions

1. **Demand** — What specific user problem does this solve?
2. **Status quo** — How is this solved today? What breaks if we do nothing?
3. **Specificity** — What is the smallest scope that delivers value?
4. **Wedge** — What is the smallest first step we can ship and validate?
5. **Observation** — How do we measure success? What metrics change?
6. **Future-fit** — Does this make future changes easier or harder?

## When to Apply

- New feature that touches >2 files
- Architectural change (new service, new data model, new integration)
- Any task the Architect flags as needing design review

## When to Skip

- Bug fixes with obvious root cause
- Test additions
- Documentation updates
- Single-file refactors

## Process

1. Architect answers the 6 questions → writes ADR
2. ADR posted to BOARD.md for review
3. Implementation begins only after ADR status = ACCEPTED
4. Implementer references the ADR in their task completion notes
