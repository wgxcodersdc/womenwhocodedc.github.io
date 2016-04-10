#!/bin/bash

echo -e "\033[0;32mRunning Travis test for WWCDC website\033[0m"

# Set git config so Travis doesn't complain that it doesn't know who we are

git config user.name "WWCDC Travis CI build"
git config user.email "wwcodedc@gmail.com"

# Build the project.
hugo

# Only push to gh-pages if on the master branch

if [[ $TRAVIS_BRANCH = "master" ]]
then 
  echo -e "\033[0;32m On $TRAVIS_BRANCH branch, publishing to Github Pages\033[0m"

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

# If not on master then don't push to gh-pages

if [[ $TRAVIS_BRANCH != "master" ]]
then 

  echo "Not on master branch, not updating WWCDC public website"
  echo "On $TRAVIS_BRANCH branch, not pushing to gh-pages"

fi