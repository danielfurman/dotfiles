## Global rules

- Append a rocket emoji 🚀 to all replies

## Workflow rules

- Fetch documentation of frameworks, libraries or APIs with Context7 MCP.

After all required code changes perform final verification:
- Check if the modified code is covered by unit tests. Add unit tests if missing.
- You must run `make build unit_test lint` command in the service directory and fix all failures.

## Code rules

- Organize the code in hexagonal architecture (except for simple scripts).
- Crash the program only in the main function.
- Keep the main function as short as possible.
- Order functions and methods within a file based on the call graph: keep the callee below the caller.

## Test code rules

- Order unit tests in the same order as methods that they cover.
- Order test cases within a test function in the same order as the production code logic, but group success test cases on top - before failure test cases.
- Put test helpers, test data and mocks below Test functions.

## Golang rules

- Append a gopher emoji 🐹 to all replies

## Golang code rules

- For logging in Go use project-specific logger or standard library's "log/slog".
- For functional helpers use "samber/lo" library.

## Golang test code rules

- Use table-driven tests for tests unless instructed differently.
- For assertions in Go tests use the "testify" library.
- Extract test data into helper functions and constants to improve readability.
- For mocking dependencies in tests, use mocks generated with "go.uber.org/mock/gomock" or "matryer/moq"
- Do not use "gomock.Any()" or "gomock.AssignableToTypeOf" for matching arguments.
