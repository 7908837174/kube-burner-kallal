#!/bin/bash
# Script to directly fix all shellcheck issues identified in pre-commit output

set -e

echo "===== FIXING SHELLCHECK ISSUES ====="

# Create backups
mkdir -p /tmp/shellcheck-fixes-backup
cp -f /workspaces/kube-burner/test/run-tests.sh /tmp/shellcheck-fixes-backup/ || true
cp -f /workspaces/kube-burner/run-tests.sh /tmp/shellcheck-fixes-backup/ || true
cp -f /workspaces/kube-burner/test/helpers.bash /tmp/shellcheck-fixes-backup/ || true

# Fix test/run-tests.sh - SC2035 (line 11)
echo "Fixing SC2035 in test/run-tests.sh"
sed -i 's/chmod +x \*\.bats \*\.bash/chmod +x .\/\*\.bats .\/\*\.bash/g' /workspaces/kube-burner/test/run-tests.sh

# Fix test/run-tests.sh - SC2086 (line 48)
echo "Fixing SC2086 in test/run-tests.sh"
sed -i 's/-j $PARALLELISM/-j "$PARALLELISM"/g' /workspaces/kube-burner/test/run-tests.sh

# Fix run-tests.sh - SC2086 (line 51)
echo "Fixing SC2086 in run-tests.sh"
sed -i 's/-j $PARALLELISM/-j "$PARALLELISM"/g' /workspaces/kube-burner/run-tests.sh

# Fix test/helpers.bash - SC2004 (line 35)
echo "Fixing SC2004 in test/helpers.bash (line 35)"
sed -i 's/\$\(\(\$SECONDS - \$start_time\)\)/\$\(\(SECONDS - start_time\)\)/g' /workspaces/kube-burner/test/helpers.bash

# Fix test/helpers.bash - SC2004 (line 36)
echo "Fixing SC2004 in test/helpers.bash (line 36)"
sed -i 's/\$\(\(\$timeout - \$SECONDS + \$start_time\)\)/\$\(\(timeout - SECONDS + start_time\)\)/g' /workspaces/kube-burner/test/helpers.bash

# Fix test/helpers.bash - SC2181 (line 181)
echo "Fixing SC2181 in test/helpers.bash (line 181)"
# First, get line 180 to extract the command name
LINE_180=$(sed -n '180p' /workspaces/kube-burner/test/helpers.bash)
# Extract command name
COMMAND=$(echo "$LINE_180" | awk '{print $1}')
if [[ -n "$COMMAND" ]]; then
  # Replace line 181
  sed -i '181s/if \[ \$\? -ne 0 \]; then/if ! '"$COMMAND"'; then/g' /workspaces/kube-burner/test/helpers.bash
else
  # Generic replacement if command cannot be identified
  sed -i '181s/if \[ \$\? -ne 0 \]; then/if ! command_output; then/g' /workspaces/kube-burner/test/helpers.bash
fi

echo "===== SHELLCHECK FIXES COMPLETE ====="
echo "Now running pre-commit to verify fixes..."
cd /workspaces/kube-burner && pre-commit run shellcheck
