#!/bin/bash

# Exit if script is run directly
if [ -z ${PROJECT+x} ]; then exit; fi

# Intro on the function of the file
echo "Publishing the new release to the Wordpress plugin repository.."

# Check WP credentials
if [[ -z "$WP_ORG_USERNAME" ]] || [[ -z "$WP_ORG_PASSWORD" ]]; then
	echo "> WordPress.org credentials not set" 1>&2;
  echo "> Aborting.."
	exit 1;
fi

# Get the current version
VERSION="$(git describe | cut -c 2-6)"

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
WORK_DIR_PATH="$PROJECT/$WORK_DIR"
if [[ ! $(directory_exists "$WORK_DIR_PATH") ]]; then
  mkdir "$WORK_DIR_PATH";
fi
cd $WORK_DIR_PATH;

# Remove any unzipped dir so we start from scratch
rm -fR "$PLUGIN"

# Get the current source
mkdir "$PLUGIN"

# Copy the plugin file
SOURCE="$PROJECT/src/*"
DEST="./$PLUGIN"
cp -r $SOURCE $DEST

# Clean up any previous svn dir
rm -fR svn

# Checkout the SVN repo
svn co -q "http://svn.wp-plugins.org/$PLUGIN" svn || default_error

# Move out the trunk directory to a temp location
mv svn/trunk ./svn-trunk
# Create trunk directory
mkdir svn/trunk
# Copy our new version of the plugin into trunk
rsync -r -p $PLUGIN/* svn/trunk

# Copy all the .svn folders from the checked out copy of trunk to the new trunk.
# This is necessary as the Travis container runs Subversion 1.6 which has .svn dirs in every sub dir
cd svn/trunk/
TARGET=$(pwd)
cd ../../svn-trunk/

# Find all .svn dirs in sub dirs
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

# Back to builds dir
cd ../

# Remove checked out dir
rm -fR svn-trunk

# Add new version tag
mkdir svn/tags/$VERSION
rsync -r -p $PLUGIN/* svn/tags/$VERSION

# Add new files to SVN
svn stat svn | grep '^?' | awk '{print $2}' | xargs -I x svn add x@
# Remove deleted files from SVN
svn stat svn | grep '^!' | awk '{print $2}' | xargs -I x svn rm --force x@
svn stat svn

# Commit to SVN
svn ci --no-auth-cache --username $WP_ORG_USERNAME --password $WP_ORG_PASSWORD svn -m "Deploy version $VERSION" || default_error

# Remove SVN temp dir
rm -fR svn

echo "> New plugin version published"
