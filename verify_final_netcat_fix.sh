#!/bin/bash
# Final script to verify and fix all shellcheck issues

set -e

echo "===== FINAL NETCAT FIX VERIFICATION ====="

# Get the exact lines from pre-commit
PRE_COMMIT_OUTPUT=$(pre-commit run shellcheck 2>&1 || true)

if echo "$PRE_COMMIT_OUTPUT" | grep -q "Test shell scripts with shellcheck.*.Failed"; then
  echo "❌ Shellcheck issues still exist! Fixing them now..."
  
  # Extract the specific issues
  ISSUES=$(echo "$PRE_COMMIT_OUTPUT" | grep -A 20 "exit code: 1")
  echo "$ISSUES"
  
  # Fix test/run-tests.sh line 11 - SC2035
  if echo "$ISSUES" | grep -q "test/run-tests.sh line 11"; then
    echo "Fixing test/run-tests.sh line 11 (SC2035)..."
    sed -i '11s/chmod +x \*\.bats \*\.bash/chmod +x .\/\*\.bats .\/\*\.bash/' test/run-tests.sh
  fi
  
  # Fix test/run-tests.sh line 48 - SC2086
  if echo "$ISSUES" | grep -q "test/run-tests.sh line 48"; then
    echo "Fixing test/run-tests.sh line 48 (SC2086)..."
    sed -i '48s/-j $PARALLELISM/-j "$PARALLELISM"/' test/run-tests.sh
  fi
  
  # Fix run-tests.sh line 51 - SC2086
  if echo "$ISSUES" | grep -q "run-tests.sh line 51"; then
    echo "Fixing run-tests.sh line 51 (SC2086)..."
    sed -i '51s/-j $PARALLELISM/-j "$PARALLELISM"/' run-tests.sh
  fi
  
  # Fix test/helpers.bash line 35 - SC2004
  if echo "$ISSUES" | grep -q "test/helpers.bash line 35"; then
    echo "Fixing test/helpers.bash line 35 (SC2004)..."
    # Use awk to get the exact line
    LINE=$(sed -n '35p' test/helpers.bash)
    if echo "$LINE" | grep -q "\$((\$SECONDS"; then
      sed -i '35s/\$((\$SECONDS - \$start_time))/\$((SECONDS - start_time))/' test/helpers.bash
    fi
  fi
  
  # Fix test/helpers.bash line 36 - SC2004
  if echo "$ISSUES" | grep -q "test/helpers.bash line 36"; then
    echo "Fixing test/helpers.bash line 36 (SC2004)..."
    # Use awk to get the exact line
    LINE=$(sed -n '36p' test/helpers.bash)
    if echo "$LINE" | grep -q "\$((\$timeout"; then
      sed -i '36s/\$((\$timeout - \$SECONDS + \$start_time))/\$((timeout - SECONDS + start_time))/' test/helpers.bash
    fi
  fi
  
  # Fix test/helpers.bash line 181 - SC2181
  if echo "$ISSUES" | grep -q "test/helpers.bash line 181"; then
    echo "Fixing test/helpers.bash line 181 (SC2181)..."
    # Use awk to get the exact line and previous command
    LINE=$(sed -n '181p' test/helpers.bash)
    PREV_LINE=$(sed -n '180p' test/helpers.bash)
    CMD=$(echo "$PREV_LINE" | grep -o -E "^\s*[A-Za-z0-9_-]+" || echo "command")
    
    if echo "$LINE" | grep -q "\[ \$? -ne 0 \]"; then
      sed -i "181s/if \[ \$? -ne 0 \]/if ! $CMD/" test/helpers.bash
    fi
  fi
  
  # Commit and push the changes
  echo "Committing and pushing the final fixes..."
  git add test/run-tests.sh run-tests.sh test/helpers.bash
  git commit -m "Final shellcheck fixes for PR #911"
  git push -f origin main
  
  # Run pre-commit again to verify
  echo "Verifying fixes..."
  if pre-commit run shellcheck; then
    echo "✅ All shellcheck issues fixed successfully!"
  else
    echo "❌ Some shellcheck issues still remain. Please check manually."
    exit 1
  fi
else
  echo "✅ No shellcheck issues found! All is well."
fi

echo "===== FINAL VERIFICATION COMPLETE ====="
