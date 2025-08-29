#!/bin/bash
#
# Command: wget -q "--no-check-certificate" https://raw.githubusercontent.com/popking159/skins/refs/heads/main/lukaatv/installer.sh -O - | /bin/sh #
echo "------------------------------------------------------------------------"
echo "              You are going to install Luka-FHD                       "
echo "------------------------------------------------------------------------"
echo "removing the previous version of Luka-FHD... "
sleep 2;
if [ -d /usr/share/enigma2/Luka-FHD ] ; then
    opkg remove enigma2-plugin-skins-luka-fhd
    rm -rf /usr/share/enigma2/Luka-FHD > /dev/null 2>&1
    echo 'Package removed.'
else
    echo "You do not have previous version of Luka-FHD"
fi
echo ""
# Install curl if not already installed
echo "Install curl if not already installed "
opkg install curl
sleep 2

#
cd /tmp
echo "Downloading Luka-FHD skin package..."
curl -s -k -L "https://raw.githubusercontent.com/popking159/skins/main/lukaatv/lukaatv.ipk" -o /tmp/aglareatv.ipk
if [ $? -ne 0 ]; then
    echo "Error downloading Luka-FHD"
    exit 1
fi
sleep 1

echo "Installing ...."
opkg install --force-overwrite /tmp/lukaatv.ipk
if [ $? -ne 0 ]; then
    echo "Error installing Luka-FHD"
    exit 1
fi

echo ""
echo ""
echo ""
sleep 1

echo "Clean up the temporary file"
if [ -f /tmp/lukaatv.ipk ]; then
    rm -f /tmp/lukaatv.ipk
fi

echo "Done"
#
echo "----------------------------------------------------------------------"
echo "                            CONGRATULATIONS                           "
echo "                   Luka-FHD Installed Successfully                    "
echo "----------------------------------------------------------------------"
echo "   "
exit 0
