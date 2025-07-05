#!/bin/bash
# Comprehensive script to fix all shellcheck issues in PR #911

set -e

echo "===== FIXING ALL SHELLCHECK ISSUES FOR PR #911 ====="

# Create backup of files before modifying them
mkdir -p /tmp/shellcheck-backups
cp /workspaces/kube-burner/test/run-tests.sh /tmp/shellcheck-backups/
cp /workspaces/kube-burner/run-tests.sh /tmp/shellcheck-backups/
cp /workspaces/kube-burner/test/helpers.bash /tmp/shellcheck-backups/

# Fix test/run-tests.sh - both glob pattern and quoting issues
echo "Fixing test/run-tests.sh..."
cat > /workspaces/kube-burner/test/run-tests.sh << 'EOT'
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
