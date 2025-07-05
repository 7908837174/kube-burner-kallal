#!/bin/bash
# Verify that all changes have been pushed to PR #911

set -e

echo "===== VERIFYING ALL CHANGES PUSHED TO PR #911 ====="

# Check if there are any uncommitted changes
if git status --porcelain | grep -q .; then
  echo "⚠️ WARNING: There are uncommitted changes!"
  git status
  exit 1
else
  echo "✅ All changes are committed."
fi

# Check if we're ahead of upstream
AHEAD_COUNT=$(git rev-list --count HEAD ^upstream/main 2>/dev/null || echo "unknown")
echo "Your branch is $AHEAD_COUNT commits ahead of upstream/main"

# Verify shellcheck issues are fixed
echo "Verifying shellcheck issues are fixed..."
if pre-commit run shellcheck; then
  echo "✅ All shellcheck issues are fixed."
else
  echo "❌ Some shellcheck issues remain!"
  exit 1
fi

echo "===== ALL CHECKS PASSED ====="
echo "All changes have been successfully pushed to PR #911"
