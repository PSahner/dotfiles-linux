# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

[ -n "$PS1" ] && source ~/.bash_profile;

# Add NVM
if [ -f "$HOME/.nvm/nvm.sh" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash completion
fi

# Load Angular CLI autocompletion.
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
path_remove '/mnt/c/Program Files/Docker/Docker/resources/bin'
path_remove '/mnt/c/Users/psahner/AppData/Local/Microsoft/WindowsApps'
path_remove '/mnt/c/Users/psahner/PortableApps/cmder'
