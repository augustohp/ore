# Carcassonne: Merging `dotfiles` together

A way to provide (a simple standard) and merge (a program) `dotfiles`.
Multiple repositories might need to affect the same file (e.g `~/.bashrc`),
Carcassonne allows that.

Carcassonne is two things:

1. A *Standard* for [dotfiles repositories][d] to follow and play nice together
1. A program to merge [carcassonne-compatible][m] `dotfiles` together

[d]: https://wiki.archlinux.org/index.php/Dotfiles
[m]: https://github.com/topics/carcassone "Search compatible repositories"

## The Standard

Every *carcassonne repository* CAN be a [castle][c], which means:

* They contain a `home` directory
* `home` contains files which will be symlinked to the user\'s home

*Carcassonne castles* follow just one more rule:

* They don\'t have files which might be used by other castles

If you have a castle with `.bashrc` and want to provide it, append
`_<id>` to the file name: `.bashrc_phpbrew`.

You can search for [other Carcassonne compatible repositories on GitHub][m].

[c]: https://github.com/technicalpickles/homesick "Homesick: Take your $HOME"

## The program

The `carcarssonne` command line is used to merge files from smaller
ones:

    $ carcassone ".ssh/config_*" > ~/.ssh/config

The execution above will `find` all files in your `$HOME` that start with
`.ssh/config_` and output its contents to `~/.ssh/config`. `carcassonne` just
concatenate files and you are responsible for telling which file they will
produce, a couple more examples:

    $ carcassone ".bashrc_*" > ~/.bashrc
    $ carcassone ".bash_environment_*" > ~/.bash_environment
    $ carcassone ".vimrc_*" > ~/.vimrc

The files concatenated by `carcassonne` are sorted, meaning `.vimrc_00-pathogen`
is output before `.vimrc_99-papercolor-colorscheme`.

## Automating things with hooks

A *carcassonne repository* can help you by providing three hooks: 

* `pre-command` and `post-command` are executed before or after `carcassonne`
* `load` is used to automatically generate files provided by the repository

**Hooks** MUST be provided inside a `.carcassonne`
directory. If the repository is a [castle][c], then it will have a
`home/.carcassonne` directory. A hook is a *shell* file that is executed by
`carcassonne` and follow the convention `<when>_<_id>`:

* `when`: Is either `pre`, `post` or `load`
* `id` is usually the name of your repository

Examples of hook files are: `load_ssh_config_work`, `load_vim-pathogen`,
`load_docker_aliases`, `pre_docker_aliases` and `post_docker_aliases`.

### Automatically merging files with `load` hook

The `load` hook is a text file with the file names provided by the repository
after they are merged. If a repository provides `~/.vimrc` and has a
`~/.vimrc_nice-statusbar` then the hook file content can be:

    # ~/.carcassonne/load_nice-statusbar
    # Comments are ignored
    carcassonne "$HOME/.vimrc_* >> $HOME/.vimrc

The `load` hook is only used when you execute `carcassonne` without any
argument (or `carcassonne --only-load`). All `load` hooks differ from `pre` and
`post` hooks as their content is first read, merged together with all other
`load` hook-scripts available so they can be de-duplicated.

### Pre and Post hooks

This hooks must be executable, they can be a *shell script* or program that gets
executed by `carcarssonne` if the user accepts the risks involved.

## Installation

Carcassonne is a single script program, just put it in your `$PATH` or:

    $ sh <(curl -sSL http://git.io/sinister) -u http://git.io/carcassonne

The above command, after executed, should provide you with a `carcassonne`
command which you will use. To check if installation was successful, you
can:

    $ carcassonne --version
    Carcassonne 1.0.0

If this fails, please [let me know][bugs].

[bugs]: https://github.com/augustohp/carcassonne/issues "Submit a bug report"
