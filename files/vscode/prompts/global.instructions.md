---
applyTo: "**"
---

# Global rules

## Workflow rules

- End all replies with a rocket emoji.
- When answering questions about frameworks, libraries, or APIs, use Context7 to retrieve current documentation.

### Final verification

After all required code changes perform final verification:
- You must run `make build unit_test lint` command to check that the code compiles, unit tests pass and linters pass

## Code rules

- Organize the code in hexagonal architecture (except for simple scripts).
- Crash the program only in the main function.
- Keep the main function as short as possible.
- Start log messages with a capital letter.
- For functions and methods order, keep the callee below the caller.

## Test code rules

- Put test helpers, test data and mocks below Test functions.
