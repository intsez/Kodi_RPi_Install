#!/bin/bash
# https://www.raspberrypi.org/forums/viewtopic.php?t=251645

# Run script as root
if [[ "$EUID" -ne 0 ]]; then
echo -e "Sorry, you need to run this as root"
exit 1
fi

echo ""
echo "Select Raspberry Pi model:"
echo " 1) RPi3 and below (only with Broadcom drivers)"
echo " 2) RPi 4 (only with OpenGL desktop driver - Fake KMS)"
echo " 3) Exit"
echo ""
while [[ $RVER != "1" && $RVER != "2" && $RVER != "3" ]]; do
read -p "Select an option [1-3]: " RVER
done
case $RVER in
1)
# RPI 0/1/2/3
echo ""
echo -e "If You want to watch h264 50/60fps videos on RPi 0/1/2 you may need to modify '/boot/config.txt'"
while [[ $DAUT != "y" && $DAUT != "n" ]]; do
read -p "Modify config.txt for you? [y/n]: " -e DAUT
done
if [[ $DAUT = "y" ]]; then
echo -e "\n#Support for h264 50/60fps video files\ndisable_auto_turbo=0" >> /boot/config.txt
else
echo "-----------------------------------------------------------------------------"
echo ""
echo ">>> In case of problems add 'disable_auto_turbo=0' to boot/config.txt <<< "
fi
# Amount of GPU memory
echo ""
echo "-----------------------------------------------------------------------------"
echo "160 > MB minimum for RPi 0/1/2/3 to function properly"
echo "256 > MB RPi 2/3 for 10bit videos (h264 + h265/HEVC) -> recommended"
echo "300 > MB RPi 3B/3B+ for 720p 10bit and 1080p 10bit (low bitrate only at max!)"
echo "-----------------------------------------------------------------------------"
;;
2) # RPI 4
echo ""
echo -e "If you have 4K TV/monitor and want to watch movies in 60Hz instead 30Hz\nadd 'hdmi_enable_4kp60=1' to /boot/config.txt"
echo ""
while [[ $EFORK != "y" && $EFORK != "n" ]]; do
read -p "Add value for you to config.txt? [y/n]: " -e EFORK
done
if [[ $EFORK = "y" ]]; then
echo -e "\n#Enables 4Kp60 for 4K monitor/TV\nhdmi_enable_4kp60=1" >> /boot/config.txt
fi
echo ""
echo "-----------------------------------------------------------------------------"
echo "160 > MB for RPi 0/1/2/3/4 to function properly."
echo "256 > MB for Kodi 18 on the RPi 4 (supports up to 4K h265/HEVC 10bit videos)"
echo "-----------------------------------------------------------------------------"
;;
3)
echo ""
exit 0
;;
esac
echo ""
echo "Enter amount of memory for GPU (you can change that later in /boot/config.txt):"
read -p ":" ARAM
echo ""
# GPU size and VP6, VP8, MJPEG, Theora codecs
echo -e "#GPU RAM SIZE\ngpumem=${ARAM}\n# Do not turn TV during boot\nhdmi_ignore_cec_init=1\n# Enable VP6, VP8, MJPEG, Theora codecs\nstart_x=1" >> /boot/config.txt
# install kodi
echo "Please wait updating repositories, installing Kodi..."
apt update; apt install kodi -y #kodi-vfs-libarchive -y

while [[ $CUKDI != "y" && $CUKDI != "n" ]]; do
echo ""
read -p "Create new user for Kodi and add him to all necessary groups? [y/n]: " -e CUKDI
done

if [[ $CUKDI = 'y' ]]; then
echo ""
read -p "Enter username: " -e KODIUSR
adduser ${KODIUSR}
usermod -a -G audio,video,input,dialout,plugdev,netdev,users,cdrom,tty ${KODIUSR}
fi

echo ""
echo "Entries added to /boot/config.txt"
echo ""
echo "Run kodi with 'kodi-standalone' or 'kodi' command. Bye!"
echo ""
exit
