Dotfiles
========

My .dotfiles, configurations and unattended software installs for macOS.

* Installs [Homebrew](https://brew.sh/)
* Installs [Oh My Zsh](https://ohmyz.sh/)
* Installs [Asdf](https://asdf-vm.com/) runtime version manager
* Installs all software in [Brewfile](Brewfile)
* Copies dotfiles to the user $HOME

# Installation

You can clone the repository wherever you want, although `~/.dotfiles` is preferred. The [bootstrap](bootstrap.sh) script will pull in the latest version, install all the software and copy dotfiles to their new $HOME.

```shell
git clone https://github.com/bcowdery/dotfiles.git ~.dotfiles
```

```shell
~/.dotfiles/bootstrap.sh install
```

## Staying up to date

You can update your installation at any time by running `bootstrap update`. It will automatically pull the latest sources from git and invoke Homebrew to update software and install new packages from the `Brewfile` formulae. The
bootstrap script itself is symlinked to `~/.local/bin` during install. After installation, you should be able to call `bootstrap` from anywhere on your PATH.

```shell
bootstrap update
```

You can also selectivly update either `homebrew`, your `dotfiles` or `scripts`:
```shell
bootstrap update homebrew
```
> **🚨 Warning!** Updating `dotfiles` will clobber any changes made to the files
> in your home directory. Check your `~/.zshrc` file for external changes made by other installers
> before updating!


## Sensible macOS defaults

When setting up a new Mac, you may want to set up some sensible macOS defaults.

```shell
~/.dotfiles/macos.sh
```
> **💡 Note:** Be prepared to type in your `sudo` password, like, *A LOT*. Sudo keep-alive doesn't seem to be working in recent versions of MacOS :(

> 🧠 These settings are my personal Mac devices. I have strong opnions about things like hot corners, Finder hiding files and other things you
> might not want for your own environment. Read through the [macos.sh](macos.sh) file and comment out anything you don't want.


# Extras

If any of these files exist, they will be sourced along with the main `~/.zshrc`. These files provide extension points for the shell environment organized by convention.

- `.path` - Additions to the `$PATH`
- `.exports` - Export environment variables, feature detection etc.
- `.aliases` - Aliases for commonly used commands
- `.functions` - Shell functions
- `.extra` - User specific extra's that you generally don't want to commit to github
- `.ssh-agent` - Launch ssh-agent to hold private keys for public key authentication

## Path

Here’s an example `~/.path` file that adds `/usr/local/bin` to the `$PATH`:

```shell
export PATH="/usr/local/bin:$PATH"
```

## Personal Scripts

The `~/bin/` directory contains handy scripts, usually written in a mix of bash, zsh and [zx](https://google.github.io/zx/)

These scripts are symlinked to the `~/.local/bin` path.

Use the `bootstrap update scripts` command to update symlinks for new scripts.

## Customizations

You can use `~/.extra` to add a few customizations without the need to fork this entire repository, or to add configuration that you don’t want to commit to a public repository.

For example, you can use `~/.extra` to configure your Git credentials, leaving the committed `.gitconfig` free
of user specific configuration.

```shell
# Git credentials
# Commented out to prevent people from accidentally committing under my name
#GIT_AUTHOR_NAME="Brian Cowdery"
#GIT_AUTHOR_EMAIL="brian@thebeardeddeveloper.co"
#GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
#GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
#git config --global user.name "$GIT_AUTHOR_NAME"
#git config --global user.email "$GIT_AUTHOR_EMAIL"
```

> **💡 Note:** The `.extra` file is copied once during **install** and then ignored in future updates.

# ASDF

## Managing Runtime Versions

I use [Asdf](https://asdf-vm.com/) to manage runtime versions, such as Node, Python, Ruby, etc. Asdf is installed by the Brewfile, but
the runtimes themselves must be configured manually by adding plugins and installing selected versison.
See the [Asdf documentation](https://asdf-vm.com/guide/getting-started.html) for more information.

**Example NodeJS:**
```shell
asdf plugin add nodejs
asdf install nodejs latest:22
asdf set --home nodejs latest:22 system
```

> 💡 List versions in order of preference, use `system` as a fallback to the globally installed version.

> 🧠 For a complete list of plugins, see the [Asdf Plugins](https://github.com/asdf-vm/asdf-plugins) repository.

To pin a specific version to a working directory (e.g., a project or git repo), run `asdf set <plugin> <version>` in the directory.

**Example set tool-version:**
```shell
cd my-project
asdf set nodejs latest:22
```

# Acknowledgements

Source code and examples were taken from all over the place. Special thanks to:

* [@mathiasbynens](https://github.com/mathiasbynens) (Mathias Bynens)
  [https://github.com/mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
* [@mbadolato](https://github.com/mbadolato) (Mark Badolato)
  [iTerm2-Color-Schemes](https://github.com/mbadolato/iTerm2-Color-Schemes)
* [@kevinSuttle](https://github.com/kevinSuttle) (Kevin Suttle)
  [macOS-Defaults](https://github.com/kevinSuttle/macOS-Defaults/blob/master/REFERENCE.md)
