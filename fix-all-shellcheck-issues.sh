#!/bin/bash
# Script to fix all shellcheck issues in the repository

set -e 

echo "===== FIXING ALL SHELLCHECK ISSUES ====="

# Function to detect and fix SC2035 issues (glob patterns without ./)
fix_sc2035() {
    echo "Fixing SC2035 issues (glob patterns without ./)..."
    # Fix glob patterns in test/run-tests.sh
    if [ -f "test/run-tests.sh" ]; then
        sed -i 's/chmod +x \*\.bats \*\.bash/chmod +x .\/\*\.bats .\/\*\.bash/g' test/run-tests.sh
    fi
}

# Function to detect and fix SC2086 issues (unquoted variables)
fix_sc2086() {
    echo "Fixing SC2086 issues (unquoted variables)..."
    # Fix unquoted variables in test/run-tests.sh
    if [ -f "test/run-tests.sh" ]; then
        sed -i 's/-j $PARALLELISM/-j "$PARALLELISM"/g' test/run-tests.sh
    fi
    
    # Fix unquoted variables in run-tests.sh
    if [ -f "run-tests.sh" ]; then
        sed -i 's/-j $PARALLELISM/-j "$PARALLELISM"/g' run-tests.sh
    fi
}

# Function to detect and fix SC2004 issues (unnecessary $ in arithmetic expressions)
fix_sc2004() {
    echo "Fixing SC2004 issues (unnecessary $ in arithmetic expressions)..."
    # Fix arithmetic expressions in test/helpers.bash
    if [ -f "test/helpers.bash" ]; then
        sed -i 's/\$((\$SECONDS - \$start_time))/\$((SECONDS - start_time))/g' test/helpers.bash
        sed -i 's/\$((\$timeout - \$SECONDS + \$start_time))/\$((timeout - SECONDS + start_time))/g' test/helpers.bash
    fi
}

# Function to detect and fix SC2181 issues (checking $? instead of direct command check)
fix_sc2181() {
    echo "Fixing SC2181 issues (checking exit code with $?)..."
    # Fix exit code checks in test/helpers.bash
    if [ -f "test/helpers.bash" ]; then
        # We need to check each line number reported to fix properly
        while IFS= read -r line_info; do
            line_num=$(echo "$line_info" | cut -d: -f1)
            if [ -n "$line_num" ]; then
                echo "Fixing exit code check at line $line_num"
                cmd_line=$((line_num - 1))
                command=$(sed -n "${cmd_line}p" test/helpers.bash)
                cmd_name=$(echo "$command" | awk '{print $1}')
                
                if [ -n "$cmd_name" ]; then
                    sed -i "${line_num}s/if \[ \$? -ne 0 \]/if ! ${cmd_name}/" test/helpers.bash
                else
                    sed -i "${line_num}s/if \[ \$? -ne 0 \]/if ! command/" test/helpers.bash
                fi
            fi
        done < <(grep -n "if \[ \$? -ne 0 \]" test/helpers.bash || echo "")
    fi
}

# Run all fix functions
fix_sc2035
fix_sc2086
fix_sc2004
fix_sc2181

# Manually recreate or fix files that might be causing issues
echo "===== CREATING FIXED VERSIONS OF KEY FILES ====="

# Create test/run-tests.sh
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

# Create run-tests.sh
cat > run-tests.sh << 'EOT'
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
EOT
chmod +x run-tests.sh

echo "===== ALL FIXES APPLIED ====="

# Run pre-commit to verify
echo "===== VERIFYING FIXES ====="
pre-commit run shellcheck || echo "Some shellcheck issues might still remain"

echo "===== DONE ====="
