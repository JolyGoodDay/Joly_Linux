sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update

# Define an array of packages with comments
packages=(
    "numlockx          # Num Lock utility"
    "i3                # Window manager"
    "i3status          # Status bar for i3"
    "libreoffice       # Office suite"
    "python3-gi        # Python bindings for GObject"
    "python3-gi-cairo  # Cairo bindings for Python"
    "gir1.2-gtk-4.0    # GTK 4.0 bindings"
    "libcairo2-dev     # Cairo graphics library development files"
    "libgirepository1.0-dev # GObject introspection development files"
    "build-essential   # Essential build tools"
    "pkg-config        # Package configuration tool"
    "meson             # Build system"
    "ninja-build       # Build system"
    "libglib2.0-dev    # GLib development files"
    "xournalpp         # PDF viewer"
    "gthumb            # Image viewer"
    "alacritty         # Terminal emulator"
    "oneko             # Cat that chases the mouse"
)

# Install each package in the list
for package in "${packages[@]}"; do
    # Extract the package name by splitting on spaces
    pkg_name=$(echo $package | awk '{print $1}')
    # Extract the comment by removing the package name
    comment=$(echo $package | cut -d' ' -f2-)
    # Print the comment
    echo "Installing ${pkg_name}: ${comment}"
    # Install the package
    sudo apt install -y $pkg_name
done
