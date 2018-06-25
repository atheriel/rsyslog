#include <Rinternals.h>
#include <R_ext/Rdynload.h>

// syslog.h is not usually available on Windows.
#ifndef _WIN32
#include <syslog.h>
#define HAS_SYSLOG
#endif

SEXP rsyslog_openlog(SEXP identifier, SEXP open_immediately, SEXP include_pid,
                     SEXP fallback_to_console, SEXP echo, SEXP facility);
SEXP rsyslog_syslog(SEXP msg, SEXP level, SEXP facility);
SEXP rsyslog_closelog();
SEXP rsyslog_setlogmask(SEXP level);
