#!/bin/bash
mkdir -p ~/.local/share/applications/icons
curl -sL -o ~/.local/share/applications/icons/Claude.png "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/claude-ai.png"
cat > ~/.local/share/applications/Claude.desktop <<EOF
[Desktop Entry]
Version=1.0
Name=Claude
Comment=Claude AI Web App
Exec=brave --new-window --app="https://claude.ai"
Terminal=false
Type=Application
Icon=/home/$USER/.local/share/applications/icons/Claude.png
StartupNotify=true
Categories=Network;WebBrowser;
EOF
chmod +x ~/.local/share/applications/Claude.desktop
echo "✅ Claude web app created!"