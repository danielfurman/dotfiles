---
name: ship-shore
description: Ship one or more service versions to one or more environments by updating the image tags in the k8s-releases repo and creating PRs. Use this skill whenever the user wants to deploy, ship, or release service versions to shore environments (dev, int, prod), update k8s image tags, or create deployment PRs. Also triggers for requests involving DB migration number updates alongside deployments.
---

Ship one or more service versions to one or more shore environments by updating image tags in the k8s-releases repo and creating PRs.

Arguments format: `<tag1> [tag2 ...] [db <number>] <env...>`

Tags come first (contain `/` with a version like `v1.x.x`), environments come last (short names: `dev`, `int`, `prod`).
Optionally include `db <number>` or `migration <number>` to update the equipment_register Postgres DB migration number.

Examples:
- `/ship-shore equipment-register-service/v1.143.8 dev`
- `/ship-shore mms-client-api/v0.65.12 dev int prod`
- `/ship-shore defect-management-client-api/v0.60.1 equipment-register-service/v1.143.11 dev int`
- `/ship-shore equipment-register-service/v1.143.8 db 255 dev int`
- `/ship-shore equipment-register-service/v1.143.8 migration 255 dev`

## Step 1: Parse arguments

Split `$ARGUMENTS` into tags, migration number, and environments:
- **Tags** contain a `/` followed by a version (e.g. `v1.143.8`).
- If `db` or `migration` is found, the next argument is the migration number (an integer).
- Remaining args are environment short names (`dev`, `int`, `prod`).

For each tag (e.g. `equipment-register-service/v1.143.8`):
- Split on `/` → service name = `equipment-register-service`, version = `v1.143.8`
- Extract major version from version (e.g. `v1` from `v1.143.8`) for the subdirectory

If no tags or no environments are provided, ask before proceeding.

**Validate tags exist in git:**
- For each tag, run: `git tag -l <full-tag>` and verify it returns a result.
- If any tag does not exist, stop and ask for the correct tag.

**Extract Jira tickets from each tag's commit message:**
- For each tag, run: `git log -1 --format="%s" <full-tag>`
- Extract the Jira ticket by matching `CP-[0-9]+` from the commit subject
- If no ticket is found for any tag, ask for it before proceeding
- Collect all unique Jira tickets across all tags

## Step 2: Confirm the plan

Print parsed values and wait for approval:
```
Tags:
  1. <service-name-1>/<version-1> (ticket: <jira-ticket-1>)
  2. <service-name-2>/<version-2> (ticket: <jira-ticket-2>)
DB migration: <number> (or "none")
Jira tickets: <unique tickets, comma-separated>
Environments: <env list>
Commit message: <env>: [<service-1>] <version-1>, [<service-2>] <version-2>, db <number> <ticket-1> <ticket-2>
```

Verify all Jira ticket keys match the `CP-XXXX` pattern. If not, stop and ask.

## Step 3: Map environments

- `dev` → `development`
- `int` → `integration`
- `prod` → `production`

## Step 4: Build commit message and PR title

Use the short env name (`dev`, `int`, `prod`) as the prefix. List each service update as `[<service-name>] <version>`, comma-separated. If a migration number is provided, append `, db <number>` after the service updates. Append all unique Jira tickets space-separated at the end.

Format: `<env>: [<service>] <version>[, [<service-2>] <version-2>][, db <number>] <ticket-1> [<ticket-2>]`

Examples:
- `int: [equipment-register-service] v1.143.8 CP-7875`
- `dev: [equipment-register-service] v1.143.8, db 255 CP-7875`
- `dev: [defect-management-client-api] v0.60.1, [equipment-register-service] v1.143.11, db 255 CP-6465 CP-7000`

## Step 5: Build branch name

Concatenate all unique Jira tickets: `<env>-<ticket-1>-<ticket-2>` (e.g. `dev-CP-6465-CP-7000`).

This avoids branch name collisions when shipping different services with different tickets to the same environment.

## Step 6: Build PR body

One Jira URL per line for each unique ticket:
```
https://ninetypercent.atlassian.net/browse/<ticket-1>
https://ninetypercent.atlassian.net/browse/<ticket-2>
```

## Step 7: Execute for each environment

For EACH environment, execute these steps sequentially:

a. `cd ~/projects/poe/infra/k8s-releases`
b. `git checkout master && git pull`
c. Check if the branch already exists on remote with an open PR:
   - Run: `git ls-remote --heads origin <branch-name>`
   - If it exists, run: `gh pr list --head <branch-name> --state open --json number,url`
   - **If both exist (branch on remote + open PR):** check out the existing branch with `git checkout <branch-name> && git pull origin <branch-name>`, make the file changes (steps d-e), commit, and push. Skip PR creation — the existing PR updates automatically. Jump to step i.
   - **Otherwise:** create and switch to a new branch and proceed through steps d-h.
d. For each tag, find the values file at: `<env-directory>/oos/<service-name>/<major-version>/values.yaml` and update the `image.tag` field to the new version.
e. If a migration number was provided, update the DB migration:
   - Open: `<env-directory>/infra/migration-service/v1/cmresources/<env-directory>.yaml`
   - Find the service DB entry under the `postgres` engine. The key name varies, for example for the equipment-register-service:
     - `development` → `dev_equipment_register`
     - `integration` → `equipment_register`
     - `production` → `equipment_register`
   - Update the `migration_number` value to the provided number
f. Stage all changed files and commit with the message from step 4.
g. Push: `git push -u origin <branch-name>`
h. Create PR to `master` using `gh pr create` with title from step 4 and body from step 6.
i. **After successful `dev` PR creation only**, for each tag, add its full tag as a label to its Jira ticket:
   - Use `getJiraIssue` to fetch the issue and read its existing labels
   - The label to add is the full tag (e.g. `equipment-register-service/v1.143.8`)
   - If the label already exists, skip
   - If an existing label starts with `<service-name>/` (another version of the same service), replace it
   - Preserve all other existing labels
   - Use `editJiraIssue` to update the labels

## Step 8: Summary

After all environments are processed, show a summary of all created PRs with their URLs and whether Jira labels were added/updated.

## Error handling

- If a `git push` fails, check for conflicts or auth issues and report the error. Do not retry blindly.
- If PR creation fails (e.g. branch already has an open PR), check for existing PRs and report.
- If a `values.yaml` is not found at the expected path, stop and ask for help.
- Always return to master before creating the next environment's branch.

## Confirmation points

There are only TWO confirmation points:
1. **Step 2** — the parsed summary
2. **Before committing** — show the changed lines and wait for approval

All other steps (git operations, file reads, pushes, PR creation, Jira updates) proceed autonomously.
