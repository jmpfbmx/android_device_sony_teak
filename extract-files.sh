#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017 The LineageOS Project
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
#

set -e

DEVICE=teak
VENDOR=sony

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

LINEAGE_ROOT="$MY_DIR"/../../..

HELPER="$LINEAGE_ROOT"/vendor/lineage/build/tools/extract_utils.sh
if [ ! -f "$HELPER" ]; then
    echo "Unable to find helper script at $HELPER"
    exit 1
fi
. "$HELPER"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

while [ "$1" != "" ]; do
    case $1 in
        -n | --no-cleanup )     CLEAN_VENDOR=false
                                ;;
        -s | --section )        shift
                                SECTION=$1
                                CLEAN_VENDOR=false
                                ;;
        * )                     SRC=$1
                                ;;
    esac
    shift
done

if [ -z "$SRC" ]; then
    SRC=adb
fi

# Initialize the helper
setup_vendor "$DEVICE" "$VENDOR" "$LINEAGE_ROOT" false "$CLEAN_VENDOR"

extract "$MY_DIR"/proprietary-files.txt "$SRC" "$SECTION"

BLOB_ROOT="$LINEAGE_ROOT"/vendor/"$VENDOR"/"$DEVICE"/proprietary

# Remove rild and rilproxy oneshot
for RIL_RC in "$BLOB_ROOT"/vendor/etc/init/rild.rc "$BLOB_ROOT"/vendor/etc/init/rilproxy.rc ; do
sed -i "/oneshot/d" "$RIL_RC" || true
done

# Remove libkeymaster1.so and add libkeymaster_portable.so and libkeymaster_staging.so as dependencies for Fingerprint Libs
for FP_LIB in $(grep -lr "libkeymaster1.so" $BLOB_ROOT); do
    patchelf --remove-needed libkeymaster1.so "$FP_LIB" || true
    patchelf --add-needed libkeymaster_portable.so "$FP_LIB" || true
    patchelf --add-needed libkeymaster_staging.so "$FP_LIB" || true
done

# Hex edit mtk-ril.so to receive incoming calls
for MTKRIL_LIB in "$BLOB_ROOT"/vendor/lib/mtk-ril.so "$BLOB_ROOT"/vendor/lib64/mtk-ril.so; do
    sed -i -e 's/AT+EAIC=2/AT+EAIC=3/g' "$MTKRIL_LIB" || true
done

"$MY_DIR"/setup-makefiles.sh
