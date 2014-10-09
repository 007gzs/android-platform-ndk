#ifndef NDK_TEST_WCHAR_1813a21b152a422abd7bb907b2661916
#define NDK_TEST_WCHAR_1813a21b152a422abd7bb907b2661916

#ifdef NDEBUG
#undef NDEBUG
#endif

#include <sys/cdefs.h>
#include <assert.h>
#include <errno.h>
#include <limits.h>
#include <locale.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <wchar.h>
#include <wctype.h>
#include <sys/mman.h>

#ifdef __cplusplus
#define GLOBAL extern "C"
#else
#define GLOBAL
#endif

#if !defined(__ANDROID__) && !defined(PAGE_SIZE)
#define PAGE_SIZE 4096
#endif

#define CRYSTAX_FULL_LOCALES 0

#endif /* NDK_TEST_WCHAR_1813a21b152a422abd7bb907b2661916 */
