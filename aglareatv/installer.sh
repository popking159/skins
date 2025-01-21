#!/bin/bash
#
# Command: wget -q "--no-check-certificate" https://raw.githubusercontent.com/popking159/skins/refs/heads/main/aglareatv/installer.sh -O - | /bin/sh #
echo "------------------------------------------------------------------------"
echo "              You are going to install Aglare-FHD                       "
echo "------------------------------------------------------------------------"
echo " removing the previous version of Aglare-FHD...      "
sleep 2;
if [ -d /usr/share/enigma2/Aglare-FHD ] ; then
    opkg remove enigma2-plugin-skins-aglare-fhd
    rm -rf /usr/share/enigma2/Aglare-FHD > /dev/null 2>&1
    echo 'Package removed.'
else
    echo "You do not have previous version of Aglare-FHD"
fi
echo ""

# Install curl if not already installed
opkg install curl
sleep 2

#
cd /tmp
echo "Downloading Aglare-FHD skin package..."
curl -s -k -L "https://raw.githubusercontent.com/popking159/skins/main/aglareatv/aglareatv.ipk" -o /tmp/aglareatv.ipk
if [ $? -ne 0 ]; then
    echo "Error downloading Aglare-FHD"
    exit 1
fi
sleep 1

echo "Installing ...."
opkg install --force-overwrite /tmp/aglareatv.ipk
if [ $? -ne 0 ]; then
    echo "Error installing Aglare-FHD"
    exit 1
fi

echo ""
echo ""
echo ""
sleep 1

echo "Clean up the temporary file"
if [ -f /tmp/aglareatv.ipk ]; then
    rm -f /tmp/aglareatv.ipk
fi

echo "Done"
#
echo "------------------------------------------------------------------------"
echo "                            CONGRATULATIONS                             "
echo "                   Aglare-FHD Installed Successfully                    "
echo "------------------------------------------------------------------------"
echo "   "
exit 0
