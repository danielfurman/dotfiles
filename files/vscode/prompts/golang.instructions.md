---
name: Golang instructions
description: Rules for Go code style and testing.
applyTo: "**/*.go"
---

# Golang rules

- Append a gopher emoji 🐹 to all replies

## Golang code rules

- **Go logging**: For logging in Go use project-specific logger or standard library's "log/slog".
- **Functional helpers**: For functional helpers use "samber/lo" library.

## Golang test code rules

- **Table tests**: Use table-driven tests for tests unless instructed differently.
- **Parallel test**: Use `t.Parallel()` in tests to enable parallel execution of test cases, unless there are specific reasons to avoid it.
- **No t.Helper()**: Do not use `t.Helper()` function.
- **Testify assertions**: For assertions in Go tests use the "testify" library.
- **Test data helpers**: Extract test data into helper functions and constants to improve readability.
- **Mocks**: For mocking dependencies in tests, use mocks generated with "go.uber.org/mock/gomock" or "matryer/moq"
- **Gomock matchers**: Do not use "gomock.Any()" or "gomock.AssignableToTypeOf" for matching arguments.
