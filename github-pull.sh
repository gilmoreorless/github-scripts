#!/bin/bash

source `dirname $0`/github-config.sh

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
LIST_SKIPPED=""
LIST_IGNORED=""
START_TIME=$(date +%s)

function update_all_repos {
	DIR=$GIT_BASEDIR/$1
	FOUND=0
	echo -e "\n\n----- $DIR -----"
	for repodir in $(ls -1 $DIR); do
		if [ -d $DIR/$repodir -a -d $DIR/$repodir/.git ]; then
			echo -e "\n-------- $repodir -------\n"
			cd $DIR/$repodir/
			STATUS=$(git status -s)
			if [ "$STATUS" = "" ]; then
				git checkout master && $GIT_PULLCMD
				if [ $? = 0 ]; then
					LIST_GOOD="${LIST_GOOD}$1/$repodir\n"
				else
					LIST_BAD="${LIST_BAD}$1/$repodir\n"
				fi
			else
				echo "Uncommitted changes found... skipping repository"
				LIST_SKIPPED="${LIST_SKIPPED}$1/$repodir\n"
			fi
			FOUND=1
		fi
	done
	if [ $FOUND = 0 ]; then
		echo -e "\n    (No git repositories found)"
	fi
}

function output_stats {
	END_TIME=$(date +%s)
	TOTAL_TIME=$(($END_TIME - $START_TIME))
	echo -e "\n\n--- SUCCESSFUL ---\n"
	[ -n "$LIST_GOOD" ] && echo -e $LIST_GOOD || echo -e "(No successful updates)\n"
	echo -e "\n--- FAILED ---\n"
	[ -n "$LIST_BAD" ] && echo -e $LIST_BAD || echo -e "(No failed updates)\n"
	echo -e "\n--- SKIPPED (Uncommitted changes found) ---\n"
	[ -n "$LIST_SKIPPED" ] && echo -e $LIST_SKIPPED || echo -e "(No skipped repositories)\n"
	echo -e "\n--- IGNORED USERNAMES ---\n"
	[ -n "$LIST_IGNORED" ] && echo -e $LIST_IGNORED || echo -e "(No ignored usernames)\n"
	echo -e "\nTOTAL TIME: ${TOTAL_TIME}s\n"
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
	if [ -d $GIT_BASEDIR/$userdir ]; then
		# There's probably a better way to do this filtering, but I can't be bothered searching for it
		SKIP_USER=$(echo " $PULL_IGNOREUSERNAMES " | grep " $userdir ")
		if [ "$SKIP_USER" == "" ]; then
			update_all_repos $userdir
		else
			echo -e "\n\n----- $userdir (IGNORED) -----"
			LIST_IGNORED="${LIST_IGNORED}$userdir\n"
		fi
	fi
done
output_stats

