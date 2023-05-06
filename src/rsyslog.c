#include "rsyslog.h"

SEXP rsyslog_openlog(SEXP identifier, SEXP open_immediately, SEXP include_pid,
                     SEXP fallback_to_console, SEXP echo, SEXP facility) {
#ifdef HAS_SYSLOG
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
#ifdef LOG_PERROR
    options |= LOG_PERROR;
#else
    Rf_warning("Cannot echo syslog messages to standard error: LOG_PERROR is \
not available on this platform.");
#endif
  }
  if (!isNull(facility)) {
    facility_ = asInteger(facility) << 3;
  }

  openlog(ident, options, facility_);
#else
  Rf_error("syslog.h is not available on this platform.");
#endif
  return R_NilValue;
}

SEXP rsyslog_syslog(SEXP msg, SEXP level, SEXP facility) {
#ifdef HAS_SYSLOG
  int priority = asInteger(level);
  if (!isNull(facility)) {
    priority |= (asInteger(facility) << 3);
  }
  const char* msg_ = CHAR(asChar(msg));
  syslog(priority, "%s", msg_);
#else
  Rf_error("syslog.h is not available on this platform.");
#endif
  return R_NilValue;
}

SEXP rsyslog_closelog(void) {
#ifdef HAS_SYSLOG
  closelog();
#else
  Rf_error("syslog.h is not available on this platform.");
#endif
  return R_NilValue;
}

SEXP rsyslog_setlogmask(SEXP level) {
#ifdef HAS_SYSLOG
  int priority = asInteger(level);
  setlogmask(LOG_UPTO(priority));
#else
  Rf_error("syslog.h is not available on this platform.");
#endif
  return R_NilValue;
}

static const R_CallMethodDef rsyslog_entries[] = {
  {"rsyslog_openlog", (DL_FUNC) &rsyslog_openlog, 6},
  {"rsyslog_syslog", (DL_FUNC) &rsyslog_syslog, 3},
  {"rsyslog_closelog", (DL_FUNC) &rsyslog_closelog, 0},
  {"rsyslog_setlogmask", (DL_FUNC) &rsyslog_setlogmask, 1},
  {NULL, NULL, 0}
};

void R_init_rsyslog(DllInfo *info) {
  R_registerRoutines(info, NULL, rsyslog_entries, NULL, NULL);
  R_useDynamicSymbols(info, FALSE);
}
