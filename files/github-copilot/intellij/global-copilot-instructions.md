# Global rules

## General rules

- End all replies with a rocket emoji.
- After modifying code or tests, run all unit tests for the service and other related tests.

## Code rules

- Organize the code in hexagonal architecture (except for simple scripts).
- Crash the program only in the main function.
- Keep the main function as short as possible.
- Start log messages with a capital letter.
- For functions and methods order, keep the callee below the caller.

## Test code rules

- Put test helpers, test data and mocks below Test functions.

## Golang code rules

- Use table-driven tests for tests unless instructed differently.
- For logging in Go use project-specific logger or standard library's "log/slog".
- For functional helpers use "samber/lo" library.

## Golang test code rules

- For assertions in Go tests use the "testify" library.
- For mocking dependencies in tests, use mocks generated with "go.uber.org/mock/gomock" or "matryer/moq" unless instructed differently.
