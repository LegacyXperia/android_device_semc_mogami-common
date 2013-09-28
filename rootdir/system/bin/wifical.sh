#! /system/bin/sh

WIFION=`getprop init.svc.p2p_supplicant`
TARGET_FW_DIR=/system/etc/firmware/ti-connectivity
TARGET_NVS_FILE=$TARGET_FW_DIR/wl1271-nvs.bin
TARGET_INI_FILE=/system/etc/tiwlan.ini
WL12xx_MODULE=/system/lib/modules/wl12xx_sdio.ko
HW_MAC=`cat /proc/cmdline | grep -o -E "wifi0.eth_addr=([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}" | sed s/wifi0.eth_addr=//`

case "$WIFION" in
  "running") echo " ****************************************"
             echo " * Turning Wi-Fi OFF before calibration *"
             echo " ****************************************"
             svc wifi disable
             rmmod $WL12xx_MODULE;;
          *) echo " ******************************"
             echo " * Starting Wi-Fi calibration *"
             echo " ******************************";;
esac

if [ -e $WL12xx_MODULE ];
then
    echo ""
else
    echo "********************************************************"
    echo "* wl12xx_sdio module not found !!"
    echo "********************************************************"
    exit
fi

# Remount system partition as rw
mount -o remount rw /system

# Remove old NVS file
rm /system/etc/firmware/ti-connectivity/wl1271-nvs.bin

# Actual calibration...
# calibrator plt autocalibrate <dev> <module path> <ini file1> <nvs file> <mac addr>
# Leaving mac address field empty for random mac
calibrator plt autocalibrate wlan0 $WL12xx_MODULE $TARGET_INI_FILE $TARGET_NVS_FILE $HW_MAC

echo " ******************************"
echo " * Finished Wi-Fi calibration *"
echo " ******************************"
case "$WIFION" in
  "running") echo " *************************"
             echo " * Turning Wi-Fi back on *"
             echo " *************************"
             svc wifi enable;;
esac

# Remount system partition as ro
mount -o remount ro /system
