#!/bin/bash

### CONFIG ###

GIT_BASEDIR=~/Sites/git
GIT_PULLCMD="git pull origin master"

### SCRIPT ###

PROGNAME=$(basename $0)
if [ "$1" = "-h" -o "$1" = "--help" ]; then
	echo "Usage: $PROGNAME [<username>]"
	echo "Update all git repositories found in a standard directory structure"
	echo ""
	exit 1
fi
USERNAME=$1

function update_all_repos {
	DIR=$GIT_BASEDIR/$1
	FOUND=0
	echo -e "\n\n----- $DIR -----"
	for repodir in $(ls -1 $DIR); do
		if [ -d $DIR/$repodir -a -d $DIR/$repodir/.git ]; then
			echo -e "\n-------- $repodir -------\n"
			cd $DIR/$repodir/ && $GIT_PULLCMD
			FOUND=1
		fi
	done
	if [ $FOUND = 0 ]; then
		echo -e "\n    (No git repositories found)"
	fi
}

if [ "$USERNAME" != "" ]; then
	USER_GIT_BASEDIR=$GIT_BASEDIR/$USERNAME
	if [ ! -d $USER_GIT_BASEDIR ]; then
		echo "Error: Cannot find user directory: $USER_GIT_BASEDIR"
		exit 1
	fi
	update_all_repos $USERNAME
	exit 0
fi

for userdir in $(ls -1 $GIT_BASEDIR); do
	[ -d $GIT_BASEDIR/$userdir ] && update_all_repos $userdir
done

