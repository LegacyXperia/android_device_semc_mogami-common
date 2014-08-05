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

-include device/semc/msm7x30-common/BoardConfigCommon.mk

TARGET_BOOTLOADER_BOARD_NAME := mogami

# WiFi
USES_TI_MAC80211 := true
ifdef USES_TI_MAC80211
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_wl12xx
WPA_SUPPLICANT_VERSION           := VER_0_8_X
BOARD_HOSTAPD_DRIVER             := NL80211
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_wl12xx
BOARD_WLAN_DEVICE                := wl12xx_mac80211
BOARD_SOFTAP_DEVICE              := wl12xx_mac80211
WIFI_DRIVER_MODULE_PATH          := "/system/lib/modules/wl12xx_sdio.ko"
WIFI_DRIVER_MODULE_NAME          := "wl12xx_sdio"
WIFI_FIRMWARE_LOADER             := ""
COMMON_GLOBAL_CFLAGS             += -DUSES_TI_MAC80211
endif

# Required for newer wpa_supplicant_8_ti versions to fix tethering
BOARD_WIFI_SKIP_CAPABILITIES := true

TARGET_MODULES_SOURCE := hardware/ti/wlan/mac80211/compat_wl12xx
TARGET_MODULES_SOURCE_DIR := compat_wl12xx

WLAN_MODULES:
	rm -rf $(KERNEL_OUT)/modules
	mkdir $(KERNEL_OUT)/modules
	cp -rf $(TARGET_MODULES_SOURCE) $(KERNEL_OUT)/modules
	$(MAKE) -C $(KERNEL_OUT)/modules/$(TARGET_MODULES_SOURCE_DIR) O=$(KERNEL_OUT)/COMPAT KERNEL_DIR=$(KERNEL_OUT) KLIB=$(KERNEL_OUT) KLIB_BUILD=$(KERNEL_OUT) ARCH=$(TARGET_ARCH) $(ARM_CROSS_COMPILE)
	mv $(KERNEL_OUT)/modules/$(TARGET_MODULES_SOURCE_DIR)/compat/compat.ko $(KERNEL_MODULES_OUT)
	mv $(KERNEL_OUT)/modules/$(TARGET_MODULES_SOURCE_DIR)/net/mac80211/mac80211.ko $(KERNEL_MODULES_OUT)
	mv $(KERNEL_OUT)/modules/$(TARGET_MODULES_SOURCE_DIR)/net/wireless/cfg80211.ko $(KERNEL_MODULES_OUT)
	mv $(KERNEL_OUT)/modules/$(TARGET_MODULES_SOURCE_DIR)/drivers/net/wireless/wl12xx/wl12xx.ko $(KERNEL_MODULES_OUT)
	mv $(KERNEL_OUT)/modules/$(TARGET_MODULES_SOURCE_DIR)/drivers/net/wireless/wl12xx/wl12xx_sdio.ko $(KERNEL_MODULES_OUT)
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-debug --strip-unneeded $(KERNEL_MODULES_OUT)/compat.ko
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-debug --strip-unneeded $(KERNEL_MODULES_OUT)/mac80211.ko
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-debug --strip-unneeded $(KERNEL_MODULES_OUT)/cfg80211.ko
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-debug --strip-unneeded $(KERNEL_MODULES_OUT)/wl12xx.ko
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-debug --strip-unneeded $(KERNEL_MODULES_OUT)/wl12xx_sdio.ko

TARGET_KERNEL_MODULES += WLAN_MODULES

# Bluetooth
BOARD_WPAN_DEVICE := true
BOARD_HAVE_BLUETOOTH_TI := true

# FM Radio
TARGET_PROVIDES_TI_FM_SERVICE := true
#BOARD_HAVE_QCOM_FM := true
#COMMON_GLOBAL_CFLAGS += -DQCOM_FM_ENABLED -DHAVE_SEMC_FM_RADIO

# Override healthd HAL
BOARD_HAL_STATIC_LIBRARIES := libhealthd.mogami

# Recovery
BOARD_RECOVERY_SWIPE := true

-include device/semc/msm7x30-common/Android.mk
