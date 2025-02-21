mkdir --parents ~/Applications/Flameshot
cd ~/Applications/Flameshot
rm Flameshot-*x86_64.AppImage
curl --remote-name \
    --remote-header-name \
    --location $(curl -s https://api.github.com/repos/flameshot-org/flameshot/releases/latest \
                | grep -Po 'https://github.com/flameshot-org/flameshot/releases/download/[^}]*\.AppImage' \
                | uniq)
chmod +x Flameshot-*.x86_64.AppImage
