#!/bin/bash

echo -e "\033[0;32mRunning Travis test for WWCDC website\033[0m"

#git config user.name "Travis CI"
#git config user.email "<you>@<your-email>"

# Build the project.
hugo

# Get the current branch name
branch_name=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)

if [ $branch_name = "master" ]
then 
  echo -e "\033[0;32m On master branch, publishing to Github Pages\033[0m"

  toreturn=$?

  if [ $toreturn -eq 0 ] 
  then
    # Add changes to git.
    git add -A

    # Commit changes.
    msg="rebuilding site `date`"
    if [ $# -eq 1 ]
      then msg="$1"
    fi
    git commit -m "$msg"

    # Push source and build repos.
    git subtree split --prefix=public -b gh-pages
    git push -f "https://$GH_TOKEN@$GH_REF" gh-pages:gh-pages > /dev/null 2>&1
    git branch -D gh-pages
  fi
  exit $toreturn

fi

if [ $branch_name != "master" ]
then 

  echo "Not on master branch, not updating WWCDC public website"
  echo "On $branch_name branch, not pushing to gh-pages"

fi