#!/bin/bash
if [ $# -lt 2 ]; then
	echo "You need to enter a username and repository"
	exit 1
fi
GITDIR=~/Sites/git/$1
[ ! -d $GITDIR ] && mkdir $GITDIR
if [ "$3" != "ssh" ]; then
	REPOS="http://github.com/"
else
	REPOS="git@github.com:"
fi
cd $GITDIR && git clone ${REPOS}$1/$2.git

