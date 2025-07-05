#!/bin/bash
# Verify the netcat fix was properly applied

set -e

echo "===== VERIFYING NETCAT FIX ====="

# Run pre-commit to check if shellcheck issues are fixed
echo "Running pre-commit to check shellcheck issues..."
pre-commit run shellcheck || {
  echo "❌ Shellcheck issues still exist!"
  exit 1
}

echo "✅ All shellcheck issues are fixed!"

# Check if the changes are committed
echo "Checking if changes are committed..."
if git status --porcelain | grep -q .; then
  echo "❌ There are uncommitted changes! Please commit them."
  git status
  exit 1
fi

echo "✅ All changes are committed!"

# Verify the specific files have been modified correctly
echo "Verifying specific files have been fixed..."

# Check test/run-tests.sh for glob fix
if grep -q "chmod +x \\*\\.bats \\*\\.bash" test/run-tests.sh; then
  echo "❌ The glob pattern in test/run-tests.sh has not been fixed!"
  exit 1
fi

if ! grep -q "chmod +x \\./\\*\\.bats \\./\\*\\.bash" test/run-tests.sh; then
  echo "❌ The glob pattern in test/run-tests.sh was not fixed correctly!"
  exit 1
fi

# Check test/run-tests.sh for quote fix
if grep -q "-j \$PARALLELISM" test/run-tests.sh; then
  echo "❌ The PARALLELISM variable in test/run-tests.sh is not properly quoted!"
  exit 1
fi

if ! grep -q "-j \"\$PARALLELISM\"" test/run-tests.sh; then
  echo "❌ The PARALLELISM variable in test/run-tests.sh was not fixed correctly!"
  exit 1
fi

# Check run-tests.sh for quote fix
if [ -f "run-tests.sh" ] && grep -q "-j \$PARALLELISM" run-tests.sh; then
  echo "❌ The PARALLELISM variable in run-tests.sh is not properly quoted!"
  exit 1
fi

echo "✅ All specific fixes have been applied correctly!"

echo "===== NETCAT FIX VERIFICATION COMPLETE ====="
echo "The PR #911 should now pass pre-commit checks."
