#define STRICT_R_HEADERS
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

// syslog.h is not usually available on Windows.
#ifndef _WIN32
#define _XOPEN_SOURCE 600 // Declare the need for POSIX.1-2001 functions.
#include <syslog.h>
#define HAS_SYSLOG
#endif

SEXP rsyslog_openlog(SEXP identifier, SEXP open_immediately, SEXP include_pid,
                     SEXP fallback_to_console, SEXP echo, SEXP facility);
SEXP rsyslog_syslog(SEXP msg, SEXP level, SEXP facility);
SEXP rsyslog_closelog(void);
SEXP rsyslog_setlogmask(SEXP level);
