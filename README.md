Some simple bash scripts I wrote to handle common tasks with GitHub repositories... because I'm lazy.

## Configuration

Open github-config.sh and edit the settings:

* `GIT_BASEDIR` - the root directory that holds all your Github clones
* `GIT_PULLCMD` - the command to run when repositories are updated
* `PULL_IGNOREUSERNAMES` - space-separated list of usernames to ignore when updating all local repositories (eg. your own username - no point in getting updates for your own work)

## Clone

I keep all my local GitHub clones in a standard format that mirrors the `username/repo/` directory format.
`github-clone.sh` is a single command that will clone a GitHub repo into its proper directory, creating the user directory if it doesn't exist

### Usage

    $ ./github-clone.sh username repository

Changes into `$GIT_BASEDIR/username` (creating it if it doesn't exist) and clones `https://github.com/username/repository.git`

    $ ./github-clone.sh username repository ssh

Performs the same process but uses the SSH clone URL `git@github.com:username/repository.git`

## Pull

At last count I had about 30 GitHub clones on my machine and I wanted an easy way to keep all of them up-to-date.
`github-pull.sh` loops through all git repositories (either for all users or just a specific username) and pulls the latest content.

### Usage

    $ ./github-pull.sh

Loops through all sub-sub directories of `$GIT_BASEDIR`, checks for a git repository and runs the update command defined in the config file.
Any usernames that match the ignore list in the config file will be skipped.

    $ ./github-pull.sh username

Update all repositories for a single username - this overrides the username ignore list in the config file.

