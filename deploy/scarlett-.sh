# https://github.com/geoffreybennett/alsa-scarlett-gui/blob/master/docs/INSTALL.md
sudo apt -y install git make gcc libgtk-4-dev libasound2-dev libssl-dev

mkdir -p tmp
cd tmp
git clone https://github.com/geoffreybennett/alsa-scarlett-gui.git
cd alsa-scarlett-gui
cd src
make -j12