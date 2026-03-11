---
name: hotfix
description: Create a hotfix release by cherry-picking commits onto a hotfix branch and creating a PR. Use this skill when the user wants to create a hotfix, cherry-pick specific commits for a patch release, create a hotfix branch from a tag, or needs to backport fixes to a released version. Arguments format is `<tag> <commit-hash1> [commit-hash2 ...]`.

# What to customize for your repo/flow:
#   - The monorepo root path
#   - GHA workflow file naming convention (step 5)
#   - Jira ticket pattern and URL (currently KRKN- prefix)
#   - Commit message format (step 3)
#   - The /ship-shore invocation at the end (step 10) — replace with your deployment process
---

Create a hotfix release. Arguments: `<tag> <commit-hash1> [commit-hash2 ...]`

Example: `/hotfix mms-job-scheduler/v1.2.3 abc1234 def5678`

## 1. Parse arguments

- First argument is `$ARGUMENTS` — split it by spaces.
- The first token contains `/` with a version (e.g. `mms-job-scheduler/v1.2.3`) — that's the **tag**.
- All remaining tokens are **commit hashes** to cherry-pick.
- Split the tag on `/` → **service name** (e.g. `mms-job-scheduler`) and **version** (e.g. `v1.2.3`).
- Validate each commit hash exists: `git cat-file -t <hash>` must succeed. If any fails, abort with an error.
- For each commit, extract the subject: `git log -1 --format="%s" <hash>` and match `KRKN-[0-9]+` to find Jira tickets.
- Collect all unique Jira tickets across all commits.

## 2. Derive names

- **Hotfix base branch**: `hotfix/<service-name>/<version>` — created from the exact tag.
  - Tag `v1.2.3` → `hotfix/mms-job-scheduler/v1.2.3`
  - Tag `v1.2.3.1` → `hotfix/mms-job-scheduler/v1.2.3.1`
- **Cherry-pick branch**: bump the hotfix version:
  - If version is `vX.Y.Z` (3 parts) → cherry-pick branch uses `vX.Y.Z.1`
  - If version is `vX.Y.Z.N` (4 parts) → cherry-pick branch uses `vX.Y.Z.(N+1)`
  - If the derived branch name already exists as a remote branch (`git ls-remote --heads origin hotfix/<service>/<derived-version>`), keep incrementing until a free name is found.
- **GHA workflow file**: `.github/workflows/pr_check_<service_name_with_underscores>.yml` (replace `-` with `_` in the service name).

## 3. Print summary and ask for confirmation

Print the following and wait for user approval before proceeding:

```
Tag: <tag>
Commits:
  1. <hash-short> — <subject> (<tickets>)
  2. <hash-short> — <subject> (<tickets>)
Tickets: KRKN-XXXX, KRKN-YYYY
Hotfix base branch: hotfix/<service>/<version>
Cherry-pick branch: hotfix/<service>/<bumped-version>
GHA workflow to update: pr_check_<service_underscored>.yml
```

Also ask the user to provide/confirm the **commit message description** and **type** (default `hotfix`). Pre-fill a suggestion based on the cherry-picked commit subjects.

The final commit message format for the PR will be:
```
hotfix: [<service>] <description> KRKN-XXXX KRKN-YYYY
```

## 4. Create hotfix base branch from tag

```
cd ~/Dev/mms
git fetch --tags
git checkout -b hotfix/<service>/<version> <tag>
```

If the base branch already exists on the remote, skip creating it — just check it out:
```
git fetch origin hotfix/<service>/<version>
git checkout hotfix/<service>/<version>
git pull
```

## 5. Update GHA triggers

- Read `.github/workflows/pr_check_<service_underscored>.yml`
- Under the `pull_request:` → `branches:` list, add `hotfix/<service>/<version>` if not already present.
- Show the diff to the user and wait for confirmation before committing.
- Stage and commit: `hotfix: [<service>] add hotfix branch to GHA triggers <tickets>`
- Push: `git push -u origin hotfix/<service>/<version>`

## 6. Create cherry-pick branch

```
git checkout -b hotfix/<service>/<bumped-version>
git cherry-pick <commit-hash1> <commit-hash2> ...
```

If cherry-pick has conflicts, stop and ask the user to resolve them before continuing.

Push: `git push -u origin hotfix/<service>/<bumped-version>`

## 7. Create PR

Use `gh pr create` targeting the hotfix base branch:
- **Base**: `hotfix/<service>/<version>`
- **Title**: `hotfix: [<service>] <description> <tickets>`
- **Body**: one Jira ticket URL per line: `https://ninetypercent.atlassian.net/browse/KRKN-XXXX`
Do NOT add any labels to the PR.

## 8. Monitor PR until merged

After creating the PR, spawn a background sub-agent that polls the PR state every 30 seconds using `gh pr view <pr-number> --json state`. When the PR state becomes `MERGED`, notify the main conversation.

## 9. Tag the hotfix

Once the PR is merged:

1. Switch back to the hotfix base branch and pull:
   ```
   git checkout hotfix/<service>/<version>
   git pull --tags
   ```
2. Create the hotfix tag: `git tag <service>/<bumped-version>`
3. Push the tag: `git push origin <service>/<bumped-version>`

## 10. Ship to production

Invoke `/ship-shore` with the created tag and `prod` environment:

```
/ship-shore <service>/<bumped-version> prod
```

## 11. Show summary

Print a final summary of everything that was done: PR URL, tag created, and shipping status.
