# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"
ZSH_THEME="cloud"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:~/hammers
export PATH=$PATH:~/android-sdk-linux/platform-tools:~/android-sdk-linux/tools:~/android-ndk-r10d/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64/bin/:~/android-ndk-r10d/
export PATH=$PATH:/usr/local/DS-5/bin

alias tests='cd ~/my_projects/thbattle/tests'
alias kmaster="ps aux | grep master | grep ssh | awk '{print \$2}' | xargs kill"

export PIP_DOWNLOAD_CACHE=~/.cache/pip

# Utilities for quickly accessing frequently used directories in bash.

# Usage: 
#   $ cd /path/to/project/src/
#   $ mark code     # Will create a new shortcut. 
#                   # Becomes interactive if a shortcut already exists
#                   # m is an alias for mark. You can also `m code`
#
#   $ code          # From now on, running this anywhere in the shell 
#                   # will put you in /path/to/project/src/code
#
#   $ unmark code   # Will remove the symlink and is interactive
#                   # u is an alias for unmark. You can also `u code`

SHELLMARKSDIR="$HOME/.shellmarks"
mkdir -p $SHELLMARKSDIR
function mark_alias { alias $(basename $1)="cd -P $1"; }

function mark { # Mark a directory
    symlink=$SHELLMARKSDIR/$1
    ln -ivs "$(pwd)" $symlink && mark_alias $symlink
}
alias m=mark

function unmark { # Remove a mark
    symlink=$SHELLMARKSDIR/$1
    rm -iv $symlink
    if [ ! -f $symlink ]; then
        unalias $1
    fi
}
alias u=unmark

function shellmarks { # List all existing marks
    LINK_COLOR=$'\e[1;35m'
    RESET_COLOR=$'\e[0m'
    for symlink in $SHELLMARKSDIR/*; do
        echo "${LINK_COLOR}    $(basename $symlink) ${RESET_COLOR} -> $(readlink $symlink)"
    done
}

for symlink in $SHELLMARKSDIR/*; do # load all existing symlinks as aliases
    mark_alias $symlink
    # test -e $symlink || rm $symlink # remove symlinks if source does not exist
done


function proxy {
    export HTTP_PROXY="http://localhost:8123"
    export HTTPS_PROXY="http://localhost:8123"
}

function proxy2 {
    export HTTP_PROXY="http://localhost:8124"
    export HTTPS_PROXY="http://localhost:8124"
}

function noproxy {
    export HTTP_PROXY=
    export HTTPS_PROXY=
}

function crtcat {
    openssl x509 -in $1 -text
}

function signcsr {
    name=$(basename $1 .csr)
    if [ -z $2 ]; then
       echo Need ca name
       return
    fi
    ca=$2
    ext=${3-server}
    days=${4-3650}
    openssl x509 -req -in $name.csr -days $days -CA ~proton/admincert/$ca/ca.crt -CAkey ~proton/admincert/$ca/ca.key -extfile ~proton/$ext.v3ext -CAcreateserial > $name.crt
    rm ~proton/admincert/$ca/ca.srl
}

function newcsr {
    if [ -z $1 ]; then
       echo Need cert name
       return
    fi
    openssl genrsa 2048 > $1.key
    openssl req -new -key $1.key > $1.csr
}


function cpthb {
    cd ~/thbupdate
    git fetch
    cd /dev/shm
    cp -r ~/my_projects/thbattle .
    cd thbattle
    rm -rf src
    cp -r ~/thbupdate src
    buildout -vv
}

function kpyc {
    find -name '*.pyc' | xargs rm
}

function rocknroll {
    sudo losetup /dev/loop6 ~/.secret-vault
    if ! sudo cryptsetup luksOpen /dev/loop6 vault; then
        sudo losetup -d /dev/loop6
        return
    fi

    sudo mount -o rw,noatime /dev/mapper/vault ~/.vault
}

function exhausted {
    sudo umount ~/.vault
    sudo cryptsetup luksClose vault
    sudo losetup -d /dev/loop6
}

function testup {
    ssh -v linode bash -x update_testing
    ssh -v thbcn sudo bash -x ~root/test_restart
}

function rep {
    if [ "$1" = "hakurei" ]; then
        scp "thbcn:/data/data/thb/archives_test/hakurei-$2.gz" .
    else
        scp "thbcn:/data/data/thb/archives/${1}-$2.gz" .
    fi
}
alias l='ssh -A lcrelay'

[ -f ~/.local.zshrc ] && source ~/.local.zshrc
