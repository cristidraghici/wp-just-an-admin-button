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

echo "> Replacing version in repository files...";

# readme.txt
LINE="Stable tag: $VERSION"
REPLACE="Stable tag: $NEW_VERSION"
FILE="$PROJECT/src/readme.txt"
replace_text_in_file "$LINE" "$REPLACE" "$FILE";
# just-an-admin-button.php
LINE="Version: $VERSION"
REPLACE="Version: $NEW_VERSION"
FILE="$PROJECT/src/just-an-admin-button.php"
replace_text_in_file "$LINE" "$REPLACE" "$FILE";
# README.md
LINE="Current version: $VERSION"
REPLACE="Current version: $NEW_VERSION"
FILE="$PROJECT/README.md"
replace_text_in_file "$LINE" "$REPLACE" "$FILE";

# Copy a placeholder of the entry script for the users who will download the plugin directly from github.com
SOURCE="$PROJECT/src/just-an-admin-button.php"
DEST="$PROJECT/plugin.php"
cp $SOURCE $DEST;
sed -i "" '/line-used-to-generate-placeholder-entry-file.*/,$ d' $DEST
echo "include( plugin_dir_path( __FILE__ ) . 'src/just-an-admin-button.php'); ?>" >> $DEST;

# Hack to update from wordpress after install
LINE="Version: $NEW_VERSION"
REPLACE="Version: 0.0.1"
replace_text_in_file "$LINE" "$REPLACE" "$DEST";

#
# Update the repo
#

git add .
git commit -m "Updated versions"
git push

echo "> Updating the repository...";

git tag -a "v$NEW_VERSION" -m "Version v$NEW_VERSION";

updateSemverFile

git push origin "v$NEW_VERSION";

echo "> Job done";
