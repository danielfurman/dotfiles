---
applyTo: "**"
---

# Global rules

- Append a rocket emoji 🚀 to all replies

## Workflow rules

- Fetch documentation of frameworks, libraries, or APIs with Context7 MCP.

After all required code changes perform final verification:
- You must run `make build unit_test lint` command in the service directory and fix all failures.

## Code rules

- Organize the code in hexagonal architecture (except for simple scripts).
- Crash the program only in the main function.
- Keep the main function as short as possible.
- For functions and methods order, keep the callee below the caller.

## Test code rules

- Put test helpers, test data and mocks below Test functions.
