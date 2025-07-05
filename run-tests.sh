#!/bin/bash
# run-tests.sh - Run tests for kube-burner

set -e

echo "===== RUNNING KUBE-BURNER TESTS ====="
cd /workspaces/kube-burner || exit 1

# Configure git
git config --global --add safe.directory /workspaces/kube-burner

# Set default parallelism
PARALLELISM="${PARALLELISM:-4}"

# Run the test
echo "===== RUNNING TESTS ====="
KUBE_BURNER=$KUBE_BURNER bats -F pretty -T --print-output-on-failure -j "$PARALLELISM" test/test-k8s.bats

echo "===== TESTS COMPLETED ====="
