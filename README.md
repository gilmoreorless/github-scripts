Some simple bash scripts I wrote to handle common tasks with GitHub repositories... because I'm lazy.

## Clone

I keep all my local GitHub clones in a standard format that mirrors the `username/repo/` directory format.
`github-clone.sh` is a single command that will clone a GitHub repo into its proper directory, creating the user directory if it doesn't exist

### Usage

First, change the base directory (`$GIT_BASEDIR`) for all clones at the top of the file.

    $ ./github-clone.sh username repository

Changes into `$GIT_BASEDIR/username` (creating it if it doesn't exist) and clones `https://github.com/username/repository.git`

    $ ./github-clone.sh username repository ssh

Performs the same process but uses the SSH clone URL `git@github.com:username/repository.git`

## Pull

At last count I had about 30 GitHub clones on my machine and I wanted an easy way to keep all of them up-to-date.
`github-pull.sh` loops through all git repositories (either for all users or just a specific username) and pulls the latest content.

### Usage

First, change the base directory (`$GIT_BASEDIR`) for all clones at the top of the file.
You can also change the command used to get the updates (currently set to `git pull origin master`).

    $ ./github-pull.sh

Loops through all sub-sub directories of `$GIT_BASEDIR`, checks for a git repository and runs the update command.

    $ ./github-pull.sh username

Update all repositories for a single username.

