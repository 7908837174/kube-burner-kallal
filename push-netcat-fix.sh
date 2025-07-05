#!/bin/bash
# Simple script to push netcat fix to PR #911

set -e  # Exit on error

cd /workspaces/kube-burner

echo "Pushing netcat fix to PR #911"

# Stage our changes
git add test/helpers.bash
git add PR_NETCAT_FIX.md
git add .github/workflows/test-k8s.yml

# Commit with a clear message
git commit -m "Fix netcat verification in service checker pod to prevent CI failures"

# Push to origin main
git push origin main

echo "Changes pushed successfully!"
echo "PR URL: https://github.com/kube-burner/kube-burner/pull/911"
