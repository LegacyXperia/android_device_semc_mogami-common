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
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml

# Init file
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/rootdir/init.semc.rc:root/init.semc.rc

# WiFi config & related files
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/rootdir/system/bin/wifiload:system/bin/wifiload

PRODUCT_PACKAGES += \
    dhcpcd.conf \
    hostapd.conf \
    wpa_supplicant.conf \
    calibrator

# wl1273 BT/FM
PRODUCT_PACKAGES += \
    uim-sysfs \
    bt_sco_app \
    BluetoothSCOApp \
    libbt-vendor

# TI FM app
PRODUCT_PACKAGES += \
    FmRxApp \
    FmService \
    kfmapp \
    libfmradio \
    fmradioif \
    com.ti.fm.fmradioif.xml

PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=wlan0 \
    ro.telephony.ril_class=SemcQualcomm7x30RIL \
    ro.telephony.default_network=0

$(call inherit-product-if-exists, vendor/semc/mogami-common/mogami-common-vendor.mk)
