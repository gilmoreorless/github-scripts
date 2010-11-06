#!/bin/bash

### CONFIG ###

GIT_BASEDIR=~/Sites/git


### SCRIPT ###

PROGNAME=$(basename $0)
if [ $# -lt 2 ]; then
	echo "Usage: $PROGNAME <username> <repository> [ssh]"
	echo "Clone a repository from GitHub into a standard directory structure"
	echo ""
	echo "The clone URL passed to git is:"
	echo ""
	echo "    https://github.com/<username>/<repository>.git"
	echo ""
	echo "Optionally, if 'ssh' is passed as the third parameter the clone URL changes to:"
	echo ""
	echo "    git@github.com:<username>/<repository>.git"
	echo ""
	exit 1
fi
GITDIR=$GIT_BASEDIR/$1
[ ! -d $GITDIR ] && mkdir $GITDIR
if [ "$3" != "ssh" ]; then
	REPOS="https://github.com/"
else
	REPOS="git@github.com:"
fi
cd $GITDIR && git clone ${REPOS}${1}/${2}.git

