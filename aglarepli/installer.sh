#!/bin/bash
#
# Command: wget -q "--no-check-certificate" https://raw.githubusercontent.com/popking159/skins/refs/heads/main/aglarepli/installer.sh -O - | /bin/sh #
echo "------------------------------------------------------------------------"
echo "             You are going to install Aglare-FHD-PLI                    "
echo "------------------------------------------------------------------------"
echo "removing the previous version of Aglare-FHD-PLI... "
sleep 2;
if [ -d /usr/share/enigma2/Aglare-FHD-PLI ] ; then
    opkg remove enigma2-plugin-skins-aglare-fhd-pli
    rm -rf /usr/share/enigma2/Aglare-FHD-PLI > /dev/null 2>&1
    echo 'Package removed.'
else
    echo "You do not have previous version of Aglare-FHD-PLI"
fi
echo ""
# Install curl if not already installed
echo "Install curl if not already installed "
opkg install curl
sleep 2

#
cd /tmp
echo "Downloading Aglare-FHD-PLI skin package..."
curl -s -k -L "https://raw.githubusercontent.com/popking159/skins/main/aglarepli/aglarepli.ipk" -o /tmp/aglarepli.ipk
if [ $? -ne 0 ]; then
    echo "Error downloading Aglare-FHD-PLI"
    exit 1
fi
sleep 1

echo "Installing ...."
opkg install --force-overwrite /tmp/aglarepli.ipk
if [ $? -ne 0 ]; then
    echo "Error installing Aglare-FHD-PLI"
    exit 1
fi

echo ""
echo ""
echo ""
sleep 1

echo "Clean up the temporary file"
if [ -f /tmp/aglarepli.ipk ]; then
    rm -f /tmp/aglarepli.ipk
fi

echo "Done"
#
echo "------------------------------------------------------------------------"
echo "                            CONGRATULATIONS                             "
echo "                  Aglare-FHDPLI Installed Successfully                  "
echo "------------------------------------------------------------------------"
echo "   "
exit 0
