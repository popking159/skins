#!/bin/bash
#
# Command: wget -q "--no-check-certificate" https://raw.githubusercontent.com/popking159/skins/refs/heads/main/lukapli/installer.sh -O - | /bin/sh #
echo "------------------------------------------------------------------------"
echo "             You are going to install Luka-FHD-PLI                      "
echo "------------------------------------------------------------------------"
echo "removing the previous version of Luka-FHD-PLI... "
sleep 2;
if [ -d /usr/share/enigma2/Luka-FHD-PLI ] ; then
    opkg remove enigma2-plugin-skins-luka-fhd-pli
    rm -rf /usr/share/enigma2/Luka-FHD-PLI > /dev/null 2>&1
    echo 'Package removed.'
else
    echo "You do not have previous version of Luka-FHD-PLI"
fi
echo ""
# Install curl if not already installed
echo "Install curl if not already installed "
opkg install curl
sleep 2

#
cd /tmp
echo "Downloading Luka-FHD-PLI skin package..."
curl -s -k -L "https://raw.githubusercontent.com/popking159/skins/main/lukapli/lukapli.ipk" -o /tmp/lukapli.ipk
if [ $? -ne 0 ]; then
    echo "Error downloading Luka-FHD-PLI"
    exit 1
fi
sleep 1

echo "Installing ...."
opkg install --force-overwrite /tmp/lukapli.ipk
if [ $? -ne 0 ]; then
    echo "Error installing Luka-FHD-PLI"
    exit 1
fi

echo ""
echo ""
echo ""
sleep 1

echo "Clean up the temporary file"
if [ -f /tmp/lukapli.ipk ]; then
    rm -f /tmp/lukapli.ipk
fi

echo "Done"
#
echo "----------------------------------------------------------------------"
echo "                            CONGRATULATIONS                           "
echo "                 Luka-FHD-PLI Installed Successfully                  "
echo "----------------------------------------------------------------------"
echo "   "
exit 0
