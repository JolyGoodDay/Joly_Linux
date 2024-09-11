sudo yum update
sudo yum install gtk3-devel gobject-introspection-devel pygobject3-devel i3 i3status
sudo yum install autoconf automake libtool intltoolize

cd i3blocks
./autogen.sh
./configure
make
make install
cd ..

#https://github.com/v1cont/yad
#autoreconf -ivf && intltoolize
#./configure && make && sudo make install
#gtk-update-icon-cache

sudo apt install autotools-dev autoconf-archive gettext intltool libadwaita-1-dev
# https://github.com/PintaProject/Pinta/archive/refs/heads/master.zip

#Screen shots
sudo yum install gthumb
# Edit picture properties and set as default app
