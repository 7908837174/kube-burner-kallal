#!/bin/bash
# run-tests.sh - Run the tests to verify all netcat fixes are working

set -e

echo "===== RUNNING TESTS TO VERIFY NETCAT FIXES ====="
cd /workspaces/kube-burner

# Configure git
git config --global --add safe.directory /workspaces/kube-burner

# Run the test
echo "===== RUNNING TEST TASK ====="
make test-k8s TEST_TAGS="core"

echo "===== TESTS COMPLETED ====="
echo "If all tests ran successfully, the netcat fixes are working properly."
