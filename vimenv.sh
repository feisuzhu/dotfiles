DIRECTORY=`pwd`

cd ~
ln -s $DIRECTORY/.vimrc
mkdir -p .vim/bundle
cd .vim/bundle
git clone git://github.com/gmarik/vundle
vim +:BundleInstall +:qall
