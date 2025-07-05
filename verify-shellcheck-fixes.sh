#!/bin/bash
# Script to verify that all shellcheck issues have been fixed

set -e

echo "===== VERIFYING SHELLCHECK FIXES FOR PR #911 ====="

# Check if shellcheck is installed
if ! command -v shellcheck &> /dev/null; then
    echo "ERROR: shellcheck is not installed. Please install it first."
    exit 1
fi

# Check if pre-commit is installed
if ! command -v pre-commit &> /dev/null; then
    echo "ERROR: pre-commit is not installed. Please install it first."
    exit 1
fi

# Files to check
FILES=(
    "/workspaces/kube-burner/test/run-tests.sh"
    "/workspaces/kube-burner/run-tests.sh"
    "/workspaces/kube-burner/test/helpers.bash"
)

# Run shellcheck on each file
echo "Running shellcheck on individual files:"
for file in "${FILES[@]}"; do
    echo "Checking $file..."
    # Skip the disabled shellcheck rules in the file
    if [[ "$file" == "/workspaces/kube-burner/test/helpers.bash" ]]; then
        shellcheck -e SC2086,SC2068 -S warning "$file"
    else
        shellcheck -S warning "$file"
    fi
done

# Run pre-commit check for shellcheck
echo -e "\nRunning pre-commit shellcheck check:"
cd /workspaces/kube-burner && pre-commit run shellcheck

echo -e "\n===== VERIFICATION COMPLETED ====="
echo "If no errors were reported above, all shellcheck issues have been fixed!"
