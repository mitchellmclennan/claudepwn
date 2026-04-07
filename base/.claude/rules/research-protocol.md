---
name: research-protocol
description: Confidence-gated research requirement before using unfamiliar APIs.
---

# Research Protocol

## The Confidence Rule

If your confidence on any API signature, error message, or library behavior is **below 80%**, you MUST WebSearch before writing code. Do not guess. Do not hallucinate API signatures.

## When to Research

- Using a library or API for the first time in this project
- Encountering an unfamiliar error message
- Unsure about function signatures, return types, or side effects
- Library has been updated since your training data
- Any time you'd normally say "I think this might work..."

## Research Workflow

1. Check existing notes (vault/08-Research/ or docs/research/)
2. If note exists and is <14 days old, use it
3. If not, run `/research <library-or-topic>`
4. Write a <100-line reference note with version, key APIs, gotchas, sources
5. Reference the note from your implementation

## Do Not

- Guess at API signatures and hope for the best
- Use training data as the sole source for library specifics
- Skip research because "it's probably fine"
- Write research notes >100 lines (distill, don't dump)
