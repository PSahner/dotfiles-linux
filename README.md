# Philipp’s linux dotfiles

## Installation

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don’t want or need. Don’t blindly use these settings unless you know what that entails. Use at your own risk!

### Using Git and the bootstrap script

You can clone the repository wherever you want. (I like to keep it in `~/Projects/dotfiles-linux`, with `~/dotfiles` as a symlink.) The bootstrapper script will pull in the latest version and copy the files to your home folder.

```bash
git clone https://github.com/psahner/dotfiles-linux.git && cd dotfiles-linux && sudo bash init.sh
```

OR (without installing some essential apps/tools)

```bash
git clone https://github.com/psahner/dotfiles-linux.git && cd dotfiles-linux && ./bootstrap.sh --init
```

To install, `cd` into your local `dotfiles-linux` repository and then:

```bash
sudo bash init.sh

# OR

./bootstrap.sh --init
```

Alternatively, to install while avoiding the confirmation prompt:

```bash
sudo bash init.sh --force

# OR

./bootstrap.sh -f
```

To update, `cd` into your local `dotfiles-linux` repository and then:

```bash
sudo bash init.sh --update

# OR

./bootstrap.sh -up
```

Alternatively, to update while avoiding the confirmation prompt:

```bash
sudo bash init.sh --force --update

# OR

./bootstrap.sh -f -up
```

For more detailed information and all possible flags/options see:

```bash
init.sh --help

# OR

bootstrap.sh -h
```

### Specify the `$PATH`

If `~/.path` exists, it will be sourced along with the other files, before any feature testing (such as [detecting which version of `ls` is being used](https://github.com/mathiasbynens/dotfiles/blob/aff769fd75225d8f2e481185a71d5e05b76002dc/.aliases#L21-L26)) takes place.

Here’s an example `~/.path` file that adds `/usr/local/bin` to the `$PATH`:

```bash
export PATH="/usr/local/bin:$PATH"
```

### Add custom commands without creating a new fork

If `~/.extra` exists, it will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository, or to add commands you don’t want to commit to a public repository.

So the `~/.extra` file could be something like this:

```bash
# Git credentials
# Not in the repository, to prevent people from accidentally committing under a hardcoded credentials in .gitconfig
# GIT_CREDENTIAL_HELPER btw is only needed if you run Linux as a WSL distribution
GIT_AUTHOR_NAME="Max Mustermann"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="max.mustermann@gmail.com"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"
GIT_CREDENTIAL_HELPER="/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager-core.exe"
git config --global credential.helper "$GIT_CREDENTIAL_HELPER"
```

You could also use `~/.extra` to override settings, functions and aliases from these dotfiles repository. But then it is probably better to [fork this repository](https://github.com/psahner/dotfiles-linux/fork) instead.

### Install Apt-Get / Apt packages

When setting up a new linux distribution, you may want to install some common [packages](https://packages.ubuntu.com/):

```bash
sudo bash init.sh
```

Some of the functionality of these dotfiles depends on packages installed by this script. If you do not plan to run `init.sh`, you should look carefully through the script and manually install any particularly important ones.

## Feedback

Suggestions/improvements
[welcome](https://github.com/psahner/dotfiles-linux/issues)!

## Thanks to…

* [Mathias Bynens](https://mathiasbynens.be/) and his [dotfiles repository](https://github.com/mathiasbynens/dotfiles), which was a big help and inspiration for this dotfile setup.
