#!/bin/sh
# ==============================================================================
# Aglare-FHD Skin Installer for OpenATV / Enigma2
# ==============================================================================

PACKAGE_NAME="enigma2-plugin-skins-aglare-fhd"
SKIN_DIR="/usr/share/enigma2/Aglare-FHD"
IPK_URL="https://raw.githubusercontent.com/popking159/skins/main/aglareatv/aglareatv.ipk"
TMP_IPK="/tmp/aglareatv.ipk"

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo "========================================================================"
echo -e "${BLUE}                   Aglare-FHD Online Installer                        ${NC}"
echo "========================================================================"
echo ""

# 1. Clean previous installation to prevent obsolete file clashes
if [ -d "$SKIN_DIR" ]; then
    echo -e "${YELLOW}--> Removing previous version of Aglare-FHD...${NC}"
    opkg remove "$PACKAGE_NAME" --force-depends >/dev/null 2>&1
    rm -rf "$SKIN_DIR" >/dev/null 2>&1
    echo -e "${GREEN}--> Previous skin files cleaned.${NC}"
else
    echo -e "${BLUE}--> Fresh installation detected.${NC}"
fi

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
echo -e "${YELLOW}--> Downloading Aglare-FHD IPK package...${NC}"
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
echo -e "${YELLOW}--> Installing Aglare-FHD package...${NC}"
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
echo -e "${GREEN}                  Aglare-FHD was installed successfully!               ${NC}"
echo "========================================================================"
echo ""

exit 0
