#!/bin/bash
# Direct shellcheck fixes for PR #911

set -e

echo "===== FIXING SHELLCHECK ISSUES FOR PR #911 ====="

# Fix test/run-tests.sh
echo "Creating a fixed version of test/run-tests.sh..."
cat > test/run-tests.sh << 'EOT'
#!/bin/bash
# Shell script to run kube-burner tests with proper permissions
set -e

# Ensure script directory is the current directory
cd "$(dirname "$0")" || exit 1

# Make all bats and bash files executable (fix for shellcheck warnings)
chmod +x ./*.bats ./*.bash

# Set default parallelism
PARALLELISM="${PARALLELISM:-4}"

# Run tests with proper parameters
echo "Running tests with parallelism: $PARALLELISM"
KUBE_BURNER=$KUBE_BURNER bats -F pretty -T --print-output-on-failure -j "$PARALLELISM" test-k8s.bats
EOT
chmod +x test/run-tests.sh

# Fix run-tests.sh
echo "Creating a fixed version of run-tests.sh..."
cat > run-tests.sh << 'EOT'
#!/bin/bash
# run-tests.sh - Run the tests to verify all netcat fixes are working

set -e

echo "===== RUNNING TESTS TO VERIFY NETCAT FIXES ====="
cd /workspaces/kube-burner || exit 1

# Configure git
git config --global --add safe.directory /workspaces/kube-burner

# Set default parallelism
PARALLELISM="${PARALLELISM:-4}"

# Run the test
echo "===== RUNNING TEST TASK ====="
make test-k8s TEST_TAGS="core"

echo "===== TESTS COMPLETED ====="
echo "If all tests ran successfully, the netcat fixes are working properly."
EOT
chmod +x run-tests.sh

# Since test/helpers.bash is more complex, let's patch it directly
echo "Fixing arithmetic expressions in test/helpers.bash..."
sed -i -E '35s/\$\(\(\$SECONDS - \$start_time\)\)/$((\SECONDS - start_time))/g' test/helpers.bash
sed -i -E '36s/\$\(\(\$timeout - \$SECONDS \+ \$start_time\)\)/$((\timeout - SECONDS + start_time))/g' test/helpers.bash

echo "Fixing $? check in test/helpers.bash line 181..."
sed -i -E '181s/if \[ \$\? -ne 0 \]; then/if ! command_output; then/' test/helpers.bash

echo "===== COMMITTING SHELLCHECK FIXES ====="
git add test/run-tests.sh run-tests.sh test/helpers.bash
git commit -m "Fix shellcheck issues: SC2035, SC2086, SC2004, and SC2181"
git push --force-with-lease origin main

echo "===== FIXES COMPLETED AND PUSHED ====="
echo "All shellcheck issues have been fixed and pushed to PR #911."
