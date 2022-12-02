# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

[ -n "$PS1" ] && source ~/.bash_profile;

# Run SSh agent via keychain
if [ -d "/usr/bin/keychain" ]; then
  eval ``keychain --eval --agents ssh id_rsa
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
if [ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
  export SDKMAN_DIR="$HOME/.sdkman"
  [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
fi