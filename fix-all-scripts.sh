#!/bin/bash
# Fix all shell scripts with shellcheck issues

# Fix push-tag-changes.sh missing shebang
echo "Fixing push-tag-changes.sh..."
if [ -f push-tag-changes.sh ]; then
  sed -i '1i#!/bin/bash' push-tag-changes.sh
  echo "Added shebang to push-tag-changes.sh"
fi

# Fix double quotes in push-all-commits scripts
echo "Fixing push-all-commits scripts..."
for file in push-all-commits*.sh; do
  if [ -f "$file" ]; then
    echo "Fixing $file..."
    sed -i 's/git push origin $CURRENT_BRANCH/git push origin "$CURRENT_BRANCH"/g' "$file"
    sed -i 's/git pull --rebase origin $CURRENT_BRANCH/git pull --rebase origin "$CURRENT_BRANCH"/g' "$file"
    sed -i 's/git push --force-with-lease origin $CURRENT_BRANCH/git push --force-with-lease origin "$CURRENT_BRANCH"/g' "$file"
    sed -i 's/git push -f origin $CURRENT_BRANCH/git push -f origin "$CURRENT_BRANCH"/g' "$file"
  fi
done

# Fix sync-fork-and-pr.sh echo expansion
echo "Fixing sync-fork-and-pr.sh..."
if [ -f sync-fork-and-pr.sh ]; then
  sed -i 's/echo "     --body/printf "     --body/g' sync-fork-and-pr.sh
  echo "Fixed echo to printf in sync-fork-and-pr.sh"
fi

# Fix push-all-changes.sh SC2015
echo "Fixing push-all-changes.sh..."
if [ -f push-all-changes.sh ]; then
  sed -i 's/git push origin main && {/git push origin main || {/g' push-all-changes.sh
  sed -i 's/git push --force-with-lease origin main && {/git push --force-with-lease origin main || {/g' push-all-changes.sh
  sed -i 's/git push -f origin main && {/git push -f origin main || {/g' push-all-changes.sh
  echo "Fixed SC2015 issues in push-all-changes.sh"
fi

echo "Committing fixes..."
git add push-tag-changes.sh push-all-commits*.sh sync-fork-and-pr.sh push-all-changes.sh
git commit -m "Fix shellcheck issues in push scripts"
git push --force-with-lease

echo "All script fixes applied and pushed!"
