#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include <syslog.h>

SEXP rsyslog_openlog(SEXP ident, SEXP open_immediately, SEXP include_pid, SEXP errors_to_console);
SEXP rsyslog_syslog(SEXP msg, SEXP level);
SEXP rsyslog_closelog();
