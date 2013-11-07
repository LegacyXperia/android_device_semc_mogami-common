#
# Install a symlink in /system/etc/firmware pointing to the eventual location
# of the modified nvs file on the device.  Snippet shamelessly stolen from
# external/busybox/Android.mk.
#
# If we didn't need this, there would be no need for this Makefile -- we'd just
# add the shell script to PRODUCT_COPY_FILES and be done with it.
#

NVS_FILENAME := wl1271-nvs.bin
NVS_SYMLINK_TARGET := /data/misc/wifi/$(NVS_FILENAME)
NVS_SYMLINK_DIR := $(TARGET_OUT_ETC)/firmware/ti-connectivity
NVS_SYMLINK := $(NVS_SYMLINK_DIR)/$(NVS_FILENAME)
$(NVS_SYMLINK): $(LOCAL_INSTALLED_MODULE)
	@echo "Symlink: $(NVS_SYMLINK) -> $(NVS_SYMLINK_TARGET)"
	@mkdir -p $(NVS_SYMLINK_DIR)
	@rm -rf $@
	$(hide) ln -sf $(NVS_SYMLINK_TARGET) $@

ALL_DEFAULT_INSTALLED_MODULES += $(NVS_SYMLINK)
ALL_MODULES.$(LOCAL_MODULE).INSTALLED := \
	$(ALL_MODULES.$(LOCAL_MODULE).INSTALLED) $(NVS_SYMLINK)

