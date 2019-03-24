
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := jpcre2

LOCAL_LDLIBS := -ldl -lm -lc 

LOCAL_CFLAGS := -fvisibility=hidden -DHAVE_CONFIG_H -DPCRE2_CODE_UNIT_WIDTH=8 

LOCAL_SRC_FILES :=   \
  src/pcre2_chartables.c \
  src/pcre2_auto_possess.c \
  src/pcre2_compile.c \
  src/pcre2_config.c \
  src/pcre2_context.c \
  src/pcre2_convert.c \
  src/pcre2_dfa_match.c \
  src/pcre2_error.c \
  src/pcre2_extuni.c \
  src/pcre2_find_bracket.c \
  src/pcre2_internal.h \
  src/pcre2_intmodedep.h \
  src/pcre2_jit_compile.c \
  src/pcre2_maketables.c \
  src/pcre2_match.c \
  src/pcre2_match_data.c \
  src/pcre2_newline.c \
  src/pcre2_ord2utf.c \
  src/pcre2_pattern_info.c \
  src/pcre2_serialize.c \
  src/pcre2_string_utils.c \
  src/pcre2_study.c \
  src/pcre2_substitute.c \
  src/pcre2_substring.c \
  src/pcre2_tables.c \
  src/pcre2_ucd.c \
  src/pcre2_ucp.h \
  src/pcre2_valid_utf.c \
  src/pcre2_xclass.c


include $(BUILD_SHARED_LIBRARY)



