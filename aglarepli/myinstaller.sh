#!/bin/sh
# wget -qO - https://raw.githubusercontent.com/popking159/skins/refs/heads/main/aglarepli/myinstaller.sh | /bin/sh
# ==============================================================================
# Aglare-FHD-PLI Skin Installer for OpenPLi / Enigma2
# ==============================================================================

PACKAGE_NAME="enigma2-plugin-skins-aglare-fhd-pli"
SKIN_DIR="/usr/share/enigma2/Aglare-FHD-PLI"
IPK_URL="https://raw.githubusercontent.com/popking159/skins/main/aglarepli/enigma2-plugin-skins-aglare-fhd-pli_7.3_all.ipk"
TMP_IPK="/tmp/aglarepli.ipk"

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo "========================================================================"
echo -e "${BLUE}                   Aglare-FHD-PLI Online Installer                        ${NC}"
echo "========================================================================"
echo ""

# 1. Clean previous installation to prevent obsolete file clashes
echo -e "${YELLOW}--> Checking for previous versions and cleaning old remnants...${NC}"

# Remove package if installed
if opkg status "$PACKAGE_NAME" 2>/dev/null | grep -q "^Status:.*installed"; then
    opkg remove "$PACKAGE_NAME" --force-depends >/dev/null 2>&1
fi

# Deep clean of all specified skin files, converters, and renderers
rm -rf /usr/share/enigma2/Aglare-FHD-PLI > /dev/null 2>&1
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/Aglare > /dev/null 2>&1
rm -rf /usr/lib/enigma2/python/Components/Aglare* > /dev/null 2>&1
rm -rf /usr/lib/enigma2/python/Components/Converter/Aglare* > /dev/null 2>&1
rm -rf /usr/lib/enigma2/python/Components/Renderer/Aglare* > /dev/null 2>&1
rm -rf /usr/lib/enigma2/python/Components/Renderer/Agp* > /dev/null 2>&1
rm -rf /usr/lib/enigma2/python/Components/Renderer/Agb* > /dev/null 2>&1
rm -rf /usr/lib/enigma2/python/Components/Renderer/Agban* > /dev/null 2>&1

echo -e "${GREEN}--> Cleanup complete.${NC}"
echo ""

# 2. Check / Install download tool (curl or wget)
echo -e "${YELLOW}--> Checking download tools...${NC}"
DOWNLOADER=""
if command -v curl >/dev/null 2>&1; then
    DOWNLOADER="curl"
elif command -v wget >/dev/null 2>&1; then
    DOWNLOADER="wget"
else
    echo -e "${YELLOW}--> Installing curl package...${NC}"
    opkg update >/dev/null 2>&1
    opkg install curl >/dev/null 2>&1
    if command -v curl >/dev/null 2>&1; then
        DOWNLOADER="curl"
    else
        DOWNLOADER="wget"
    fi
fi

# 3. Clean any existing temporary files
rm -f "$TMP_IPK"

# 4. Download IPK package
echo -e "${YELLOW}--> Downloading Aglare-FHD-PLI IPK package...${NC}"
if [ "$DOWNLOADER" = "curl" ]; then
    curl -kfsSL "$IPK_URL" -o "$TMP_IPK"
else
    wget --no-check-certificate -q "$IPK_URL" -O "$TMP_IPK"
fi

# 5. Verify download integrity
if [ ! -f "$TMP_IPK" ]; then
    echo ""
    echo -e "${RED}[ERROR] Download failed! IPK file was not found in /tmp.${NC}"
    exit 1
fi

FILE_SIZE=$(wc -c < "$TMP_IPK" 2>/dev/null || stat -c%s "$TMP_IPK" 2>/dev/null || echo 0)
if [ "$FILE_SIZE" -lt 1000000 ]; then
    echo ""
    echo -e "${RED}[ERROR] Downloaded package is incomplete or corrupted ($FILE_SIZE bytes).${NC}"
    rm -f "$TMP_IPK"
    exit 1
fi

echo -e "${GREEN}--> Package downloaded successfully ($FILE_SIZE bytes).${NC}"
echo ""

# 6. Install the IPK using opkg with force overwrite
echo -e "${YELLOW}--> Installing Aglare-FHD-PLI package...${NC}"
opkg install --force-overwrite --force-downgrade "$TMP_IPK"
INSTALL_STATUS=$?

echo ""

# 7. Cleanup temporary file
echo -e "${YELLOW}--> Cleaning up temporary files...${NC}"
rm -f "$TMP_IPK"
sync

if [ $INSTALL_STATUS -ne 0 ]; then
    echo ""
    echo -e "${RED}[ERROR] opkg installation encountered errors (code $INSTALL_STATUS).${NC}"
    exit 1
fi

echo ""
echo "========================================================================"
echo -e "${GREEN}                  CONGRATULATIONS - INSTALLATION COMPLETE              ${NC}"
echo -e "${GREEN}                  Aglare-FHD-PLI was installed successfully!           ${NC}"
echo "========================================================================"
echo ""

exit 0
