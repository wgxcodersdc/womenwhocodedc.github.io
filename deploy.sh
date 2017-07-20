#!/bin/bash
set -e # exit with nonzero exit code if anything fails

# Initial hugo build to test the project
# Output is not user-friendly, so this first build just catches any errors
HUGO_BUILD=$(hugo)

if [[ $HUGO_BUILD == *ERROR* ]]
  then
  echo "There are errors in your Hugo build, aborting script"
  hugo
  exit 1
fi

echo "Building Hugo website"

# Build the site and use standard output
hugo

echo "Hugo build succeeded!"

# Only push to gh-pages if on the master branch

if [[ $TRAVIS_BRANCH = "dev" ]]
then 

  echo -e "\033[0;32m On $TRAVIS_BRANCH branch, publishing to Github Pages\033[0m"

  # Set git config so Travis doesn't complain that it doesn't know who we are

  git config user.name "WWCDC Travis CI build"
  git config user.email "wwcodedc@gmail.com"

  # add CNAME please?
  echo "staging.womenwhocodedc.com" > public/CNAME

  # Add changes to git.
  git add -A
  # Force adding changes on the ignored public folder
  git add -f public

  # Commit changes.
  msg="rebuilding site `date`"
  if [ $# -eq 1 ]
    then msg="$1"
  fi
  git commit -m "$msg"

  # Push source and build repos.
  git subtree split --prefix=public -b master
  git push -f "https://$GITHUB_USER:$GITHUB_API_KEY@$GH_REF" master:master
  git branch -D master

fi

# If not on dev then don't push to gh-pages

if [[ $TRAVIS_BRANCH != "dev" ]]
then 

  echo "Not on dev branch, not updating WWCDC public website"
  echo "On $TRAVIS_BRANCH branch, not pushing to master"

fi
