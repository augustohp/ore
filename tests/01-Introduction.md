# Ore Tests Introduction

All [code blocks][1] in `*.md` files are treated as tests by [clitest][2] and
other text is ignored. Hopefully what is written between the tests is useful in
the future. As *shell programs* don't follow a established framework, this aims
to explain some practices used to test the program.

Every [code block][1] line is a test. Lines starting with `$ ` are executed and
must provide the same output as the lines that follow it. Every `*.md` file is a
*test suite*.

Given you have [make][] installed, you can execute the test suite through `make
test` on the root of the project. You can also read the `Makefile` to understand
how to execute the tests manually.

[1]: https://daringfireball.net/projects/markdown/syntax#precode "Markdown Code Blocks"
[2]: https://www.github.com/aureliojargas/clitest "Aurelio (Verde) Jargas: clitest"
[make]: https://www.gnu.org/software/make/ "GNU Make"

## The binary used for tests

As a *developer* running the test suite might already have `ore`
available on his `$PATH`, the `Makefile` symlinks the development file to
`/tmp/ore-dev` - which is used throughout test files.

    $ which ore-dev
    /tmp/ore-dev

## The tests

This *test suite* aims to ensure some basic, and expected, functionality of
every command line program should follow.

### Program version

Displaying the version number of a program is a nice behaviour to provide, many
programs test the existence of another through that interface.

    $ ore-dev -v
    ore-dev 1.0.0
    $ ore-dev --version
    ore-dev 1.0.0

The name of the program is fetch from `$0`, so if the program is named
`ore-dev` that is what will be displayed.

### Getting help

A help must be displayed as well, like `git` there are two versions: a *short*
(`-h`) and a *long* (`--help`) one.

    $ ore-dev -h
    Usage: ore-dev [-v | --version] [-h | --help]
           ore-dev [-d <n=2> | --depth <n=2>] [-s <p> | --sort <p>] <pattern>
           ore-dev [-d | --files] <pattern>
           ore-dev [--hook <load|pre|post>]

The *short help* provides examples of usage where each line is a command one
might issue with the program.

    $ ore-dev --help
    Usage: ore-dev [options] <pattern>
           ore-dev [options]
           ore-dev <pattern>
           ore-dev
    
    Ore finds files following a "pattern" and outputs their content
    after sorting their results. This is useful to generate a file from multiple
    files following a name convention.
    Running the command without any arguments will trigger all hooks inside
    "~/.ore".
    
    Options:
        --help, -h           Displays this help message.
        --version, -v        Displays version of the program.
    Output options:
        --files, -f          Prints file names instead of their output.
    Hook modifiers:
        --hook <h>           Only execute a hook and ignore others, possible
                             hook names are: "load", "pre" and "post"
    Search options:
        --depth <n>, -d <n>  How deep to search directories (Default: 2).
        --sort <p>, -s <p>   Which program to pipe found files to?
                             (Default: sort).
    
    Pattern:
        This argument is passed to "-name" option of the "find" program. If you
        want to output all ".ssh/config_*" files, "pattern" could be
        ".ssh/config_*".
    
    Send bugs and/or suggestions to https://github.com/augustohp/ore/issues

The *full help* should provide everything a user need to know as no `man` pages
are provided with the script.

### Behavior for invalid calls

When an invalid option is provided, an error message should be displayed:

    $ ore-dev -x
    Error: Unknown option "-x", try "ore-dev --help".

These *invalid calls* should also exit with a proper *exit code*:

    $ ore-dev -x #=> --exit 2

If a valid command such as `help` or `version` is passed and an invalid
parameter is given, give preference for the valid command:

    $ ore-dev -h -x #=> --exit 0
    $ ore-dev -v -x #=> --exit 0

### Some improvements to the API

Currently, options are parsed one at a time. We cannot specify all options with
a single `-`:

    $ ore-dev -vx #=> --exit 2

The above should work by providing `-v` behavior as previous tests state.
