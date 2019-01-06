#!/bin/bash

# Exit if script is run directly
if [ -z ${PROJECT+x} ]; then exit; fi

# Intro on the function of the file
echo "Commit a trigger for the automatic release/publish...";

# Check git branch (needs to be `master`)
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$BRANCH" != "master" ]]; then
  echo '> The new release can only be created from the `master` branch.';
  echo '> Aborting..';
  exit 1;
fi

# Check release type parameter
if [ -z ${2+x} ] || [[ ! "patch minor major remove" =~ (^|[[:space:]])"$2"($|[[:space:]]) ]]; then
  echo '> Please specify the release type: `patch` `minor` `major`.';
  echo '> Use `remove` to delete the last release.';
  echo '> Aborting..';
  exit 1;
fi

# Update the repo
git add .
git commit -m "Updated versions [release $2]"
git push

echo "> Job done";
