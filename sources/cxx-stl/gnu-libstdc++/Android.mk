LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := gnustl_static
LOCAL_SRC_FILES := libs/$(TARGET_ARCH_ABI)/$(TARGET_TOOLCHAIN_VERSION)/libgnustl_static.a
LOCAL_EXPORT_CPPFLAGS := -fexceptions -frtti
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include/$(TARGET_TOOLCHAIN_VERSION) \
                           $(LOCAL_PATH)/libs/$(TARGET_ARCH_ABI)/$(TARGET_TOOLCHAIN_VERSION)/include
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := gnustl_shared
LOCAL_SRC_FILES := libs/$(TARGET_ARCH_ABI)/$(TARGET_TOOLCHAIN_VERSION)/libgnustl_shared.so
LOCAL_EXPORT_CPPFLAGS := -fexceptions -frtti
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include/$(TARGET_TOOLCHAIN_VERSION) \
                           $(LOCAL_PATH)/libs/$(TARGET_ARCH_ABI)/$(TARGET_TOOLCHAIN_VERSION)/include
LOCAL_EXPORT_LDLIBS := $(call host-path,$(LOCAL_PATH)/libs/$(TARGET_ARCH_ABI)/$(TARGET_TOOLCHAIN_VERSION)/libsupc++.a)
include $(PREBUILT_SHARED_LIBRARY)
