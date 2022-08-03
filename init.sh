#!/bin/bash

isForce=0
isUpdate=0
wslName=""
javaType=""
javaVersion=""
nodeVersion=""
angularVersion=""
installYarn=false
userName=""
homePath=""

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "Dotfiles - download apps and bootstrap dotfiles in home folder [~/]"
      echo "  => needs to be started as root!"
      echo " "
      echo "options:"
      echo "-h, --help                show brief help"
      echo "-u, --user=#              path to user home folder"
      echo "-f, --force               run it without prompts"
      echo "-up, --update             pull newest version"
      echo "-wn, --wsl-name=#         specify an identifier to be added to the terminal before your username"
      echo "-j, --java-type=#         specify the Java type -> [O] for OpenJDK | [S] for SapMachine"
      echo "-jv, --java-version=#     specify the Java version -> e.g. 11"
      echo "-nv, --node-version=#     specify the Node version -> e.g. 14"
      echo "-y, --yarn                install yarn"
      echo "-av, --angular-version=#  specify the Angular version -> e.g. 12"
      exit 0
      ;;
    -u)
      shift
      if test $# -gt 0; then
        userName=$1
      else
        echo "You did not specify your username"
        exit 1
      fi
      shift
      ;;
    --user*)
      userName=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
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
    -j)
      shift
      if test $# -gt 0; then
        javaType=$1
      else
        echo "You used the '-j' flag but did not specify the Java type"
        exit 1
      fi
      shift
      ;;
    --java-type*)
      javaType=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    -jv)
      shift
      if test $# -gt 0; then
        javaVersion=$1
      else
        echo "You used the '-jv' flag but did not specify the Java version"
        exit 1
      fi
      shift
      ;;
    --java-version*)
      javaVersion=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    -nv)
      shift
      if test $# -gt 0; then
        nodeVersion=$1
      else
        echo "You used the '-nv' flag but did not specify the Node version"
        exit 1
      fi
      shift
      ;;
    --node-version*)
      nodeVersion=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    -y)
      installYarn=true
      shift
      ;;
    --yarn)
      installYarn=true
      shift
      ;;
    -av)
      shift
      if test $# -gt 0; then
        angularVersion=$1
      else
        echo "You used the '-av' flag but did not specify the Angular version"
        exit 1
      fi
      shift
      ;;
    --angular-version*)
      angularVersion=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    *)
      break
      ;;
  esac
done

whoIsIt=$(id -u);
if [ ! $whoIsIt -eq 0 ]; then
    echo "ERROR: Please start this script as root with 'sudo'";
    exit 1
fi;
unset whoIsIt

if [ ! -z $userName ] && [ id -u $userName > /dev/null 2>&1 ]; then
    echo "INFO: Found user with the name: $userName"
    homePath=$(sudo -u $userName sh -c 'echo $HOME')
    echo "INFO: Corresponding home path: $homePath"
elif [ $isForce -eq 1 ]; then
    echo "ERROR: Please provide your username"
    exit 1
else
    read -p "Provide your username: " MYUSER;
    if [ ! -z $MYUSER ] && [ `id -u $userName 2>/dev/null || echo -1` -ge 0 ]; then
        userName=$MYUSER
        echo "INFO: Found user with the name: $userName"
        homePath=$(sudo -u $userName sh -c 'echo $HOME')
        echo "INFO: Corresponding home path: $homePath"
    else
        echo "ERROR: Please provide an existing username"
        exit 1
    fi;
fi;
unset MYUSER

if [ ! -z $javaType ] && [ -z $javaVersion ]; then
    echo "ERROR: You specified a Java type but did not provide a Java version"
    exit 1
elif [ -z $javaType ] && [ ! -z $javaVersion ]; then
    echo "ERROR: You specified a Java version but did not provide a Java type"
    exit 1
fi;

# Make sure we’re using the latest apt-get index.
echo "INFO: Updating Apt-Get..."
DEBIAN_FRONTEND=noninteractive apt-get update -y --no-install-recommends

# Upgrade any already-installed packages.
echo "INFO: Upgarding via Apt-Get ..."
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y --no-install-recommends

# Install some basic packages.
echo "INFO: Install unzip, vim, wget, ca-certificates, gnupg2, net-tools, xclip and curl..."
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends unzip vim wget ca-certificates gnupg2 net-tools xclip curl

javaVersion=$(($javaVersion + 0))
if [ "$javaType" = "O" ] || [ "$javaType" = "o" ] || [ "$JAVATYPE" = "S" ] || [ "$JAVATYPE" = "s" ]; then
    if [ -n $javaVersion ] && [ $javaVersion -gt 0 ] && [ $javaVersion -lt 100 ]; then
        INSTALLJAVA="Y"
    fi;
elif [ $isForce -eq 1 ]; then
    INSTALLJAVA="N"
else
    read -p "Install Java? (y/n) " INSTALLJAVA;
fi;

if [ "$INSTALLJAVA" = "Y" ] || [ "$INSTALLJAVA" = "y" ]; then
    if [ -z $javaType ]; then
        read -p "Select Java type -> [O]penJDK | [S]apMachine: " JAVATYPER;
        javaType="$JAVATYPER"
    fi;
    if [ $javaVersion -lt 1 ]; then
        read -p "Java version (e.g. 11): " JAVAVERSIONR;
        javaVersion=$JAVAVERSIONR
        javaVersion=$(($javaVersion + 0))
    fi;

    javaVersion=$(($javaVersion + 0))
    if [ $javaType = "O" ] || [ $javaType = "o" ] || [ $javaType = "S" ] || [ $javaType = "s" ]; then
        
        if [ -n $javaVersion ] && [ $javaVersion -gt 0 ] && [ $javaVersion -lt 100 ]; then
            if [ -f /usr/lib/jvm/.java ]; then
                rm /usr/lib/jvm/.java
            fi;
            touch .java
            mv .java /usr/lib/jvm/
            echo "INFO: Downloading Java ...";
            if [ "$javaType" = "O" ] || [ "$javaType" = "o" ]; then
                echo "INFO:... OpenJDK version: $javaVersion ...";
                DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends openjdk-$javaVersion-jdk    
                echo "export JAVA_HOME=/usr/lib/jvm/java-$javaVersion-openjdk-amd64" >> /usr/lib/jvm/.java
            elif [ "$javaType" = "S" ] || [ "$javaType" = "s" ]; then
                echo "INFO:... SapMachine version: $javaVersion ...";
                export GNUPGHOME="$(mktemp -d)"
                wget -q -O - https://dist.sapmachine.io/debian/sapmachine.old.key | gpg --batch --import
                gpg --batch --export --armor 'DA4C 00C1 BDB1 3763 8608 4E20 C7EB 4578 740A EEA2' > /etc/apt/trusted.gpg.d/sapmachine.old.gpg.asc
                wget -q -O - https://dist.sapmachine.io/debian/sapmachine.key | gpg --batch --import
                gpg --batch --export --armor 'CACB 9FE0 9150 307D 1D22 D829 6275 4C3B 3ABC FE23' > /etc/apt/trusted.gpg.d/sapmachine.gpg.asc
                gpgconf --kill all && rm -rf "$GNUPGHOME"
                echo "deb http://dist.sapmachine.io/debian/amd64/ ./" > /etc/apt/sources.list.d/sapmachine.list

                DEBIAN_FRONTEND=noninteractive apt-get update -y --no-install-recommends
                DEBIAN_FRONTEND=noninteractive  apt-get install sapmachine-$javaVersion-jdk
                echo "export JAVA_HOME=/usr/lib/jvm/sapmachine-$javaVersion" >> /usr/lib/jvm/.java
            fi;

            echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /usr/lib/jvm/.java
        else
            echo "WARNING: Java version check failed with version: $javaVersion";
        fi;
    else
        echo "WARNING: Java type check failed with type: $javaType";
    fi;
fi;
unset INSTALLJAVA
unset JAVATYPER
unset JAVAVERSIONR

nodeVersion=$(($nodeVersion + 0))
if [ -n $nodeVersion ] && [ $nodeVersion -gt 0 ] && [ $nodeVersion -lt 100 ]; then
    INSTALLNODE="Y"
elif [ $isForce -eq 1 ]; then
    INSTALLNODE="N"
else
    read -p "Install NVM/Node? (y/n) " INSTALLNODE;
fi;

if [ "$INSTALLNODE" = "Y" ] || [ "$INSTALLNODE" = "y" ]; then

    nodeVersion=$(($nodeVersion + 0))
    if [ $nodeVersion -lt 1 ]; then
        read -p "Node version (e.g. 14): " NODEV;
        nodeVersion=$NODEV
        nodeVersion=$(($nodeVersion + 0))
    fi;

    echo "INFO: Downloading Node JS ...";
    
    sudo -u $userName curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | sudo -u $userName bash
    
    # sudo -u $userName export NVM_DIR="$HOME/.nvm"
    # [ -s "$homePath/.nvm/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # su - $userName -c "env NVM_DIR=\"$HOME/.nvm\" scriptThatNeedsMyVar.sh"
    su - $userName -c 'export NVM_DIR="$HOME/.nvm"; echo $NVM_DIR'
    # if [ -s "$homePath/.nvm/nvm.sh" ]; then
        # su - $userName -c '\. "$homePath/.nvm/nvm.sh"'
        # sudo -u $userName \. "$homePath/.nvm/nvm.sh"
    # fi;

    if [ -n $nodeVersion ] && [ $nodeVersion -gt 0 ] && [ $nodeVersion -lt 100 ] && [ -d $homePath/.nvm ]; then
        echo "INFO: Installing Node JS version: $nodeVersion ...";
        # sudo -u $userName nvm install $nodeVersion
        su - $userName -c "$homePath/.nvm/nvm.sh install $nodeVersion"
    elif [ ! -d $homePath/.nvm ]; then
        echo "NVM not installed";
    else
        echo "WARNING: Node JS version check failed with version: $nodeVersion";
    fi;
fi;
unset INSTALLNODE

if [ -d $homePath/.npm ]; then

    if [ $installYarn ]; then
        YARN="Y"
    elif [ $isForce -eq 1 ]; then
        YARN="N"
    else
        read -p "Install Yarn globally? (y/n) " YARN;
    fi;
    
    if [ "$YARN" = "Y" ] || [ "$YARN" = "y" ]; then
        echo "INFO: Installing Yarn"
        su - $userName -c "$homePath/.npm/npm install -g yarn"
        # sudo -u $userName npm install -g yarn
    fi;

    angularVersion=$(($angularVersion + 0))
    if [ -n $angularVersion ] && [ $angularVersion -gt 0 ] && [ $angularVersion -lt 100 ]; then
        ANGULAR="Y"
    elif [ $isForce -eq 1 ]; then
        ANGULAR="N"
    else
        read -p "Install Angular globally? (y/n) " ANGULAR;
    fi;

    if [ "$ANGULAR" = "Y" ] || [ "$ANGULAR" = "y" ]; then
        if [ -n $angularVersion ] && [ $angularVersion -gt 0 ] && [ $angularVersion -lt 100 ]; then
            echo "INFO: Installing Angular version: $angularVersion"
        else
            read -p "Angular version (e.g. 12): " ANGULARV;
            angularVersion=$ANGULARV
            angularVersion=$(($angularVersion + 0))
        fi;
        
        if [ -n $angularVersion ] && [ $angularVersion -gt 0 ] && [ $angularVersion -lt 100 ]; then
            su - $userName -c "$homePath/.npm/npm install -g @angular/cli@$angularVersion"
            # sudo -u $userName npm install -g @angular/cli@$angularVersion
        else
            echo "WARNING: Angular version check failed with version: $angularVersion";
        fi;
    fi;
else
    echo "INFO: NPM not installed"
fi;
unset YARN
unset ANGULAR
unset ANGULARV

# Remove outdated versions from the cellar.
apt-get clean

# reset arguments before calling bootstrap.sh
# while [ "${#}" -ge 1 ] ; do 
#    unset "${1}"
#    shift
# done

# run the bootstrap script in init mode (only necessary after first distribution setup)
echo "INFO: starting bootstrapping..."
sudo -u $userName bash bootstrap.sh --init

unset isForce
unset isUpdate
unset wslName
unset javaType
unset javaVersion
unset nodeVersion
unset angularVersion
unset homePath
