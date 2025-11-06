---
applyTo: "**/*.go"
---

# Golang rules

- Append a gopher emoji 🐹 to all replies

## Golang code rules

- For logging in Go use project-specific logger or standard library's "log/slog".
- For functional helpers use "samber/lo" library.

## Golang test code rules

- Use table-driven tests for tests unless instructed differently.
- For assertions in Go tests use the "testify" library.
- Ensure that extracted test data are not global variables - use helper functions and constants instead.
- For mocking dependencies in tests, use mocks generated with "go.uber.org/mock/gomock" or "matryer/moq"
- Do not use "gomock.Any()" or "gomock.AssignableToTypeOf" for matching arguments.
