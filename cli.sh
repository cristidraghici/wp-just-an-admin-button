#!/bin/bash

# Check the operating system
OS="$(echo -e `uname`)"
if [[ $OS != 'Linux' && $OS != 'Darwin' ]]; then
  echo -e ""
  echo -e "\033[0;31m Your operating system is not supported.";
  echo -e ""
  exit;
fi

# Set the current path
PROJECT=$PWD

#
# Execute a given script
#

# Check file existence helper
function file_exists {
	if [ -f "$1" ]; then
		# exists
		echo -e 1
	else
		# does not
		# echo -e 0
		return
	fi
}
function directory_exists {
	if [ -d "$1" ]; then
		# exists
		echo -e 1
	else
		# does not
		# echo -e 0
		return
	fi
}
# Default error
function default_error {
  echo "Error encountered";
  exit 1;
}
# Replace some text in a file
function replace_text_in_file {
  local search=$1;
  local replace=$2;
  local file=$3;
  echo "${file} -> ${search} -> ${replace}"
  sed -i "" "s/${search}/${replace}/g" "${file}";
}

# Include .env if it exists
ENV="$PROJECT/.env"
if [[ $(file_exists "$ENV") ]]; then
  export $(grep -v '^#' $ENV | xargs)  > /dev/null 2>&1
fi

# Get which script to execute
CURRENT_SCRIPT="$1"

# Include the runner

echo "yeees3";
if [[ $(file_exists "$PROJECT/bash/$CURRENT_SCRIPT.sh") ]]; then
  echo "yeees2";
  . "$PROJECT/bash/$CURRENT_SCRIPT.sh";
fi

echo "yeees";

exit 0;
