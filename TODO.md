Notes and ideas for improvements:

* clone: Move "ssh" 3rd param to "-s" switch
* clone: New 3rd param for upstream repo owner, auto-adds "upstream" remote (e.g. "ghc forkuser forkedreponame origuser")
* clone: Automatically init/update submodules if found
* clone: Automatically run `npm install` if package.json is found?
* pull: Use terminal colours in stats output
* pull: Show count of repos updated
* all: Rewrite in python?

BUGS:

* If smart-pull finds an error (eg. repo missing), github-pull still reports success
