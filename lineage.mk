# Copyright (C) 2018 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Inherit from hardware-specific part of the product configuration
$(call inherit-product, $(LOCAL_PATH)/device.mk)

# Inherit some common lineageos stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Boot animation
TARGET_SCREEN_HEIGHT	:= 1920
TARGET_SCREEN_WIDTH		:= 1080
DEVICE_RESOLUTION		:= 1080x1920

# Release name
PRODUCT_RELEASE_NAME := SONY Xperia XA1 Plus

PRODUCT_DEVICE			:= teak
PRODUCT_NAME			:= lineage_teak
PRODUCT_BRAND			:= Sony
PRODUCT_MODEL			:= SONY Xperia XA1 Plus
PRODUCT_MANUFACTURER		:= SONY

# Google client ID property.
PRODUCT_GMS_CLIENTID_BASE := android-sony

BUILD_FINGERPRINT := alps/full_teak/teak:8.0.0/O00623/1564589454:user/test-keys

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=teak \
    PRIVATE_BUILD_DESC="full_teak-user 8.0.0 O00623 1564589454 test-keys"
