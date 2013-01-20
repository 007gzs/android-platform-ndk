#!/bin/bash
#
# Copyright (C) 2011, 2013 The Android Open Source Project
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
# Build the host version of the awk executable and place it
# at the right location

PROGDIR=$(dirname $0)
. $PROGDIR/prebuilt-common.sh

PROGRAM_PARAMETERS=""
PROGRAM_DESCRIPTION=\
"Rebuild the host awk tool used by the NDK."

register_try64_option
register_mingw_option
register_jobs_option

NDK_DIR=$ANDROID_NDK_ROOT
register_var_option "--ndk-dir=<path>" NDK_DIR "Specify NDK install directory"

PACKAGE_DIR=
register_var_option "--package-dir=<path>" PACKAGE_DIR "Archive to package directory"

OUT_DIR=/tmp/ndk-$USER
OPTION_OUT_DIR=
register_option "--out-dir=<path>" do_out_dir "Path to build out directory" "$OUT_DIR"
do_out_dir() { OPTION_OUT_DIR=$1; }

GNUMAKE=make
register_var_option "--make=<path>" GNUMAKE "Specify GNU Make program"

extract_parameters "$@"

fix_option OUT_DIR "$OPTION_OUT_DIR" "out directory"
setup_default_log_file $OUT_DIR/build.log
OUT_DIR=$OUT_DIR/host-awk

SUBDIR=$(get_prebuilt_host_exec awk)
OUT=$NDK_DIR/$SUBDIR

AWK_VERSION=20071023
AWK_SRCDIR=$ANDROID_NDK_ROOT/sources/host-tools/nawk-$AWK_VERSION
if [ ! -d "$AWK_SRCDIR" ]; then
    echo "ERROR: Can't find nawk-$AWK_VERSION source tree: $AWK_SRCDIR"
    exit 1
fi

log "Using sources from: $AWK_SRCDIR"

prepare_host_build

BUILD_MINGW=
if [ "$MINGW" = "yes" ]; then
  BUILD_MINGW=yes
fi
if [ "$TRY64" = "yes" ]; then
  BUILD_TRY64=yes
fi
V=0
if [ "$VERBOSE2" = "yes" ]; then
  V=1
fi

CFLAGS="$HOST_CFLAGS"
CFLAGS=$CFLAGS" -O2 -s -I$OUT_DIR -I$AWK_SRCDIR"
LDFLAGS="$HOST_LDFLAGS"
LDFLAGS=$LDFLAGS" -Wl,-s"

log "Configuring the build"
mkdir -p $OUT_DIR && rm -rf $OUT_DIR/*
prepare_mingw_toolchain $OUT_DIR
log "Building $HOST_TAG awk"
export HOST_CC="$CC" &&
run $GNUMAKE \
    -C "$AWK_SRCDIR" \
    -j $NUM_JOBS \
    CFLAGS="$CFLAGS" \
    LDFLAGS="$LDFLAGS" \
    OUT_DIR="$OUT_DIR" \
    MINGW="$BUILD_MINGW" \
    TRY64="$BUILD_TRY64" \
    V="$V"
fail_panic "Failed to build the awk-$AWK_VERSION executable!"

log "Copying executable to prebuilt location"
run mkdir -p $(dirname "$OUT") && cp "$OUT_DIR/$(get_host_exec_name ndk-awk)" "$OUT"
fail_panic "Could not copy executable to: $OUT"

if [ "$PACKAGE_DIR" ]; then
    ARCHIVE=ndk-awk-$HOST_TAG.tar.bz2
    dump "Packaging: $ARCHIVE"
    mkdir -p "$PACKAGE_DIR" &&
    pack_archive "$PACKAGE_DIR/$ARCHIVE" "$NDK_DIR" "$SUBDIR"
    fail_panic "Could not package archive: $PACKAGE_DIR/$ARCHIVE"
fi

log "Cleaning up"
if [ -z "$OPTION_OUT_DIR" ]; then
    rm -rf $OUT_DIR
fi

log "Done."

