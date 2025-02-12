#!/usr/bin/env bash
# Remove git remote branches older than a year.

# Define threshold: 12 months in seconds (approximation: 6*30*24*3600)
threshold_sec=$((12 * 30 * 24 * 3600))
current_time=$(date +%s)

# List remote branches (on origin) with last commit timestamp and branch name
# shellcheck disable=SC2162
git for-each-ref --sort=committerdate refs/remotes/origin/ --format="%(committerdate:unix) %(refname:short)" | while read commit_ts branch; do
    # Calculate branch age in seconds
    age=$(( current_time - commit_ts ))

    # Skip protected branches
    case "$branch" in
        origin/master|origin/main|origin/develop)
            echo "Skipping protected branch: $branch"
            continue
            ;;
    esac

    if [ $age -gt $threshold_sec ]; then
        echo "Deleting $branch (last commit was $(( age / 86400 )) days ago)"
        # Remove the "origin/" prefix to get the actual branch name
        branch_name=${branch#origin/}
        git push origin --delete "$branch_name"
    fi
done
