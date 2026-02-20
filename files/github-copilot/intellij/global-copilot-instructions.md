# Global rules

- Append a rocket emoji 🚀 to all replies

## Workflow rules

- **Context7 MCP**: Fetch documentation of external frameworks, libraries or APIs with Context7 MCP when needed.

After all required code changes perform final verification:
- **Test coverage**: Check if the modified code is covered by unit tests and add missing unit tests.
- **Run related tests**: You must run all tests related to the modified code (unit tests, integration tests, service tests).
- **Run Go-specific checks**: When modifying Go service code, you must run `make build unit_test lint`.
- **Run Go-specific service tests**: When modifying Go service code, you must run `make service_test_bootstrap` (or `make service_test` if missing target).

## Code rules

- **Design: hexagonal**: Organize the code in hexagonal architecture (except for simple scripts).
- **Design: no crashes**: Crash the program only in the main function.
- **Style: main func**: Keep the main function as short as possible.
- **Code order**: Order functions and methods within a file based on the call graph: keep the callee below the caller.
- **Capitalized logs**: Log messages should start with capital letter.
- **Structured logging**: Use structured logging with key-value pairs instead of unstructured logging with string messages.

## Test code rules

- **Tests order**: Order unit tests in the same order as methods that they cover.
- **Subtests order**: Order test cases within a test function in the same order as the production code logic, but group success test cases on top - before failure test cases.
- **Test helpers order**: Put test data, test deps/mocks and test helpers below Test functions.
- **Assertions: whole objects**: prefer assertions on the whole object instead of assertions on individual object fields. For example in Go, prefer `assert.Equal(t, want, got)` over `assert.Equal(t, want.ID, got.ID)`.

## Golang rules

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
