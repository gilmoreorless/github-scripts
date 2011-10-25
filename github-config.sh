#!/bin/bash

### Config file for Github scripts - see README.md for details

GIT_BASEDIR=~/Sites/Github
GIT_PULLCMD="git pull origin master"
PULL_IGNOREUSERNAMES="gilmoreorless"

# Extra check for git-smart (https://github.com/geelen/git-smart)
GOT_SMART="n"
if [ -n "$(which git-smart-pull)" ]; then
	GOT_SMART="y"
	GIT_PULLCMD="git smart-pull"
fi
