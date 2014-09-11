# Copyright (C) 2011-2013 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

-include device/semc/msm7x30-common/msm7x30.mk

COMMON_PATH := device/semc/mogami-common

DEVICE_PACKAGE_OVERLAYS += device/semc/mogami-common/overlay

# These are the hardware-specific features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml

# Init file
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/rootdir/init.board.rc:root/init.board.rc

# WiFi config & related files
$(call inherit-product, hardware/ti/wlan/mac80211/wl127x-wlan-products.mk)

PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/rootdir/system/bin/wifi-cal.sh:system/bin/wifi-cal.sh \
    $(COMMON_PATH)/rootdir/system/etc/init.crda.sh:system/etc/init.crda.sh \
    $(COMMON_PATH)/rootdir/system/etc/init.d/10dhcpcd:system/etc/init.d/10dhcpcd \
    $(COMMON_PATH)/rootdir/system/etc/wifi/wpa_supplicant_overlay.conf:system/etc/wifi/wpa_supplicant_overlay.conf \
    $(COMMON_PATH)/rootdir/system/etc/wifi/p2p_supplicant_overlay.conf:system/etc/wifi/p2p_supplicant_overlay.conf

PRODUCT_PACKAGES += \
    dhcpcd.conf \
    hostapd.conf \
    wpa_supplicant.conf \
    crda \
    regulatory.bin \
    calibrator

# BT
$(call inherit-product, hardware/ti/wpan/ti-wpan-products.mk)

# FM
#$(call inherit-product, hardware/ti/wpan/ti-wpan-fm-products.mk)

PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=wlan0 \
    ro.telephony.ril_class=SemcQualcomm7x30RIL \
    ro.telephony.default_network=0

# proprietary side of the board
$(call inherit-product, vendor/semc/mogami-common/mogami-common-vendor.mk)
