#!/bin/bash
USERNAME=$1
GITPULLCMD="git pull origin master"
GITDIR=~/Sites/git

function updateAllRepos {
	DIR=$GITDIR/$1
	echo -e "\n\n----- $DIR -----"
	# Do git pull origin master here
	for repodir in $(ls -1 $DIR); do
		if [ -d $DIR/$repodir -a -d $DIR/$repodir/.git ]; then
			echo -e "\n-------- $repodir -------\n"
			cd $DIR/$repodir/ && $GITPULLCMD
		fi
	done
}

if [ "$USERNAME" != "" ]; then
	USERGITDIR=$GITDIR/$USERNAME
	if [ ! -d $USERGITDIR ]; then
		echo "Cannot find user directory: $USERGITDIR"
		exit 1
	fi
	updateAllRepos $USERNAME
	exit 0
fi

for userdir in $(ls -1 $GITDIR); do
	[ -d $GITDIR/$userdir ] && updateAllRepos $userdir
done
exit 0

