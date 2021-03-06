/**********************************************************************

  ruby/mvm.h -

  $Author$
  created at: Sun 10 12:06:15 Jun JST 2007

  Copyright (C) 2007-2008 Yukihiro Matsumoto

**********************************************************************/

#ifndef RUBY_H
#define RUBY_H 1

#define HAVE_RUBY_DEFINES_H     1
#define HAVE_RUBY_ENCODING_H    1
#define HAVE_RUBY_INTERN_H      1
#define HAVE_RUBY_IO_H          1
#define HAVE_RUBY_MISSING_H     1
#define HAVE_RUBY_MVM_H         1
#define HAVE_RUBY_NODE_H        1
#define HAVE_RUBY_ONIGURUMA_H   1
#define HAVE_RUBY_RE_H          1
#define HAVE_RUBY_REGEX_H       1
#define HAVE_RUBY_RUBY_H        1
#define HAVE_RUBY_SIGNAL_H      1
#define HAVE_RUBY_ST_H          1
#define HAVE_RUBY_UTIL_H        1
#ifdef _WIN32
#define HAVE_RUBY_WIN32_H       1
#endif

#include "ruby/ruby.h"
#if RUBY_VM
#include "ruby/mvm.h"
#endif

extern void ruby_set_debug_option(const char *);
#endif /* RUBY_H */
