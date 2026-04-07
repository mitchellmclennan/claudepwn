---
name: code-style
description: Go-specific naming, structure, and style rules.
---

# Code Style Rules — Go

## Naming

- Functions/methods: `camelCase` (unexported) or `PascalCase` (exported)
- Types/interfaces: `PascalCase`
- Constants: `PascalCase` (not SCREAMING_SNAKE — Go convention)
- Packages: short, lowercase, no underscores
- Files: `snake_case.go`
- Test files: `*_test.go`
- Interfaces: verb-er pattern (`Reader`, `Writer`, `Storer`)

## Structure

- **Max function length:** 40 lines
- **Max file length:** 300 lines
- **Max nesting depth:** 3 levels — use early returns
- One package = one concern
- Keep interfaces small (1-3 methods)

## Types

- Accept interfaces, return structs
- Use `error` for fallible operations — never panic in library code
- Use custom error types with `errors.Is`/`errors.As` compatibility
- Prefer value receivers unless mutation is needed

## Error Handling

- Always check error returns: `if err != nil { return err }`
- Wrap errors with context: `fmt.Errorf("doing X: %w", err)`
- No `_` for error values unless explicitly documenting why
- Use sentinel errors for expected conditions

## Patterns

- Use table-driven tests
- Use `context.Context` as first parameter for cancellable operations
- Prefer channels for concurrency communication, mutexes for shared state
- Use `sync.Once` for lazy initialization

## Commands

- **Test:** `go test ./...`
- **Lint:** `golangci-lint run`
- **Format:** `gofmt -w .`
- **Vet:** `go vet ./...`
- **Security:** `govulncheck ./...`
