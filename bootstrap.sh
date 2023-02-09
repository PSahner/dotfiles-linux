#!/bin/bash

isForce=0;
isUpdate=0;
isInit=0;
wslName="";

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "Dotfiles - bootstrap dotfiles in home folder [~/]"
      echo " "
      echo "options:"
      echo "-h, --help                show brief help"
      echo "-f, --force               run it without prompts"
      echo "-up, --update              pull newest version"
      echo "-i, --init                do also the init stuff (like setting up WSL Name)"
      echo "-wn, --wsl-name=NAME      specify an identifier to be added to the terminal before your username"
      exit 0
      ;;
    -f)
      isForce=1
      shift
      ;;
    --force)
      isForce=1
      shift
      ;;
    -up)
      isUpdate=1
      shift
      ;;
    --update)
      isUpdate=1
      shift
      ;;
    -i)
      isInit=1
      shift
      ;;
    --init)
      isInit=1
      shift
      ;;
    -w)
      shift
      if test $# -gt 0; then
        wslName=$1
      else
        echo "You used the '-w' flag but did not specify the WSL name"
        exit 1
      fi
      shift
      ;;
    --wsl-name*)
      wslName=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    *)
      break
      ;;
  esac
done

cd "$(dirname "${BASH_SOURCE}")";

currentDir="$PWD";
if [ -d "$currentDir/.git" ] && [ $isUpdate -eq 1 ]; then
	git pull origin main;
fi;
unset currentDir;

doIt() {
	rsync --exclude ".DS_Store" \
        --exclude ".git/" \
		    --exclude ".osx" \
        --exclude ".vscode" \
		    --exclude "bootstrap.sh" \
        --exclude "init.sh" \
        --exclude "init-vscode.sh" \
		    --exclude "README.md" \
		    -avh --no-perms . ~;
	source ~/.bash_profile;
}

if [ $isForce -eq 1 ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " REPLY;
	if [ $REPLY = "Y" ] || [ $REPLY = "y" ]; then
		doIt;
	fi;
fi;
unset doIt;
unset REPLY;

if [ $isInit -eq 1 ]; then
    if [ $isForce -eq 0 ] && [ -z $wslName ]; then
        read -p "Do you want to add a special identifier to the terminal before the user name (y/n) " REPLY;
        if [ "$REPLY" = "Y" ] || [ "$REPLY" = "y" ]; then
            read -p "Please type in the name (without whitespaces): " NAME;
            wslName="$NAME";
        fi;
    fi;
    if [ ! -z $wslName ]; then
        if [ -f ~/.wslname ]; then
            rm ~/.wslname
        fi;
        touch ~/.wslname;
        echo "$wslName" >> ~/.wslname;
    fi;
fi;
unset REPLY;
unset NAME;

if [ ! -d "~/.vim/backups" ]; then
  mkdir -p ~/.vim/backups
fi;
if [ ! -d "~/.vim/swaps" ]; then
  mkdir -p ~/.vim/swaps
fi;
if [ ! -d "~/.vim/undo" ]; then
  mkdir -p ~/.vim/undo
fi;

unset isForce;
unset isUpdate;
unset isInit;
unset wslName;