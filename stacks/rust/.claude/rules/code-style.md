---
name: code-style
description: Rust-specific naming, structure, and style rules.
---

# Code Style Rules — Rust

## Naming

- Functions/methods: `snake_case`
- Types/traits/enums: `PascalCase`
- Constants: `SCREAMING_SNAKE_CASE`
- Modules/files: `snake_case.rs`
- Lifetimes: single lowercase letter (`'a`, `'b`) or descriptive (`'conn`)
- Test modules: `#[cfg(test)] mod tests`

## Structure

- **Max function length:** 40 lines
- **Max file length:** 300 lines
- **Max nesting depth:** 3 levels — use early returns and `?` operator
- One public type per module (private helpers alongside are fine)

## Types

- Use `Result<T, E>` for fallible operations — never panic in library code
- Use `Option<T>` not sentinel values
- Prefer strong typing: newtype pattern over raw primitives for domain concepts
- Derive `Debug`, `Clone`, `PartialEq` on all public types

## Error Handling

- Use `thiserror` for library errors, `anyhow` for application errors
- No `.unwrap()` in production code — use `?` or explicit error handling
- `.expect("reason")` only when the invariant is genuinely impossible to violate
- Custom error types for each module boundary

## Patterns

- Prefer iterators and combinators over manual loops
- Use `impl Trait` in argument position for generic functions
- Avoid `Box<dyn Trait>` unless needed for heterogeneous collections
- Use builders for structs with >3 fields

## Commands

- **Test:** `cargo test`
- **Lint:** `cargo clippy -- -D warnings`
- **Format:** `cargo fmt`
- **Security:** `cargo audit`
- **Check:** `cargo check`
