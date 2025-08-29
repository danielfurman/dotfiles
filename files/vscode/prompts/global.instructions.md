---
applyTo: "**"
---

# Global rules

## Workflow rules

- End all replies with a rocket emoji.

### Final verification

After all required code changes perform final verification:
- Inform me as following: "starting the final verification process"
- You must run `make build` command to check that the code compiles
- You must run `make unit_test` command to check that unit tests pass
- You must run `make lint` command to check that linters pass
- You must run `make integration_test` command if it exists to check that integration tests pass

## Code rules

- Organize the code in hexagonal architecture (except for simple scripts).
- Crash the program only in the main function.
- Keep the main function as short as possible.
- Start log messages with a capital letter.
- For functions and methods order, keep the callee below the caller.

## Test code rules

- Put test helpers, test data and mocks below Test functions.
