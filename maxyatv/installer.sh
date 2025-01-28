#!/bin/bash
#
# Command: wget -q "--no-check-certificate" https://raw.githubusercontent.com/popking159/skins/refs/heads/main/maxyatv/installer.sh -O - | /bin/sh #
echo "------------------------------------------------------------------------"
echo "              You are going to install Maxy-FHD                       "
echo "------------------------------------------------------------------------"
echo "removing the previous version of Maxy-FHD... "
sleep 2;
if [ -d /usr/share/enigma2/Maxy-FHD ] ; then
    opkg remove enigma2-plugin-skins-maxy-fhd
    rm -rf /usr/share/enigma2/Maxy-FHD > /dev/null 2>&1
    echo 'Package removed.'
else
    echo "You do not have previous version of Maxy-FHD"
fi
echo ""
# Install curl if not already installed
echo "Install curl if not already installed "
opkg install curl
sleep 2

#
cd /tmp
echo "Downloading Maxy-FHD skin package..."
curl -s -k -L "https://raw.githubusercontent.com/popking159/skins/main/maxyatv/maxyatv.ipk" -o /tmp/maxyatv.ipk
if [ $? -ne 0 ]; then
    echo "Error downloading Maxy-FHD"
    exit 1
fi
sleep 1

echo "Installing ...."
opkg install --force-overwrite /tmp/maxyatv.ipk
if [ $? -ne 0 ]; then
    echo "Error installing Maxy-FHD"
    exit 1
fi

echo ""
echo ""
echo ""
sleep 1

echo "Clean up the temporary file"
if [ -f /tmp/maxyatv.ipk ]; then
    rm -f /tmp/maxyatv.ipk
fi

echo "Done"
#
echo "------------------------------------------------------------------------"
echo "                            CONGRATULATIONS                             "
echo "                    Maxy-FHD Installed Successfully                     "
echo "------------------------------------------------------------------------"
echo "   "
exit 0
