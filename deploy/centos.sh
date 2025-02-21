set -e
mkdir -p tmp
sudo pip install khal
function install_packages(){
    # Update and install required packages
    sudo yum update -y

    # Define an array of packages with comments
    packages=(
        "numlockx          # Utility to enable Num Lock on startup (might require manual installation)"
        "libreoffice       # Full-featured office suite (word processing, spreadsheets, etc.)"
        "i3                # Tiling window manager"
        "i3status          # Status bar for i3 window manager"
        "autoconf          # Tool for generating configuration scripts"
        "automake          # Tool for generating Makefile.in files"
        "libtool           # Generic library support script"
        "intltool          # Tools for internationalizing various kinds of data files"
        "pygobject3-devel  # Development files for Python bindings for GObject"
        "python3-gobject   # Python bindings for the GObject library"
        "python3-cairo     # Python bindings for the Cairo graphics library"
        "gtk4-devel        # Development files for GTK 4.0 (graphical toolkit for creating GUIs)"
        "cairo-devel       # Development files for the Cairo graphics library"
        "gobject-introspection-devel # Development files for GObject Introspection (required for language bindings)"
        "gcc               # GNU Compiler Collection, includes C, C++, and other compilers"
        "gcc-c++           # C++ compiler"
        "make              # Build automation tool"
        "pkgconfig         # Tool to configure compiler and linker flags for libraries"
        "meson             # High-performance build system"
        "ninja-build       # Small build system with a focus on speed"
        "glib2-devel       # Development files for GLib (low-level core library for GNOME)"
        "xournalpp         # PDF viewer and note-taking application (may need to build from source)"
        "gthumb            # Image viewer and browser for the GNOME desktop"
        "gettext           # GNU internationalization and localization library"
        "autoconf-archive  # Collection of reusable Autoconf macros"
        "cargo             # More"
        "g++               # More"
        "libxkbcommon-devel # more"
        "libxcb-devel"
        "cmake"
        "freetype-devel"
        "fontconfig-devel"
        "xsecurelock"
        "python3.11-tkinter"

    )
    #    "alacritty         # GPU-accelerated terminal emulator (may need to build from source)"
    #    "autotools-dev     # Updates infrastructure for older GNU Autotools"
    #     "intltoolize       # A command used by intltool for initializing internationalization"
    #     "libadwaita-1-dev  # Development files for the Adwaita theme library"

    pkg_to_ins=()
    # Install each package in the list
    for package in "${packages[@]}"; do
        # Extract the package name by splitting on spaces
        pkg_to_ins+="$(echo $package | awk '{print $1}') "
    done
    sudo yum install -y $pkg_to_ins
}
function install_i3blocks(){
    cd i3blocks
    ./autogen.sh
    ./configure
    make
    make install
    cd ..
}

function install_fonts(){
    mkdir -p ~/.fonts
    wget https://cdn.jsdelivr.net/gh/notofonts/notofonts.github.io/fonts/NotoSansEgyptianHieroglyphs/full/ttf/NotoSansEgyptianHieroglyphs-Regular.ttf -O ~/.fonts/NotoSansEgyptianHieroglyphs-Regular.ttf
    fc-cache -f -v
}

function install_alacritty(){
    cd tmp/
    git clone https://github.com/alacritty/alacritty.git
    cd alacritty
    cargo build --release
    sudo cp target/release/alacritty /usr/local/bin
    sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo desktop-file-install extra/linux/Alacritty.desktop
    sudo update-desktop-database
}
