#!/bin/bash

# Exit if script is run directly
if [ -z ${PROJECT+x} ]; then exit; fi

# Intro on the function of the file
echo "Creating a new release on github...";

# Check git branch (needs to be `master`)
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$BRANCH" != "master" ]]; then
  echo '> The new release can only be created from the `master` branch.';
  echo '> Aborting..';
  exit 1;
fi

# Get the current version
VERSION_TAG="$($PROJECT/lib/versiontag/versiontag current)"
VERSION="$(echo "$VERSION_TAG" | cut -c 19-)"

echo "> Current version: v$VERSION";

# Check release type parameter
if [ -z ${2+x} ] || [[ ! "patch minor major remove" =~ (^|[[:space:]])"$2"($|[[:space:]]) ]]; then
  echo '> Please specify the release type: `patch` `minor` `major`.';
  echo '> Use `remove` to delete the last release.';
  echo '> Aborting..';
  exit 1;
fi

#
# Create a new version (use `-f` param to force the creation)
#

# Overwrite exit
function exit { echo "exit $@"; }

# New version
echo '> Dry run is being performed, to get the new version: ';
. $PROJECT/lib/versiontag/versiontag --dry --force $2
echo '> Dry run completed';

# Restore exit
function exit { builtin exit $@; }

# Get the current version
NEW_VERSION="$major.$minor.$patch"

echo "> New version: v$NEW_VERSION";

#
# Add the new version in the plugin files
#
function update_version {
  local search=$1;
  local replace=$2;
  local file=$3;
  echo "${file} -> ${search} -> ${replace}"
  sed -i "" "s/${search}/${replace}/g" "${file}";
}

echo "> Replacing version in repository files...";

# readme.txt
LINE="Stable tag: $VERSION"
REPLACE="Stable tag: $NEW_VERSION"
FILE="$PROJECT/src/readme.txt"
update_version "$LINE" "$REPLACE" "$FILE";
# just-an-admin-button.php
LINE="Version: $VERSION"
REPLACE="Version: $NEW_VERSION"
FILE="$PROJECT/src/just-an-admin-button.php"
update_version "$LINE" "$REPLACE" "$FILE";
# README.md
LINE="Current version: $VERSION"
REPLACE="Current version: $NEW_VERSION"
FILE="$PROJECT/README.md"
update_version "$LINE" "$REPLACE" "$FILE";

#
# Update the repo
#

echo "> Updating the repository...";

git tag "v$NEW_VERSION";

updateSemverFile

git push origin "v$NEW_VERSION";

echo "> Job done";
