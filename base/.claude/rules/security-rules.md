---
name: security-rules
description: Security rules enforced on every code change.
---

# Security Rules

## Secrets

- NEVER hardcode secrets, tokens, API keys, passwords, or private keys
- Use environment variables for all sensitive configuration
- .env files are in .gitignore — NEVER commit them
- If a secret is accidentally committed, rotate it immediately and force-push removal

## Input Validation

- ALL external inputs must be validated at the API boundary
- Use schema validation (Pydantic, Zod, etc.) — not manual checks
- Sanitize strings before use in SQL, shell commands, or HTML
- Reject unexpected types — don't coerce

## Authentication & Authorization

- Every protected route must check auth — no exceptions
- JWT: validate expiry, signature, and issuer
- No auth bypass via parameter manipulation
- Session tokens must be httpOnly, secure, sameSite
- Rate limit auth endpoints

## Data Security

- Encrypt sensitive data at rest
- Use parameterized queries — never string interpolation for SQL
- Log access to sensitive data for audit trail
- Don't log secrets, tokens, or PII
- Hash passwords with bcrypt/argon2 — never SHA/MD5

## Dependencies

- Run dependency audit regularly (stack-specific commands in overlay)
- No known HIGH/CRITICAL CVEs in production dependencies
- Pin dependency versions — no floating ranges in production
- Review new dependencies before adding (license, maintenance, security history)

## Infrastructure

- HTTPS everywhere — no plain HTTP
- CORS configured to specific origins — never wildcard in production
- Security headers set (CSP, HSTS, X-Frame-Options, etc.)
- Disable debug mode in production
