# [Castle][1]: Carcassonne

This is not a [castle][1], but helps you merge multiple castles together -
*personal* and *work*, for example. It is a single posix shell-script, which
eases its use on different machines.

[1]: https://github.com/technicalpickles/homesick "Homesick: Take your $HOME"

    $ carcassonne --help
    Usage: carcassonne [options] <pattern>
           carcassonne

    Carcassone finds files following a "pattern" and outputs their content
    after sorting their results.
    Running the command without any argument will try to guess patterns based on
    "environment variables", if they are not present an error is produced.

    Options:
      --help, -h           Displays this help message.
      --version, -v        Displays version of the program.
      --files, -f          Prints file names instead of their output.
      --depth <n>, -d <n>  How deep to search directories (Default: 2).
      --sort <p>, -s <p>   Which program to pipe found files to?
                           (Default: sort).

    Pattern:
       This argument is passed to "-name" option of the "find" program. If you
       want to output all ".ssh/config_*" files, "pattern" could be
       ".ssh/config_*".

    Environment variables:
        CARCASSONNE_PATTERN_PREFIX
        CARCASSONNE_PATTERN_SUFFIX
        CARCASSONNE_FILES

    Send bugs and/or suggestions to https://github.com/augustohp/carcassonne/issues

## Why?

Putting your `$HOME` under a versioned repository is nice, but storing my editor
configuration, SSH configuration and public keys, my scripts all under the
same repository (for home and work) was driving me crazy. Using [homeshick][] to
clone my [castles][1] doesn't allow to have two files, with the same name, in
two different castles now allowing, for example, to merge my `.ssh/config` from
home and work at my home computer.

[homeshick]: https://github.com/andsens/homeshick "Dotfiles synchronizer"

I've been storing files like `.ssh/config_personal` and `.ssh/config_company`
for some time and doing the following to create one:

    $ find -depth 2 -name "config_*" ~/.ssh \
        | sort \
        > ~/.ssh/config

This is actually the second version it, the `sort` helps when order to generate
files is important. The last version is in this script: `carcassonne`. That does
that in a way other people can use, and maybe share it so other people can use
it as well.

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

## Usage

Carcassonne assumes you know how [redirection on shell][r] works, if you need a
quick tutorial:

    $ echo "Hello World" > /tmp/message
    $ cat /tmp/message
    Hello World
    $ echo "Bye" > /tmp/message
    $ cat /tmp/message
    Bye
    $ echo "Or not..." >> /tmp/message
    Bye
    Or not...

Note the difference between `>` (truncates the file) and `>>` (appends to the
file) and you know how to use it.

[r]: http://www.tldp.org/LDP/abs/html/io-redirection.html "TLDP: I/O Redirection"

There is a shortcut for when you are creating multiple files using
`carcassonne`, which is using *environment variables*, by default their values
are:

    CARCASSONNE_PATTERN_PREFIX=""
    CARCASSONNE_PATTERN_SUFFIX="_*"
    CARCASSONNE_FILES=""

These variables are only used when `carcassonne` program is called without any
arguments. The patterns *prefix* and *suffix* helps creating the *pattern* to be
searched and *files* is a list of file names separated by `:` (like in `$PATH`).
Usually you just want to `export` a `CARCASSONNE_FILES` variable, like:

    export CARCASSONNE_FILES="~/.ssh/config:~/.bashrc:~/.vimrc"

When you execute `carcassonne` with the above *environment variable*, three
files will be created or overwritten: `.bashrc`, `.vimrc` and `~/.ssh/config`.
The contents of these files will be retrieved by appending the *prefix* and
*suffix* to each file name - which would be the same as executing:

    $ carcassonne ".bashrc${CARCASSONNE_PATTERN_SUFFIX}" > ~/.bashrc

By just keeping this variable, you can execute `carcassonne` to update
everything. You can enable your *castle* to be shared with others sharing a
`.bash_environment_my-castle` with:

    # home/.bash_environment_auto-ssh
    export CARCASSONNE_FILES="$CARCASSONNE_FILES:~/.ssh/config"

Repeated files in the `CARCASSONNE_FILES` variable will be ignored and executed
only once. After cloning *carcassonne-enabled* repositories, you should execute
`carcassonne` to update your files.

