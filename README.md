# [Castle][1]: Carcassonne

[Homesick][1] allows you to manage multiple [dot files][2] but it has some
shortcomings:

* Doesn't merge files, multiple repositories work only for different file names
* Ruby as dependency feels too much for so little
* Doesn't provide a standard, allowing to share your castle with others easily

Carcassonne is for people who spend most of the time in the shell. It assumes:

1. It has a POSIX environment available
1. You know what you are doing: destructive operations are done without
   interaction

[1]: https://github.com/technicalpickles/homesick
[2]: https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory

## First contact: Installation and usage

Carcassone is a single script program, just put it in your `$PATH` or:

    $ sh <(curl -sSL http://git.io/sinister) -u http://git.io/carcassone
    $ carcassone --help
    Usage: carcassone <command> [options]
           carcassone merge <file>

    Commands available:
       merge     Creates <file> by merging all files found with that
                 pattern. (Use 'carcassone merge --help' for more details.
       help      Displays this message, also available inside commands.
       version   Displays the version of the program.

    Send bugs and/or suggestions to https://github.com/augustohp/carcassone/issues

No one likes slow things, so Carcassone runs just when asked to. Carcassone
appends multiple files together into one, to generate a `.ssh/config`:

    $ carcassone merge ".ssh/config"

This will **overwrite** the current file if it exists, creating a new one by:

1. Executing a `find` with all files named `.ssh/config_*`
1. Sort the files alphabetically
1. Insert the contents of each file into `.ssh/config` into sorted order

Now, everyone at the company may share subsets of SSH configurations they care
by fetching these files as they see fit:

    $ cd ~/.ssh && ls
    config_staging config_live config_databases config_01-mine

All commands you execute are stored into `~/.carcassone`, so if you execute
`carcassone remerge` it will re-execute all these commands again.

## `carcassone merge` advanced usage

Say you use Git at home and work, and want two different e-mails. With
Carcassone, you can do that with 3 files:

1. File `.gitconfig_01-base` holds configurations for *home* and *work*
1. `.gitconfig_02-home` with user configuration for *home*
1. `.gitconfig_02-work` with user configuration for *work*

    # ~/.carcassonne
    
    merge ".bashrc"
    when_host dua* merge ".gitconfig" --ignore-sufix work
    when_host_not dua* merge ".gitconfig" --ignore-sufix home

Suffixes suck as OS (e,g: osx) are automatically filtered.

