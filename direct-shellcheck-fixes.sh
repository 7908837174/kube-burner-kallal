#!/bin/bash
# Direct fixes for shellcheck issues

# Fix for test/helpers.bash
# We need to locate the exact lines with the issues
echo "Fixing line 35 and 36 in test/helpers.bash..."
sed -i '35s/\$((\$SECONDS - \$start_time))/$((\SECONDS - start_time))/g' test/helpers.bash
sed -i '36s/\$((\$timeout - \$SECONDS + \$start_time))/$((\timeout - SECONDS + start_time))/g' test/helpers.bash

# Fix for line 181
echo "Fixing line 181 in test/helpers.bash..."
sed -i '181s/if \[ \$? -ne 0 \]; then/if ! command_output; then/' test/helpers.bash

# Check if our fixes were applied
echo "Checking if fixes were applied..."
sed -n '35,36p;181p' test/helpers.bash

echo "Fixes attempted. Please check the output above."
