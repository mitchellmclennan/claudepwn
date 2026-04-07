---
name: code-style
description: TypeScript-specific naming, structure, and style rules.
---

# Code Style Rules — TypeScript

## Naming

- Functions: `camelCase` — verb_noun pattern
- Classes/interfaces/types: `PascalCase` nouns
- Constants: `SCREAMING_SNAKE_CASE`
- Files: `kebab-case.ts` for modules, `PascalCase.tsx` for React components
- Test files: `*.test.ts` or `*.spec.ts`
- Enums: `PascalCase` with `PascalCase` members

## Structure

- **Max function length:** 40 lines
- **Max file length:** 300 lines
- **Max nesting depth:** 3 levels — use early returns
- One component per file for React
- Colocate tests with source files or in parallel `__tests__/` directory

## Types

- No `any` — ever. Use `unknown` and narrow.
- No type assertions (`as`) unless absolutely necessary with a comment explaining why
- Use discriminated unions over type predicates where possible
- All API boundaries have Zod schemas or equivalent runtime validation
- Prefer `interface` for object shapes, `type` for unions and intersections

## Error Handling

- No empty `catch {}` blocks — always handle or rethrow
- Use custom Error classes for domain errors
- Wrap async operations in try/catch at the boundary
- Return `Result<T, E>` types for expected failures, throw for unexpected

## Patterns

- Use `async/await` not `.then()` chains
- Prefer `const` over `let`, never `var`
- Use optional chaining (`?.`) and nullish coalescing (`??`)
- Destructure function parameters for clarity

## Commands

- **Test:** `npx vitest` or `npm test`
- **Lint:** `npx eslint src/`
- **Format:** `npx prettier --write src/`
- **Type check:** `npx tsc --noEmit`
- **Security:** `npm audit`
