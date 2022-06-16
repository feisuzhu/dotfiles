for d in ~/bin ~/hammers/bin*; do
    d=$(readlink -f $d)
    export PATH=$d:$PATH
done
. "$HOME/.cargo/env"
alias vim=nvim
