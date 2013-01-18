PWD=`pwd`

cd ~
ln -s $PWD/.vimrc
mkdir -p .vim/bundle
cd .vim/bindle
git clone git@github.com:gmarik/vundle
vim +:BundleInstall +:qall
