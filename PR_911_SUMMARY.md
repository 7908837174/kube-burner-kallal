# PR #911 Summary - Shellcheck Issues Fixed

This PR fixes all the shellcheck issues that were flagged by pre-commit. The specific issues addressed were:

1. **SC2035**: Use `./*glob*` or `-- *glob*` for globs in shell scripts
   - Fixed in `/workspaces/kube-burner/test/run-tests.sh` with proper glob patterns: `chmod +x ./*.bats ./*.bash`

2. **SC2086**: Double quote to prevent globbing and word splitting
   - Fixed in `/workspaces/kube-burner/run-tests.sh` and `/workspaces/kube-burner/test/run-tests.sh` by ensuring variables are properly quoted: `"$PARALLELISM"`

3. **SC2004**: $/${} is unnecessary on arithmetic variables
   - Fixed in `/workspaces/kube-burner/test/helpers.bash` by removing unnecessary `$` in arithmetic expressions: `elapsed=$((elapsed + wait_interval))`

4. **SC2181**: Check exit code directly with e.g. 'if ! mycmd;', not indirectly with $?
   - Fixed throughout the codebase by replacing indirect checks with direct command checks

## Verification

All shellcheck issues have been fixed, and pre-commit checks pass successfully.

## Changes Made

1. Rewrote the script to use proper quoting and glob patterns
2. Fixed arithmetic expressions in `test/helpers.bash`
3. Improved direct command checking instead of using `$?`
4. Added proper quoting around variables to prevent word splitting

These changes improve the robustness and maintainability of the shell scripts in the repository.