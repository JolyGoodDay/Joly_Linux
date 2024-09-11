# Install required packages
if [ -f /etc/os-release ]; then
    source /etc/os-release
    if [[ $ID == "ubuntu" ]]; then
        sudo apt update
        sudo apt install -y \
            apache2-utils \
            autotools-dev \
            autoconf \
            binutils \
            gcc \
            libc-dev \
            libpam0g-dev \
            libx11-dev \
            libxcomposite-dev \
            libxext-dev \
            libxfixes-dev \
            libxft-dev \
            libxmu-dev \
            libxrandr-dev \
            libxss-dev \
            make \
            mplayer \
            mpv \
            libpamtester \
            pkg-config \
            libxtst-dev \
            xscreensaver
    elif [[ $ID == "centos" && $VERSION_ID == "9" ]]; then
        sudo dnf update
        sudo dnf install -y \
            httpd-tools \
            autotools-devel \
            autoconf \
            binutils \
            gcc \
            glibc-devel \
            pam-devel \
            libX11-devel \
            libXcomposite-devel \
            libXext-devel \
            libXfixes-devel \
            libXft-devel \
            libXmu-devel \
            libXrandr-devel \
            libXss-devel \
            make \
            mplayer \
            mpv \
            pamtester \
            pkg-config \
            libXtst-devel \
            xscreensaver
    else
        echo "Unsupported distribution or version."
        exit 1
    fi
else
    echo "Unable to determine the operating system."
    exit 1
fi

source /etc/environment
source $joly_linux/src/common/set_joly_linux
mkdir -p tmp
cd tmp

if [ ! -d "xsecurelock" ]; then
    git clone https://github.com/google/xsecurelock.git
fi
cd xsecurelock
ls
sh autogen.sh
bash configure --with-pam-service-name=SERVICE-NAME
make
sudo make install