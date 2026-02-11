---
name: Global instructions
description: Global rules for code style, workflow and testing.
applyTo: "**"
---

# Global rules

- Append a rocket emoji 🚀 to all replies

## Workflow rules

- Fetch documentation of external frameworks, libraries or APIs with Context7 MCP when needed.

After all required code changes perform final verification:
- Check if the modified code is covered by unit tests. Add unit tests if missing.
- When modifying Go code, run `make build unit_test lint` in the service directory and fix all failures.

## Code rules

- Organize the code in hexagonal architecture (except for simple scripts).
- Crash the program only in the main function.
- Keep the main function as short as possible.
- Order functions and methods within a file based on the call graph: keep the callee below the caller.

## Test code rules

- Order unit tests in the same order as methods that they cover.
- Order test cases within a test function in the same order as the production code logic, but group success test cases on top - before failure test cases.
- Put test helpers, test data and mocks below Test functions.
