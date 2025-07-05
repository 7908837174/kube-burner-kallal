#!/bin/bash
# Fix test/helpers.bash shellcheck issues

echo "Fixing unreachable code warning in cleanup_test_lock function..."
sed -i '111s/rm -rf/# Cleanup function\n    rm -rf/' test/helpers.bash

echo "Fixing NC_FOUND subshell issue..."
# Replace the subshell approach with a file-based approach
sed -i '323s/NC_FOUND=true/echo "true" > \/tmp\/nc_found/' test/helpers.bash
sed -i '332s/\[ "$NC_FOUND" != "true" \]/\[ ! -f \/tmp\/nc_found \] || \[ "$(cat \/tmp\/nc_found)" != "true" \]/' test/helpers.bash

echo "Committing fixes..."
git add test/helpers.bash
git commit -m "Fix shellcheck issues in test/helpers.bash"
git push --force-with-lease

echo "All helpers.bash fixes applied!"
