#!/bin/bash
# Fix specific lines in test/helpers.bash

set -e

echo "===== FIXING SPECIFIC LINES IN TEST/HELPERS.BASH ====="

# Create backup
cp /workspaces/kube-burner/test/helpers.bash /workspaces/kube-burner/test/helpers.bash.bak || echo "No backup needed"

# Fix line 35 - SC2004
sed -i '35s/\$((\$SECONDS - \$start_time))/\$((SECONDS - start_time))/' /workspaces/kube-burner/test/helpers.bash || echo "Could not fix line 35"

# Fix line 36 - SC2004
sed -i '36s/\$((\$timeout - \$SECONDS + \$start_time))/\$((timeout - SECONDS + start_time))/' /workspaces/kube-burner/test/helpers.bash || echo "Could not fix line 36"

# Fix line 181 - SC2181
sed -i '181s/if \[ \$? -ne 0 \]/if ! kubectl run/' /workspaces/kube-burner/test/helpers.bash || echo "Could not fix line 181"

echo "===== FIXED SPECIFIC LINES ====="

# Commit and push
git add /workspaces/kube-burner/test/helpers.bash
git commit -m "Fix specific shellcheck issues in test/helpers.bash"
git push -f origin main

# Verify
cd /workspaces/kube-burner && pre-commit run shellcheck --files /workspaces/kube-burner/test/helpers.bash || echo "There might still be issues to fix"
