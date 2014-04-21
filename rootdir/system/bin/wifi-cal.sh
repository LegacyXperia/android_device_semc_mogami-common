#! /system/bin/sh

WIFION=`getprop init.svc.p2p_supplicant`
SAMPLE_NVS_FILE=/system/etc/firmware/ti-connectivity/wl1271-nvs_127x.bin
TARGET_NVS_FILE=/data/misc/wifi/wl1271-nvs.bin
TARGET_INI_FILE=/system/etc/wifi/TQS_S_2.6.ini
WL12xx_MODULE=/system/lib/modules/wl12xx_sdio.ko
HW_MAC=`cat /proc/cmdline | grep -o -E "wifi0.eth_addr=([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}" | sed s/wifi0.eth_addr=//`

# If target nvs exists, assume wifi is already calibrated
if [ -e $TARGET_NVS_FILE ];
then
    echo " *******************************"
    echo " * Wi-Fi is already calibrated *"
    echo " *******************************"
    setprop persist.wlan.ti.calibrated 1
    exit 0
fi

case "$WIFION" in
  "running") echo " ****************************************"
             echo " * Turning Wi-Fi off before calibration *"
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
    echo "*********************************"
    echo "* wl12xx_sdio module not found! *"
    echo "*********************************"
    exit
fi

# Actual calibration...
# calibrator plt autocalibrate <dev> <module path> <ini file1> <nvs file> <mac addr>
# Leaving mac address field empty for random mac
nvimport > /dev/null 2>&1
calibrator set upd_nvs $TARGET_INI_FILE /data/etc/wifi/fw $TARGET_NVS_FILE
calibrator set nvs_mac $TARGET_NVS_FILE $HW_MAC
setprop persist.wlan.ti.calibrated 1

echo " ******************************"
echo " * Finished Wi-Fi calibration *"
echo " ******************************"
case "$WIFION" in
  "running") echo " *************************"
             echo " * Turning Wi-Fi back on *"
             echo " *************************"
             svc wifi enable;;
esac

exit 0
