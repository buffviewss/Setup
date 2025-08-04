#!/bin/bash

# =========================
# Setup Nekobox on Ubuntu/Lubuntu (Fixed)
# =========================

set -e  # Stop if any command fails

# 1. Update & Upgrade
echo "🔄 Updating system packages..."
sudo add-apt-repository universe -y || true
sudo apt update && sudo apt upgrade -y

# 2. Install Open VM Tools
echo "📦 Installing Open VM Tools..."
sudo apt install -y open-vm-tools open-vm-tools-desktop || echo "⚠️ Warning: Open VM Tools not found for this Ubuntu version."

# 3. Install gdown and unzip
echo "📦 Installing gdown & unzip..."
sudo apt install -y python3-pip unzip
if ! command -v pip3 &> /dev/null; then
    echo "⚠️ pip3 missing, installing..."
    sudo apt install -y python3-pip
fi
pip3 install --upgrade pip gdown

# 4. Install core build tools and Qt5 libraries
echo "📦 Installing build tools and Qt5 libraries..."
sudo apt install -y build-essential \
libqt5network5 \
libqt5core5a \
libqt5gui5 \
libqt5widgets5 \
qtbase5-dev \
libqt5x11extras5 \
libqt5quick5 \
libqt5quickwidgets5 \
libqt5quickparticles5

# 5. Prepare Nekoray folder
echo "📂 Preparing Nekoray folder..."
rm -rf ~/Downloads/nekoray
mkdir -p ~/Downloads/nekoray

# 6. Download Nekobox ZIP from Google Drive
echo "⬇️ Downloading Nekobox from Google Drive..."
cd ~/Downloads

# ⚠️ Thay ID này bằng ID thực tế của file Nekobox trên Google Drive!
FILE_ID="1ZnubkMQL06AWZoqaHzRHtJTEtBXZ8Pdj"  
gdown --id "$FILE_ID" -O nekobox.zip || { echo "❌ Download failed! Check Google Drive file ID."; exit 1; }

# 7. Extract Nekobox
echo "📂 Extracting Nekobox..."
unzip -o nekobox.zip -d ~/Downloads/nekoray

# 8. Handle nested folders
inner_dir=$(find ~/Downloads/nekoray -mindepth 1 -maxdepth 1 -type d | head -n 1)
if [ "$inner_dir" != "" ] && [ "$inner_dir" != "$HOME/Downloads/nekoray" ]; then
    echo "📂 Adjusting folder structure..."
    mv "$inner_dir"/* ~/Downloads/nekoray/
    rm -rf "$inner_dir"
fi

# 9. Grant execution permissions
echo "🔑 Setting execution permissions..."
cd ~/Downloads/nekoray
chmod +x launcher nekobox nekobox_core || echo "⚠️ Some files not found, skipping chmod."

# 10. Create desktop shortcut
echo "🖥️ Creating desktop shortcut..."
cat <<EOF > ~/Desktop/nekoray.desktop
[Desktop Entry]
Version=1.0
Name=Nekobox
Comment=Open Nekobox
Exec=$HOME/Downloads/nekoray/nekobox
Icon=$HOME/Downloads/nekoray/nekobox.png
Terminal=false
Type=Application
Categories=Utility;
EOF

chmod +x ~/Desktop/nekoray.desktop

# 11. Launch Nekobox
echo "🚀 Launching Nekobox..."
./nekobox || echo "⚠️ Unable to launch Nekobox automatically. Start manually from ~/Downloads/nekoray."

echo "✅ Setup completed successfully!"
