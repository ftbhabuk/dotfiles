#!/bin/bash
mkdir -p ~/.local/share/applications/icons
curl -sL -o ~/.local/share/applications/icons/Grok.png "https://images.seeklogo.com/logo-png/61/2/grok-logo-png_seeklogo-613403.png"
cat > ~/.local/share/applications/Grok.desktop <<EOF
[Desktop Entry]
Version=1.0
Name=Grok
Comment=Grok AI Web App
Exec=brave --profile-directory=Default --new-window --app="https://grok.com"
Terminal=false
Type=Application
Icon=$HOME/.local/share/applications/icons/Grok.png
StartupNotify=true
Categories=Network;WebBrowser;
EOF
chmod +x ~/.local/share/applications/Grok.desktop
echo "✅ Grok web app created!"
