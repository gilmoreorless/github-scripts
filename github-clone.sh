#!/bin/bash

source `dirname $0`/github-config.sh

PROGNAME=$(basename $0)
function usage {
	echo "Usage: $PROGNAME [-s] [-f] <username> <repository>"
	echo "Clone a repository from GitHub into a standard directory structure"
	echo ""
	echo "The clone URL passed to git is:"
	echo ""
	echo "    https://github.com/<username>/<repository>.git"
	echo ""
	echo "Optionally, if '-s' (ssh) is passed as an option the clone URL changes to:"
	echo ""
	echo "    git@github.com:<username>/<repository>.git"
	echo ""
	echo "By default, dependencies are auto-installed using the list below."
	echo "You can pass the '-f' (flat) option to prevent this behaviour."
	echo ""
	echo "Dependencies are installed based on the presence of particular files:"
	echo ""
	echo "    package.json -> 'npm install'"
	echo "    bower.json -> 'bower install'"
	echo "    (more to come)"
	echo ""
	echo "NOTE: Auto-install blindly assumes you have the right installers available."
	echo ""
	exit 1
}

if [ $# -lt 2 ]; then
	usage
fi

# Parse options
OPT_SSH=0
OPT_FLAT=0
while getopts "sf" opt
do
	case $opt in
		s) OPT_SSH=1;;
		f) OPT_FLAT=1;;
		[?]) usage;;
	esac
done
OPTIND=$OPTIND-1
shift $OPTIND

# Work out clone URL
GITDIR=$GIT_BASEDIR/$1
[ ! -d $GITDIR ] && mkdir $GITDIR
if [ "$OPT_SSH" = "1" ]; then
	REPOS="git@github.com:"
else
	REPOS="https://github.com/"
fi
cd $GITDIR
git clone ${REPOS}${1}/${2}.git

# Auto-install
if [ "$OPT_FLAT" = "0" ]; then
	cd ${2}
	echo ""
	echo "Attempting auto-install..."
	echo ""
	if [ -f "package.json" ]; then
		echo "FOUND: package.json"
		echo ""
		npm install
	fi
	if [ -f "bower.json" ]; then
		echo "FOUND: bower.json"
		echo ""
		bower install
	fi
fi

# popd
