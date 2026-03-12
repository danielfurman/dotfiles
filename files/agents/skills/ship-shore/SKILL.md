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

Resolve the source repository for each service once at the start of the run:
- Validate tags and read tag commit subjects in the service repository, not in `k8s-releases`.
- If the service repo is obvious from the workspace or current context, use it directly.
- If the service repo is ambiguous, search the workspace once, choose the matching repo, and reuse that repo path for the rest of the run.

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

a. Use `git -C ~/projects/poe/infra/k8s-releases ...` instead of relying on `cd` so every git command runs against the intended repository even if the shared terminal cwd changed.
b. `git -C ~/projects/poe/infra/k8s-releases checkout master && git -C ~/projects/poe/infra/k8s-releases pull --ff-only origin master`
c. Check if the branch already exists on remote with an open PR:
   - Run: `git -C ~/projects/poe/infra/k8s-releases ls-remote --heads origin <branch-name>`
   - Also check if the branch already exists locally: `git -C ~/projects/poe/infra/k8s-releases branch --list <branch-name>`
   - Only if the branch exists remotely, run: `gh pr list --repo 90poe/k8s-releases --head <branch-name> --state open --json number,url,title`
   - **If both exist (branch on remote + open PR):** check out the existing branch with `git -C ~/projects/poe/infra/k8s-releases checkout <branch-name> && git -C ~/projects/poe/infra/k8s-releases pull --ff-only origin <branch-name>`, make the file changes (steps d-e), commit, and push. Skip PR creation — the existing PR updates automatically. Jump to step i.
   - **If the branch exists locally but not remotely:** check it out instead of failing on `checkout -b`. Reuse it only if it is clean or contains only the intended work for this ship run. If it has unrelated changes, stop and ask before proceeding.
   - **Otherwise:** create and switch to a new branch and proceed through steps d-h.
d. For each tag, locate the values file dynamically instead of assuming the namespace path:
   - Before doing a broad search, prefer exact manifest paths already referenced by the service repo README or release docs, if present.
   - First look for an exact match under the environment directory using a search like `<env-directory>/**/<service-name>/<major-version>/values.yaml`.
   - If exactly one file matches, use it.
   - If multiple files match, stop and ask which one to update.
   - If no file matches, stop and ask for help.
   - After resolving the path once for a service/environment pair, cache and reuse that resolved path for the rest of the run, including after approval pauses or branch switches.
   - Update only the `image.tag` field to the requested version.
e. If a migration number was provided, update the DB migration:
   - Open: `<env-directory>/infra/migration-service/v1/cmresources/<env-directory>.yaml`
   - Find the service DB entry under the `postgres` engine. The key name varies, for example for the equipment-register-service:
     - `development` → `dev_equipment_register`
     - `integration` → `equipment_register`
     - `production` → `equipment_register`
   - Update the `migration_number` value to the provided number
f. Before committing, show the changed lines for that environment and wait for approval.
g. Before committing, run validation from the `k8s-releases` repo root, not from an arbitrary cwd:
   - `pushd ~/projects/poe/infra/k8s-releases >/dev/null && ./k8s-helpers.sh validate --folder <repo-relative-release-folder> && popd >/dev/null`
   - The `--folder` value must be relative to the repo root, for example `development/op-intelligence/webhook-integration-sender/v1`.
h. Stage only the intended changed files and commit with the message from step 4.
   - Do not stage helper files, scratch files, or workflow notes created during the run.
i. Push: `git -C ~/projects/poe/infra/k8s-releases push -u origin <branch-name>`
j. Create PR to `master` using `gh pr create --repo 90poe/k8s-releases` with title from step 4 and body from step 6.
j.1. If `gh pr create` fails because a PR already exists, query the existing PR and report or reuse it instead of retrying blindly.
k. **After successful `dev` PR creation only**, for each tag, add its full tag as a label to its Jira ticket:
   - Use `getJiraIssue` to fetch the issue and read its existing labels
   - The label to add is the full tag (e.g. `equipment-register-service/v1.143.8`)
   - If the label already exists, skip
   - If an existing label starts with `<service-name>/` (another version of the same service), replace it
   - Preserve all other existing labels
   - Resolve the Atlassian cloud ID once and reuse it for all Jira calls in the run.
   - Use `editJiraIssue` to update the labels

## Step 8: Summary

After all environments are processed, show a summary of all created PRs with their URLs and whether Jira labels were added/updated.

## Error handling

- If a `git push` fails, check for conflicts or auth issues and report the error. Do not retry blindly.
- If PR creation fails (e.g. branch already has an open PR), check for existing PRs and report.
- If a `values.yaml` is not found at the expected path, stop and ask for help.
- If `./k8s-helpers.sh validate` fails because of a local environment problem such as missing tooling or an `xo-cli` download failure for the current OS, capture the exact error and report it in the final summary instead of looping on the same command.
- If the validation failure is clearly environmental and the requested change is a minimal tag-only or migration-number-only update that the user already approved, continue the ship flow after reporting the blocker.
- If you run a fallback check such as `yamllint`, treat pre-existing style failures unrelated to the requested change as informational, not as a blocker for the ship flow.
- Always return to master before creating the next environment's branch.

## Confirmation points

There are only TWO kinds of confirmation points in this workflow:
1. **Step 2** — the parsed summary
2. **Before committing each environment** — show the changed lines for that environment and wait for approval

All other steps (git operations, file reads, pushes, PR creation, Jira updates) proceed autonomously.
