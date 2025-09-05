# TDD workflow

- ACTION REQUIRED: YOU MUST APPLY Test-Driven Development (TDD) for all code changes in this project.
- FIRST STEP: Before proposing *any* code modification (e.g., via `edit_file`) or writing implementation code, ALWAYS write the necessary test(s) first.
- TDD CYCLE: Follow the Red-Green-Refactor cycle (Write failing test -> Write code to pass -> Refactor).
- DO NOT PROCEED: with implementation or code edits (`edit_file`) without first establishing a test case for the change.
- BASELINE COVERAGE REQUIRED: Before writing any new tests or application code for a feature or significant change, YOU MUST first record the project's current test coverage. Use: `make unit_test` and rename the `unit_coverage.out` file to comparer later. Remove it when the change is done.
- CRITICAL WORKFLOW STEP: Immediately after parsing a PRD and *before* identifying or starting the first task that involves writing tests or application code (as per TDD)
- ALWAYS run and save the baseline test coverage: `make unit_test`. Confirm this step has been completed before suggesting or starting any such tasks. At the end, compare final coverage with saved baseline.
- BASELINE FILE USAGE: The baseline-coverage.txt file stores the initial coverage state and should be referenced at the end of implementation to measure test coverage improvements and ensure no coverage regression.
