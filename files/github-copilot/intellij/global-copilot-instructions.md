# Global rules

## General rules

- End all replies with a rocket emoji.
- Be concise in explanations.
- After modifying code or tests, run all related tests.

## Code style rules

- Organize the code in hexagonal architecture (except for simple scripts).
- Crash the program only in the main function.
- Keep the main function as short as possible.
- Start log messages with a capital letter.
- For functions and methods order, keep the callee below the caller.
- Order test helpers and mocks below Test functions.

## Golang code rules

- Use table-driven tests for tests unless instructed differently.
- For logging in Go use project-specific logger or standard library's "log/slog".
- For assertions in Go tests use the "testify" library.
- For mocking dependencies in tests, use mocks generated with "go.uber.org/mock/gomock" or "matryer/moq" unless instructed differently.
