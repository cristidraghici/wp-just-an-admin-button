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
PROJECT="${BASH_SOURCE%/*}"
if [ -z ${PROJECT+x} ]; then PROJECT="$PWD"; fi

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

# Include .env if it exists
ENV="$PROJECT/.env"
if [[ $(file_exists "$ENV") ]]; then
  export $(grep -v '^#' $ENV | xargs)  > /dev/null 2>&1
fi

# Get which script to execute
CURRENT_SCRIPT="$1"

# Include the runner
if [[ $(file_exists "$PROJECT/bash/$CURRENT_SCRIPT.sh") ]]; then
  . "$PROJECT/bash/$CURRENT_SCRIPT.sh";
fi

exit 0;