#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
hugo -t wwcdc

git config user.name "Travis CI"
git config user.email "<you>@<your-email>"

# Add changes to git.
git add -A

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git subtree push --prefix=public "https://$GH_TOKEN@$GH_REF" gh-pages > /dev/null 2>&1

