DIRECTORY=`pwd`

cd ~
ln -s $DIRECTORY/.vimrc
mkdir -p .vim/bundle
ln -s $DIRECTORY/vimscripts .vim/vimscripts
cd .vim/bundle
git clone git://github.com/gmarik/vundle
vim +:BundleInstall +:qall
