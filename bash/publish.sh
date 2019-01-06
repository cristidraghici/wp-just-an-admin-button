#!/bin/bash

# Exit if script is run directly
if [ -z ${PROJECT+x} ]; then exit; fi

# Intro on the function of the file
echo "Publishing the new release to the Wordpress plugin repository.."

# Check the repo name (loaded from the .env file)
if [[ -z "$PLUGIN" ]] || [[ -z "$WORK_DIR" ]]; then
	echo "> Plugin name or work dir not set" 1>&2;
  echo "> Aborting.."
	exit 1;
fi

# Check WP credentials
if [[ -z "$WP_ORG_USERNAME" ]] || [[ -z "$WP_ORG_PASSWORD" ]]; then
	echo "> WordPress.org credentials not set" 1>&2;
  echo "> Aborting.."
	exit 1;
fi

# Get the current version
VERSION="$(cat .version)"
if [[ -z "$VERSION" ]]; then
	VERSION="0.0.1"
fi

# # Check if the tag exists for the version we are building
TAG=$(svn ls "https://plugins.svn.wordpress.org/$PLUGIN/tags/$VERSION")
error=$?
if [ $error == 0 ]; then
  # Tag exists, don't deploy
  echo "> Tag already exists for version $VERSION, aborting deployment";
  echo '> Aborting..';
  exit 1
fi

# Clean and set the workdir/build directory
NEW_PLUGIN_SRC="$PROJECT/src"
WORK_DIR_PATH="$PROJECT/$WORK_DIR"
PLUGIN_PATH="$PROJECT/$WORK_DIR/$PLUGIN"
SVN_PATH="$PROJECT/$WORK_DIR/svn"

rm -fR "$WORK_DIR_PATH"

mkdir -p "$WORK_DIR_PATH"
mkdir -p "$PLUGIN_PATH"

# Copy the plugin files
cp -r "$NEW_PLUGIN_SRC/" "$PLUGIN_PATH"

# Go to the workdir and get the svn repo
svn co -q "http://svn.wp-plugins.org/$PLUGIN" "$SVN_PATH" || default_error

# Move out the trunk directory to a temp location
mv "$SVN_PATH/trunk/" "$WORK_DIR_PATH/svn-trunk"

# Make the necessary changes
## new trunk
mv "$PLUGIN_PATH" "$SVN_PATH/trunk"
## new assets
mv "$SVN_PATH/trunk/assets/" "$SVN_PATH"
## new tag
cp -r "$SVN_PATH/trunk" "$SVN_PATH/tags/$VERSION"

# Copy all the .svn folders from the checked out copy of trunk to the new trunk
cd "$WORK_DIR_PATH/svn-trunk"
# Find all .svn dirs in sub dirs
TARGET="$SVN_PATH/trunk"
SVN_DIRS=`find . -type d -iname .svn`
for SVN_DIR in $SVN_DIRS; do
    SOURCE_DIR=${SVN_DIR/.}
    TARGET_DIR=$TARGET${SOURCE_DIR/.svn}
    TARGET_SVN_DIR=$TARGET${SVN_DIR/.}
    if [ -d "$TARGET_DIR" ]; then
        # Copy the .svn directory to trunk dir
        cp -r $SVN_DIR $TARGET_SVN_DIR
    fi
done

# Back to the build dir
cd "../"

# Add new files to SVN
svn stat svn | grep '^?' | awk '{print $2}' | xargs -I x svn add x@
# Remove deleted files from SVN
svn stat svn | grep '^!' | awk '{print $2}' | xargs -I x svn rm --force x@
svn stat svn

# Commit to SVN
svn ci --no-auth-cache --username $WP_ORG_USERNAME --password $WP_ORG_PASSWORD svn -m "Deploy version $VERSION" || default_error

# Remove SVN temp dir
rm -fR "$WORK_DIR_PATH"

echo "> New plugin version published"
