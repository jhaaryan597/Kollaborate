#!/bin/bash
# THIS SCRIPT IS AUTOMATICALLY GENERATED AND SHOULD NOT BE RUN MANUALLY
# The following script is designed to be run by an automated agent.
# It may contain commands that could be harmful if not executed in the correct context.
#
# Purpose:
# This script removes a contributor from the git history.
#
# Instructions:
# 1. The script first finds the author's name and email from the git log.
# 2. It then uses git filter-repo to remove the contributor's commits.
# 3. Finally, it forces pushes the changes to the remote repository.

set -e

# Step 1: Find the author's name and email
AUTHOR_INFO=$(git log --pretty=format:"%an <%ae>" | grep "Aryan Jha" | head -n 1)

if [ -z "$AUTHOR_INFO" ]; then
    echo "Could not find contributor 'Aryan Jha' in the git log."
    exit 1
fi

AUTHOR_NAME=$(echo "$AUTHOR_INFO" | sed 's/ <.*//')
AUTHOR_EMAIL=$(echo "$AUTHOR_INFO" | sed 's/.*<//;s/>.*//')

echo "Found contributor: $AUTHOR_NAME <$AUTHOR_EMAIL>"

# Step 2: Use git filter-repo to remove the contributor's commits
# The user will be prompted to install git-filter-repo if it's not found.
if ! command -v git-filter-repo &> /dev/null
then
    echo "git-filter-repo could not be found. Please install it."
    echo "For example, on macOS with Homebrew: brew install git-filter-repo"
    exit 1
fi

git filter-repo --commit-callback "
    if commit.author_name == b'$AUTHOR_NAME' and commit.author_email == b'$AUTHOR_EMAIL':
        commit.message = b'[REDACTED]'
" --force

# Step 3: Add the remote back and force push the changes
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
git remote add origin https://github.com/jhaaryan597/Kollaborate.git
git push --force --set-upstream origin $BRANCH_NAME

echo "Contributor removed and changes pushed to the remote repository."
