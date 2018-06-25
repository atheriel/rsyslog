#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include <syslog.h>

SEXP rsyslog_openlog(SEXP identifier, SEXP open_immediately, SEXP include_pid,
                     SEXP fallback_to_console, SEXP echo, SEXP facility);
SEXP rsyslog_syslog(SEXP msg, SEXP level, SEXP facility);
SEXP rsyslog_closelog();
