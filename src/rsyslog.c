#include "rsyslog.h"

SEXP rsyslog_openlog(SEXP identifier, SEXP open_immediately, SEXP include_pid,
                     SEXP fallback_to_console, SEXP echo, SEXP facility) {
  const char* ident = CHAR(asChar(identifier));
  int options = 0, facility_ = LOG_USER; // The defaults.
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
  if (!isNull(facility)) {
    facility_ = asInteger(facility) << 3;
  }

  openlog(ident, options, facility_);
  return R_NilValue;
}

SEXP rsyslog_syslog(SEXP msg, SEXP level, SEXP facility) {
  int priority = asInteger(level);
  if (!isNull(facility)) {
    priority |= (asInteger(facility) << 3);
  }
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
  {"rsyslog_openlog", (DL_FUNC) &rsyslog_openlog, 6},
  {"rsyslog_syslog", (DL_FUNC) &rsyslog_syslog, 3},
  {NULL, NULL, 0}
};

void R_init_rsyslog(DllInfo *info) {
  R_registerRoutines(info, NULL, rsyslog_entries, NULL, NULL);
  R_useDynamicSymbols(info, FALSE);
}
