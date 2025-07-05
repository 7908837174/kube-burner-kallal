# Shellcheck Fixes for PR #911

This PR addresses all shellcheck issues identified by pre-commit in the kube-burner repository.

## Issues Fixed

1. **SC2035 in test/run-tests.sh**
   - Fixed glob patterns by using `./` prefix to prevent issues with filenames containing dashes
   - Changed `chmod +x *.bats *.bash` to `chmod +x ./*.bats ./*.bash`

2. **SC2086 in test/run-tests.sh and run-tests.sh**
   - Added quotes around `$PARALLELISM` variable to prevent word splitting and globbing
   - Changed `-j $PARALLELISM` to `-j "$PARALLELISM"`

3. **SC2004 in test/helpers.bash**
   - Removed unnecessary `$` in arithmetic expressions
   - Changed `$(($SECONDS - $start_time))` to `$((SECONDS - start_time))`
   - Changed `$(($timeout - $SECONDS + $start_time))` to `$((timeout - SECONDS + start_time))`

4. **SC2181 in test/helpers.bash**
   - Replaced indirect exit code checks with direct command checks
   - Changed `if [ $? -ne 0 ]` to `if ! command`

## Verification

All fixes have been verified with pre-commit:

```bash
pre-commit run shellcheck --files test/run-tests.sh run-tests.sh test/helpers.bash
pre-commit run --all-files
```

All shellcheck issues have been resolved, improving code quality and reliability.
