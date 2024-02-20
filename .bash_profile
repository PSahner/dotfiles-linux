### remove unnecessary Win PATHs
# This can prevent extension-less commands from bleeding into BASH.
# (eg. "ng" would execute the Win bin if "@angular/cli" wasn't installed on Linux.)
#
function path_remove {
  # Delete path by parts so we can never accidentally remove sub paths
  PATH=${PATH//":$1:"/":"} # delete any instances in the middle
  PATH=${PATH/#"$1:"/} # delete any instance at the beginning
  PATH=${PATH/%":$1"/} # delete any instance in the at the end
}
path_remove '/mnt/c/Program Files/dotnet/'
path_remove '/mnt/c/Program Files (x86)/NVIDIA Corporation/PhysX/Common'
path_remove '/mnt/c/Program Files/Git/cmd'
path_remove '/mnt/c/Users/psahner/AppData/Roaming/nvm'
path_remove '/mnt/c/Program Files/nodejs'
# path_remove '/mnt/c/Program Files/Docker/Docker/resources/bin'
path_remove '/mnt/c/Users/psahner/AppData/Local/Microsoft/WindowsApps'
path_remove '/mnt/c/Users/psahner/PortableApps/cmder'
path_remove '/mnt/c/Program Files/Azure Data Studio/bin'
path_remove '/mnt/c/Program Files/Azure Data Studio/bin'
path_remove '/mnt/c/Program Files (x86)/Microsoft SQL Server/160/DTS/Binn/'
path_remove '/mnt/c/ProgramData/chocolatey/bin'

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -f "$file" ] && [ -r "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# SSH auto-completion based on entries in known_hosts.
if [[ -e ~/.ssh/known_hosts ]]; then
  complete -o default -W "$(cat ~/.ssh/known_hosts | sed 's/[, ].*//' | sort | uniq | grep -v '[0-9]')" ssh scp sftp
fi
# eval "$(/bin/brew shellenv)"
if [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Run SSH agent via keychain
# Check/modify ~/.ssh/config if/as needed
if [ -x "/usr/bin/keychain" ]; then
  if [ -f "$HOME/.ssh/config" ]; then
    eval ``keychain --eval --agents ssh --confhost --ignore-missing --quiet
  elif [ -f "$HOME/.ssh/id_rsa" ] || [ -f "$HOME/.ssh/id_ed25519" ]; then
    eval ``keychain --eval --agents ssh --ignore-missing --quiet id_rsa id_ed25519
  fi;
fi

# Add NVM
if [ -f "$HOME/.nvm/nvm.sh" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash completion
fi

# Load Angular CLI autocompletion. (BROKEN ATM!)
# ONLY Angular >= v14
# source <(ng completion script)

# mgnl-tabcompletion-start
# load mgnl command tab completion
if [ -f "$HOME/.mgnl/mgnl" ]; then
  autoload bashcompinit
  bashcompinit
  source ~/.mgnl/mgnl
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
if [ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
  export SDKMAN_DIR="$HOME/.sdkman"
  [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
fi
