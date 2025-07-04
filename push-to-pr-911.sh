#!/bin/bash
# push-to-pr-911.sh - Script to ensure all changes are pushed to PR #911

set -euo pipefail

echo "Ensuring all changes are pushed to the branch associated with PR #911..."

# Make sure we're on the main branch
if [[ $(git rev-parse --abbrev-ref HEAD) != "main" ]]; then
  echo "Switching to main branch..."
  git checkout main
fi

# Check for any uncommitted changes
if ! git diff-index --quiet HEAD --; then
  echo "There are uncommitted changes. Please commit them first."
  exit 1
fi

# Push the changes to the fork's main branch
echo "Pushing changes to origin/main (which updates PR #911)..."
git push origin main

echo "All changes have been pushed to the branch associated with PR #911."
echo "Visit https://github.com/kube-burner/kube-burner/pull/911 to see the changes."
