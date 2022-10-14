# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

[ -n "$PS1" ] && source ~/.bash_profile;


if [ -d "/usr/bin/keychain" ]; then
  eval ``keychain --eval --agents ssh id_rsa
fi
