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
LIST_GOOD=""
LIST_BAD=""

function update_all_repos {
	DIR=$GIT_BASEDIR/$1
	FOUND=0
	echo -e "\n\n----- $DIR -----"
	for repodir in $(ls -1 $DIR); do
		if [ -d $DIR/$repodir -a -d $DIR/$repodir/.git ]; then
			echo -e "\n-------- $repodir -------\n"
			cd $DIR/$repodir/ && $GIT_PULLCMD
			if [ $? = 0 ]; then
				LIST_GOOD="${LIST_GOOD}$1/$repodir\n"
			else
				LIST_BAD="${LIST_BAD}$1/$repodir\n"
			fi
			FOUND=1
		fi
	done
	if [ $FOUND = 0 ]; then
		echo -e "\n    (No git repositories found)"
	fi
}

function output_stats {
	echo -e "\n\n--- SUCCESSFUL ---\n"
	[ -n "$LIST_GOOD" ] && echo -e $LIST_GOOD || echo -e "(No successful updates)\n"
	echo -e "\n--- FAILED ---\n"
	[ -n "$LIST_BAD" ] && echo -e $LIST_BAD || echo -e "(No failed updates)\n"
}

if [ "$USERNAME" != "" ]; then
	USER_GIT_BASEDIR=$GIT_BASEDIR/$USERNAME
	if [ ! -d $USER_GIT_BASEDIR ]; then
		echo "Error: Cannot find user directory: $USER_GIT_BASEDIR"
		exit 1
	fi
	update_all_repos $USERNAME
	output_stats
	exit 0
fi

for userdir in $(ls -1 $GIT_BASEDIR); do
	[ -d $GIT_BASEDIR/$userdir ] && update_all_repos $userdir
	output_stats
done

