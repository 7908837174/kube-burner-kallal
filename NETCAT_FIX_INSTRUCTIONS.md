# Netcat Fix Instructions

## Summary of Changes

This PR fixes shellcheck issues identified by pre-commit in the following files:

1. `/workspaces/kube-burner/test/run-tests.sh`:
   - Fixed SC2035: Used `./*.bats ./*.bash` instead of `*.bats *.bash` to prevent glob issues with filenames containing dashes
   - Fixed SC2086: Added quotes around `$PARALLELISM` to prevent word splitting and globbing

2. `/workspaces/kube-burner/run-tests.sh`:
   - Created this file if missing
   - Ensured proper quoting around `$PARALLELISM` to prevent SC2086 issues

3. `/workspaces/kube-burner/test/helpers.bash`:
   - Fixed SC2004: Removed unnecessary `$` in arithmetic expressions
   - Fixed SC2181: Replaced indirect exit code check with direct command check

## Verification

All shellcheck issues have been fixed and verified with:

```
pre-commit run shellcheck
```

This ensures our PR #911 passes all pre-commit checks.
