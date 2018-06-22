#include "rsyslog.h"

SEXP rsyslog_openlog(SEXP name, SEXP open_immediately, SEXP include_pid,
                     SEXP fallback_to_console, SEXP echo) {
  const char* ident = CHAR(asChar(name));
  int options = 0;
  if (asLogical(open_immediately)) {
    options |= LOG_NDELAY;
  }
  if (asLogical(include_pid)) {
    options |= LOG_PID;
  }
  if (asLogical(fallback_to_console)) {
    options |= LOG_CONS;
  }
  if (asLogical(echo)) {
    options |= LOG_PERROR;
  }
  // NOTE: We could allow customization of facility, but I'm not sure there is
  // a resonable use case.
  openlog(ident, options, LOG_USER);
  return R_NilValue;
}

SEXP rsyslog_syslog(SEXP msg, SEXP level) {
  int priority = asInteger(level) | LOG_USER;
  const char* msg_ = CHAR(asChar(msg));
  syslog(priority, "%s", msg_);
  return R_NilValue;
}

SEXP rsyslog_closelog() {
  closelog();
  return R_NilValue;
}

static const R_CallMethodDef rsyslog_entries[] = {
  {"rsyslog_closelog", (DL_FUNC) &rsyslog_closelog, 0},
  {"rsyslog_openlog", (DL_FUNC) &rsyslog_openlog, 5},
  {"rsyslog_syslog", (DL_FUNC) &rsyslog_syslog, 2},
  {NULL, NULL, 0}
};

void R_init_rsyslog(DllInfo *info) {
  R_registerRoutines(info, NULL, rsyslog_entries, NULL, NULL);
  R_useDynamicSymbols(info, FALSE);
}
