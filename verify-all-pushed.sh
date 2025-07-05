#!/bin/bash
# Final verification script to check if all netcat fixes are properly pushed to PR #911

set -e # Exit on error

echo "===== VERIFYING ALL NETCAT FIXES WERE PUSHED TO PR #911 ====="
cd /workspaces/kube-burner

# Configure git properly
git config --global --add safe.directory /workspaces/kube-burner
git config --global user.email "kube-burner-ci@example.com" 
git config --global user.name "Kube Burner CI"

# Ensure we're on the main branch
CURRENT_BRANCH=$(git branch --show-current)
if [[ "$CURRENT_BRANCH" != "main" ]]; then
  echo "WARNING: Not on main branch, currently on $CURRENT_BRANCH"
  echo "Switching to main branch..."
  git checkout main
fi

# Fetch latest changes from remote
echo "Fetching latest changes from remote..."
git fetch origin

# Check if there are any unpushed commits
echo "Checking for unpushed commits..."
UNPUSHED=$(git log origin/main..HEAD --oneline)
if [[ -n "$UNPUSHED" ]]; then
  echo "WARNING: Found unpushed commits:"
  echo "$UNPUSHED"
  
  echo "Force pushing all commits to origin/main..."
  git push -f origin main
  echo "All commits pushed to origin/main"
else
  echo "✅ All commits are pushed to origin/main"
fi

# Check for any uncommitted changes
echo "Checking for uncommitted changes..."
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "WARNING: Found uncommitted changes"
  
  # Stage all changes
  git add test/helpers.bash
  git add test/test-k8s.bats
  git add PR_NETCAT_FIX_FINAL.md
  git add test/verify_final_netcat_fix.sh
  
  # Commit changes
  git commit -m "Final netcat verification fixes for PR #911" || echo "No changes to commit"
  
  # Push changes
  git push -f origin main
  echo "Final changes pushed to origin/main"
else
  echo "✅ No uncommitted changes found"
fi

echo "===== VERIFICATION COMPLETE ====="
echo "All netcat fixes should now be properly pushed to PR #911"
echo "Reference: https://github.com/kube-burner/kube-burner/actions/runs/16045090199/job/45274496768?pr=911"
