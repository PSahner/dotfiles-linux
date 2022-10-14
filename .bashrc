# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

[ -n "$PS1" ] && source ~/.bash_profile;

eval ``keychain --eval --agents ssh id_rsa
