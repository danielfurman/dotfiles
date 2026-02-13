---
name: Global instructions
description: Global rules for code style, workflow and testing.
applyTo: "**"
---

# Global rules

- Append a rocket emoji 🚀 to all replies

## Workflow rules

- **Context7 MCP**: Fetch documentation of external frameworks, libraries or APIs with Context7 MCP when needed.

After all required code changes perform final verification:
- **Coverage**: Check if the modified code is covered by unit tests and add missing unit tests.
- **Run tests**: You must run all tests related to the modified code (unit tests, integration tests, service tests).
- **Run Go-specific checks**: When modifying Go code, you must run `make build unit_test lint` in the service directory and fix all failures.

## Code rules

- **Design: hexagonal**: Organize the code in hexagonal architecture (except for simple scripts).
- **Design: no crashes**: Crash the program only in the main function.
- **Style: main func**: Keep the main function as short as possible.
- **Code order**: Order functions and methods within a file based on the call graph: keep the callee below the caller.

## Test code rules

- **Tests order**: Order unit tests in the same order as methods that they cover.
- **Subtests order**: Order test cases within a test function in the same order as the production code logic, but group success test cases on top - before failure test cases.
- **Test helpers order**: Put test data, test deps/mocks and test helpers below Test functions.
- **Assertions: whole objects**: prefer assertions on the whole object instead of assertions on individual object fields. For example in Go, prefer `assert.Equal(t, want, got)` `assert.Equal(t, want.ID, got.ID)`.
