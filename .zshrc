zstyle ':omz:update' mode disabled
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
plugins=(git kube-ps1)

source $ZSH/oh-my-zsh.sh

export HISTSIZE=1000000
#save history after logout
export SAVEHIST=1000000
#history file
export HISTFILE=~/.zsh_history
#append into history file
setopt INC_APPEND_HISTORY
#save only one command if 2 common are same and consistent
setopt HIST_IGNORE_DUPS
#add timestamp for each entry
setopt EXTENDED_HISTORY

# Customize to your needs...
export EDITOR=`which nvim`

function kmaster {
    ps aux | grep '\[mux\]' | grep ssh | grep ${1:-.} | awk '{print $2}' | xargs kill
}


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
    export HTTP_PROXY=$(cat ~/.proxy)
    export HTTPS_PROXY=$(cat ~/.proxy)
    export http_proxy=$(cat ~/.proxy)
    export https_proxy=$(cat ~/.proxy)
}

function noproxy {
    export HTTP_PROXY=
    export HTTPS_PROXY=
    export http_proxy=
    export https_proxy=
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
    ssh -A thbcn ssh -A proton@thbattle.net bash -x update_testing
    ssh thbcn sudo bash -x ~root/test_restart
    git push nas-unity-logic +testing
    ssh nas.local 'cd /pool/proton/thb-unity-logic && git reset --hard'
}

function rep {
    if [ "$1" = "hakurei" ]; then
        scp "thbcn:/data/data/thb/archives_test/hakurei-$2.gz" .
    else
        scp "thbcn:/data/data/thb/archives/${1}-$2.gz" .
    fi
}

function kps {
    export PROMPT="\$(kube_ps1) $PROMPT"
}

export KUBE_PS1_SYMBOL_USE_IMG=true
export KUBE_PS1_NS_ENABLE=false
export KUBE_PS1_DIVIDER=""
export KUBE_PS1_PREFIX=""
export KUBE_PS1_SUFFIX=""


function k {
    if [ -z "$KUBE_ENV_SHOWN" ]; then
        kps
        export KUBE_ENV_SHOWN=1
        return
    fi
    if [[ "a$@" = "aapply -k ." ]]; then
        CURRENT=$(kubectl config view -o jsonpath='{.current-context}')
        TARGET=$(basename $(pwd))
        if [ "$TARGET" = "apps" ]; then
            TARGET=$(basename $(readlink --canonicalize $(pwd)/..))
        fi
        if [ "$CURRENT" != "$TARGET" ]; then
            echo YOU ARE APPLYING $TARGET CONFIGURATION TO $CURRENT !!!
            return
        fi
    fi
    kubectl "$@"
}

function kubeme {
    sudo chmod 0777 /etc/kubernetes/admin.conf
    export KUBECONFIG=/etc/kubernetes/admin.conf
}

[ -f ~/.local.zshrc ] && source ~/.local.zshrc
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.cargo/env ] && source ~/.cargo/env
if [ -e /home/proton/.nix-profile/etc/profile.d/nix.sh ]; then . /home/proton/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

alias riemann="java -server -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+CMSParallelRemarkEnabled -XX:+AggressiveOpts -XX:+UseFastAccessorMethods -XX:+UseCompressedOops -XX:+CMSClassUnloadingEnabled -XX:-OmitStackTraceInFastThrow -cp $GOPATH/src/github.com/leancloud/satori/satori/images/riemann/app/riemann.jar riemann.bin"

function psh {
    . $(dirname $(poetry run which python))/activate
}

alias say='spd-say -r -50'
alias clip='xclip -selection clipboard'

function catch {
    cd $(dirname $(which $1))
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/proton/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/proton/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/proton/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/proton/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/proton/hammers/box/google-cloud-sdk/path.zsh.inc' ]; then . '/home/proton/hammers/box/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/proton/hammers/box/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/proton/hammers/box/google-cloud-sdk/completion.zsh.inc'; fi
