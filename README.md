# [Castle][1]: Carcassonne

[Homesick][1] allows you to manage multiple [dot files][2] but it has some
shortcomings:

* Doesn't merge files, allowing multiple repositories to play nice together
* Requires Ruby as dependency, which isn't always sane when you just want your
  home with you
* Don't provide a standard to allow sharing your castle with others easily

Carcassonne is for people who spend most of the time in the shell. It assumes a
few things:

1. It will be your first castle, owning some key files (e.g: `bashrc`)
1. It has a POSIX environment available
1. You know what you are doing: destructive operations are done without
   interaction

[1]: https://github.com/technicalpickles/homesick
[2]: https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory

## Installing

* Homesick clone

You `.bashrc` should be already in place from Carcassonne, you can have a look
and edit the provided configuration:

    PATH="$HOME/bin:$PATH"
    managed_by_carcassone "${HOME}/.carcassonne"

## Merging files with `managed_dot_file`

Multiple castles might need to affect the same files, `.bashrc` for instance,
and to do that Carcassonne *merges files* for you. By default, no files are
merged, you need to mention them on `$HOME/.carcassonne` like this:

    # ~/.carcassonne
    managed_dot_file ".ssh/config"

What `managed_dot_file` does is to find, sort and append all the files that
start with the *prefix* you gave, into a file named as the *prefix*. It runs
every time you open a new *shell*, so it only does that if needed.

    $ ls -a
    .carcassone .bashrc .ssh/config_01-work .ssh/config_02-private

If your `$HOME` is the one above, once you open a new *shell* all `.ssh/config_*`
content will be into `.ssh/config`. The contents of `.ssh/config_01-work` will be the
first things in the file:

    $ carcassone
    $ cat ~/.ssh/config
    # Contents of `.ssh/config_01-work`
    # Contents of `.ssh/config_02-private`

After the *prefix*, an OS name can be used to only load files for an specific OS. 
